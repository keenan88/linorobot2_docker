#!/usr/bin/env bash

gnome-terminal -- bash -c "source install/setup.bash; ros2 launch linorobot2_gazebo gazebo.launch.py; exec bash"
gnome-terminal -- bash -c "source install/setup.bash; ros2 launch linorobot2_navigation navigation.launch.py sim:=true rviz:=true; exec bash"
bash # Prevents container from closing
