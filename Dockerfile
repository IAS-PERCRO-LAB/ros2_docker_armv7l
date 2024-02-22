FROM --platform=linux/arm/v7 ros:humble-base

ARG USER=docker
ARG USER_ID=1000
ARG GROUP_ID=1000

# Base dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install --no-install-recommends -y \
        vim git build-essential tmux udev htop \
        python3-jinja2 python3-setuptools python3-venv \
        curl wget unzip bash-completion lsb-release
#    && apt-get -y autoremove && apt-get clean

ENV TZ=Europe/Rome

# Configure normal user with same IDs as in the host
RUN addgroup --gid $GROUP_ID ${USER} && \
    adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID ${USER} && \
    adduser ${USER} sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# # micro-ROS - asio tinyxml2
# RUN apt update && apt install -y \
#         curl python3-yaml clang-tidy \
#         flex bison libncurses-dev usbutils
# USER ${USER}
# WORKDIR /home/${USER}/ws_deps
# RUN git clone -b $ROS_DISTRO https://github.com/micro-ROS/micro_ros_setup.git src/micro_ros_setup && \
#     bash -c "source /ros2_humble/install/setup.bash && \
#         colcon build --symlink-install --event-handlers console_direct+ --packages-skip-build-finished && \
#         source ./install/local_setup.bash && \
#         EXTERNAL_SKIP='librealsense2' ros2 run micro_ros_setup create_agent_ws.sh && \
#         ros2 run micro_ros_setup build_agent.sh"

WORKDIR /home/${USER}/ws
ENV ROS2_WS /home/${USER}/ws

# # setup entrypoint
# COPY ./ros_entrypoint.sh /

# # ENTRYPOINT ["/ros_entrypoint.sh"]
# CMD ["bash"]

# vim: set et fenc=utf-8 ff=unix ft=dockerfile sts=0 sw=2 ts=2 :
