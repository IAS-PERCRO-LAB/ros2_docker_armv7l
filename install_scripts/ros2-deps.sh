#!/bin/bash
set -e

ROS_DISTRO="humble"

sudo apt-get -y update
sudo apt-get -y upgrade

mkdir -p ~/ws_deps
cd ~/ws_deps

sudo apt-get update
rosdep update --rosdistro=$ROS_DISTRO

# # ros2_tcp_tunnel
# source /opt/ros/$ROS_DISTRO/setup.bash && \
# 	cd ~/ros2_ws_deps/src && \
#   git clone -b $ROS_DISTRO https://github.com/norlab-ulaval/ros2_tcp_tunnel.git && \
# 	cd .. && \
# 	colcon build --symlink-install --event-handlers console_direct+ --packages-skip-build-finished

# micro-ROS
git clone -b $ROS_DISTRO https://github.com/micro-ROS/micro_ros_setup.git src/micro_ros_setup
rosdep install --from-paths src --ignore-src -y
colcon build --symlink-install --event-handlers console_direct+ --packages-skip-build-finished
source ./install/local_setup.bash
EXTERNAL_SKIP="librealsense2" ros2 run micro_ros_setup create_agent_ws.sh
ros2 run micro_ros_setup build_agent.sh
