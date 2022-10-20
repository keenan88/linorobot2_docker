FROM osrf/ros:humble-desktop

# use bash instead of sh
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt-get update && apt-get install --yes python3-pip

# create workspace
RUN mkdir -p /ros2_ws/src
WORKDIR /ros2_ws



RUN git clone https://github.com/linorobot/linorobot2.git && mv linorobot2 src && cd src && cd linorobot2 && git checkout fbcce1cd30cca7340915db62c74e56e71b6b881c

# build ROS packages and allow non-compiled
# sources to be edited without rebuild
RUN source /opt/ros/humble/setup.bash && colcon build --symlink-install

# add packages to path
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
