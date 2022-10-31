How to Run:

1. Clone this repo
2. Cd into /linorobot2_docker/docker_bootstrap, and run $docker compose up -d. This will open an instance of Gazebo and RVIZ, with Nav2 functionality visible in Rviz.
3. Use Rviz to provide a 2D Pose Estimate to the robot, then use RVIZ to provide a Nav2 Goal to the robot.

Original Repo: https://github.com/linorobot/linorobot2/tree/galactic
Nvidia libraries required on local machine for docker compose: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
(If you dont have these, comment out the nvidia part of the docker compose file)
