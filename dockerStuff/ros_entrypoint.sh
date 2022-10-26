ERRORRORSORSORSOSRO

#!/usr/bin

cd /ros2_ws
source /opt/ros/galactic/setup.bash
colcon build; source install/setup.bash


gnome-terminal -e 'ros2 run teleop_twist_keyboard teleop_twist_keyboard'


gnome-terminal
bash # Prevents container from closing
