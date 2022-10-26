FROM osrf/ros:galactic-desktop

# use bash instead of sh
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt-get update && apt-get install --yes python3-pip

# Nvidia graphics card dependencies
RUN apt-get update && apt-get -y install \
    gstreamer1.0-tools \
    gstreamer1.0-libav \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-good1.0-dev \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-base

# set nvidia varables
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# create workspace
RUN mkdir -p /ros2_ws/src
WORKDIR /ros2_ws

COPY linorobot2 .
RUN rosdep update && rosdep install --from-path src linorobot2 --ignore-src -y --skip-keys microxrcedds_agent --skip-keys micro_ros_agent

RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc \
&& echo "export LINOROBOT2_BASE=mecanum" >> ~/.bashrc \
&& source ~/.bashrc && source /opt/ros/galactic/setup.bash && colcon build && source install/setup.bash

ADD dockerStuff/ros_entrypoint.sh .
RUN chmod +x ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoinasdfasdft.sh"]
CMD ["bash"]

RUN echo hi
