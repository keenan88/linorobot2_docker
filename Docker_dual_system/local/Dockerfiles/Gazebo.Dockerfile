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

RUN mkdir /dev_ws && mkdir /dev_ws/src

RUN apt-get update \
    && apt-get install -y \
        ros-galactic-ros-core \
        ros-galactic-gazebo-ros-pkgs \
        ros-galactic-ros2-control \
        ros-galactic-ros2-controllers

RUN apt-get update \
    && apt-get install -y \
        ros-galactic-effort-controllers \
        ros-galactic-gazebo-ros2-control \
        ros-galactic-gazebo-plugins \
        ros-galactic-hardware-interface

## pkgs for gazebo_ros2_control
RUN apt-get update --fix-missing \
    && apt-get install -y \
        ros-galactic-controller-interface \
        ros-galactic-controller-manager

# Realsense gazebo things
RUN apt-get update \
    && git clone -b foxy-devel https://github.com/pal-robotics/realsense_gazebo_plugin.git /dev_ws/src/realsense_gazebo_plugin

RUN apt-get update && apt-get upgrade -y

RUN git clone https://github.com/chaolmu/gazebo_models_worlds_collection.git /dev_ws/src/gazebo_models_worlds_collection

ARG COLCON_ON_BUILD true
ENV COLCON_ON_BUILD ${COLCON_ON_BUILD}
RUN if [ "$COLCON_ON_BUILD" = true ]; then \
        cd /dev_ws; \
        . /opt/ros/$ROS_DISTRO/setup.sh; \
        colcon build; \
        fi

ADD ./Scripts/container-start.gazebo.sh /container-start.sh
RUN chmod +x /container-start.sh