#!/usr/bin/env bash

cd /dev_ws
source /opt/ros/galactic/setup.bash

if [ "$COLCON_ON_SPIN" = true ]; then 
    colcon build; 
fi

colcon build --packages-select drone_os drone_sim drone_nav

source install/setup.bash
ros2 launch drone_sim launch_sim.launch.py &
ros2 launch drone_os boot_os.launch.py &
# ros2 run drone_os wheel_odometry &
bash # So container doesn't close itself.