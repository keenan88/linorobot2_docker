# This needs to be split into more containers for each process.

FROM osrf/ros:galactic-desktop

LABEL maintainter="Jackson Vanderkooy"

ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

#Setup timezone so future installs don't get stuck
RUN apt-get update \
    && apt-get install -y gnupg tzdata \
    && echo "EST" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

# Python Requirements
RUN apt-get update \
    && apt-get install -y \
        python3 \
        python-is-python3 \
        pip \
    && pip install \
        imutils \
        opencv-python

RUN mkdir /dev_ws && mkdir /dev_ws/src

#ROS packages separate so rebuild is faster
RUN apt-get update \
    && apt-get install -y \
        ros-galactic-xacro \
        ros-galactic-ros-core \
        ros-galactic-gazebo-ros-pkgs \
        ros-galactic-ros2-control \
        ros-galactic-ros2-controllers

RUN apt-get update \
    && apt-get install -y \
        ros-galactic-effort-controllers \
        ros-galactic-gazebo-ros2-control \
        ros-galactic-joint-state-publisher \
        ros-galactic-gazebo-plugins \
        ros-galactic-hardware-interface

## pkgs for gazebo_ros2_control
RUN apt-get update --fix-missing \
    && apt-get install -y \
        ros-galactic-controller-interface \
        ros-galactic-controller-manager

## Odrive support
RUN apt-get update \
    && apt-get install -y \
        libusb-1.0-0-dev \
    && pip install odrive==0.5.3.post0

RUN git clone -b labs https://github.com/ecoation-labs/odrive_ros2_control_drone.git /temp/odrive_ros2_control \
    && cp -r /temp/odrive_ros2_control/odrive_hardware_interface /dev_ws/src/odrive_hardware_interface \
    && rm -rf /temp/odrive_ros2_control

# Realsense hardware things
RUN apt-get update \
    && apt-get install -y \
        ros-$ROS_DISTRO-realsense2-camera \
        ros-$ROS_DISTRO-realsense2-description \
    && cd /dev_ws/src \
    && git clone --depth 1 --branch `git ls-remote --tags https://github.com/IntelRealSense/realsense-ros.git | grep -Po "(?<=tags/)3.\d+\.\d+" | sort -V | tail -1` https://github.com/IntelRealSense/realsense-ros.git \ 
    && cd /dev_ws \
    && rosdep update \
    && rosdep install -i --from-path src --rosdistro $ROS_DISTRO --skip-keys=librealsense2 -y \
    && . /opt/ros/$ROS_DISTRO/setup.sh \
    && colcon build --packages-select realsense2_camera_msgs realsense2_camera realsense2_description
# Realsense gazebo things
# RUN apt-get update \
#     && git clone -b foxy-devel https://github.com/pal-robotics/realsense_gazebo_plugin.git /dev_ws/src/realsense_gazebo_plugin

# Move this to the top-ish at some point
RUN apt-get update && apt-get upgrade -y

RUN apt-get update \
    && apt-get install -y \ 
        ros-${ROS_DISTRO}-depthimage-to-laserscan

ARG COLCON_ON_BUILD true
ENV COLCON_ON_BUILD ${COLCON_ON_BUILD}
RUN if [ "$COLCON_ON_BUILD" = true ]; then \
        cd /dev_ws; \
        . /opt/ros/$ROS_DISTRO/setup.sh; \
        colcon build --packages-ignore realsense_gazebo_plugin; \
        fi

ADD ./Scripts/container-start.realsense.sh /container-start.sh
RUN chmod +x /container-start.sh