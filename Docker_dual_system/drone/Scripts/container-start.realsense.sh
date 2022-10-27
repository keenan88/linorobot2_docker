#!/usr/bin/env bash

cd /dev_ws
source /opt/ros/galactic/setup.bash

if [ "$COLCON_ON_SPIN" = true ]; then 
    colcon build; 
fi

colcon build --packages-select drone_os drone_sim
source install/setup.bash
ros2 launch drone_os realsense.launch.py
bash # So container doesn't close itself.