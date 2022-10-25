How to Run:

1. Clone this repo
2. Within /linorobot2_docker, run $docker compose up -d
3. Once container has built, enter it with $docker exec -it linorobot2-demo-galactic bash
4. Within the container:
  1. Within /ros2_ws, run $rm -rf build install log; colcon build; source install/setup.bash
  2. To open gazebo, run $ros2 launch linorobot2_gazebo gazebo.launch.py. It may take up to 30s to open Gazebo.
  3. Open a new terminal and enter into the linorobot2-demo-galactic container. Run $source install/setup.bash from /ros2_ws.
    1. If you want to run SLAM, run $ros2 launch linorobot2_navigation slam.launch.py rviz:=true.
      1. Open a new terminal and enter into the linorobot2-demo-galactic container. Run $ros2 run teleop_twist_keyboard teleop_twist_keyboard.
    2. If you instead want to run path planning/navigation, run: $ros2 launch linorobot2_navigation navigation.launch.py rviz:=true sim:=true.
      1. You will have to provide a 2D Pose Estimate in RVIZ.
      2. Provide a Nav2 Goal with Rviz and watch the robot start to navigate along its path to the goal.   

