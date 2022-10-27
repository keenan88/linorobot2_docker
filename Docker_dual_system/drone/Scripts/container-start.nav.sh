#!/usr/bin/env bash

cd /dev_ws
source /opt/ros/galactic/setup.bash

if [ "$COLCON_ON_SPIN" = true ]; then 
    colcon build; 
fi

colcon build --packages-select drone_os drone_sim drone_nav

source install/setup.bash
ros2 launch drone_nav laserscan.launch.py &
ros2 launch drone_nav localization.launch.py &
ros2 launch drone_nav navigator.launch.py &
ros2 launch drone_nav ekf_filter.launch.py &
bash # So container doesn't close itself.