FROM osrf/ros:humble-ros-base

ARG USER=docker
ARG USER_ID=1000
ARG GROUP_ID=1000

# Base dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install --no-install-recommends -y \
        vim git build-essential tmux udev htop \
        python3-jinja2 python3-setuptools python3-venv python3-pip \
        tzdata curl wget unzip bash-completion lsb-release \
        ros-humble-rqt-tf-tree ros-humble-plotjuggler-ros
#    && apt-get -y autoremove && apt-get clean

ENV TZ=Europe/Rome

# Configure normal user with same IDs as in the host
RUN addgroup --gid $GROUP_ID ${USER} && \
  adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID ${USER} && \
  adduser ${USER} sudo && \
  echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER ${USER}

# Additional setup
COPY install_scripts/ros2-deps.sh /tmp/install_scripts/ros2-deps.sh
RUN sudo chmod +x /tmp/install_scripts/ros2-deps.sh && /tmp/install_scripts/ros2-deps.sh

WORKDIR /home/${USER}/ws
ENV ROS2_WS /home/${USER}/ws

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

# vim: set et fenc=utf-8 ff=unix ft=dockerfile sts=0 sw=2 ts=2 :
