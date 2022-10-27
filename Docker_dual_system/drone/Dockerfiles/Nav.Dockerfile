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

# Move this to the top-ish at some point
RUN apt-get update && apt-get upgrade -y

RUN apt-get update \
    && apt-get install -y \
        ros-${ROS_DISTRO}-slam-toolbox \
        ros-${ROS_DISTRO}-nav2-bringup \
        ros-${ROS_DISTRO}-robot-localization \
        ros-${ROS_DISTRO}-cartographer-ros \
        ros-${ROS_DISTRO}-tf-transformations

ARG COLCON_ON_BUILD true
ENV COLCON_ON_BUILD ${COLCON_ON_BUILD}
RUN if [ "$COLCON_ON_BUILD" = true ]; then \
        cd /dev_ws; \
        . /opt/ros/$ROS_DISTRO/setup.sh; \
        colcon build --packages-ignore realsense_gazebo_plugin; \
        fi

ADD ./Scripts/container-start.nav.sh /container-start.sh
RUN chmod +x /container-start.sh