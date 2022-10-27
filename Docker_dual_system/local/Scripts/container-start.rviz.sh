#!/usr/bin/env bash

cd /dev_ws
source /opt/ros/galactic/setup.bash

if [ "$COLCON_ON_SPIN" = true ]; then
    colcon build;
fi

source install/setup.bash
ros2 run rviz2 rviz2 -d /dev_ws/rviz/config/config.rviz --ros-args --param use_sim_time:=true
