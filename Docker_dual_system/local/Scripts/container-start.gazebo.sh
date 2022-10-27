#!/usr/bin/env bash

cd /dev_ws
source /opt/ros/galactic/setup.bash

if [ "$COLCON_ON_SPIN" = true ]; then 
    colcon build; 
fi

colcon build --packages-select ant_world

source install/setup.bash

# gazebo --verbose -s libgazebo_ros_factory.so -s libgazebo_ros_init.so $WORLD_PATH # Used for launching without ant_world pkg
if [ "$ANT_WORLD_GEN_ON_SPIN" = true ]; then
    ros2 run ant_world create_world;
fi

export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/dev_ws/src/gazebo_models_worlds_collection/models
export GAZEBO_RESOURCE_PATH=$GAZEBO_RESOURCE_PATH:/dev_ws/src/gazebo_models_worlds_collection/worlds

# ros2 launch ant_world spawn_world.launch.py world_name:=greenhouse.world;
ros2 launch ant_world spawn_world.launch.py world_path:=/dev_ws/src/gazebo_models_worlds_collection/worlds/office_small.world;
