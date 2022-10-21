FROM osrf/ros:humble-desktop

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

RUN git clone https://github.com/linorobot/linorobot2.git \
&& mv linorobot2 src \
&& rosdep update && rosdep install --from-path src --ignore-src -y --skip-keys microxrcedds_agent --skip-keys micro_ros_agent \
&& cd /ros2_ws/src/linorobot2 \
&& git checkout fbcce1cd30cca7340915db62c74e56e71b6b881c

# build ROS packages and allow non-compiled
# sources to be edited without rebuild
RUN source /opt/ros/humble/setup.bash && cd /ros2_ws && colcon build --symlink-install



# add packages to path
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc \
&& echo "export LINOROBOT2_BASE=mecanum" >> ~/.bashrc \
&& source ~/.bashrc
