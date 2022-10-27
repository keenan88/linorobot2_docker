#!/usr/bin/env bash

cd /dev_ws
source /opt/ros/galactic/setup.bash

colcon build
source install/setup.bash

gnome-terminal -- bash -c "source install/setup.bash; ros2 launch linorobot2_gazebo gazebo.launch.py; exec bash"
gnome-terminal -- bash -c "source install/setup.bash; ros2 launch linorobot2_navigation navigation.launch.py sim:=true rviz:=true; exec bash"
bash # Prevents container from closing
