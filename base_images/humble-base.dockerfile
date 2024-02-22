# https://docs.ros.org/en/humble/Installation/Alternatives/Ubuntu-Development-Setup.html

FROM --platform=linux/arm/v7 ubuntu:jammy

# setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt update && apt install -q -y --no-install-recommends \
        tzdata && \
    rm -rf /var/lib/apt/lists/*

# install base packages
RUN apt update && apt install -q -y --no-install-recommends \
        dirmngr gnupg2 curl software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# setup keys
# RUN set -eux; \
#        key='C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654'; \
#        export GNUPGHOME="$(mktemp -d)"; \
#        gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
#        mkdir -p /usr/share/keyrings; \
#        gpg --batch --export "$key" > /usr/share/keyrings/ros2-latest-archive-keyring.gpg; \
#        gpgconf --kill all; \
#        rm -rf "$GNUPGHOME"
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# setup sources.list
# RUN echo "deb [ signed-by=/usr/share/keyrings/ros2-latest-archive-keyring.gpg ] http://packages.ros.org/ros2/ubuntu jammy main" > /etc/apt/sources.list.d/ros2-latest.list
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" > /etc/apt/sources.list.d/ros2.list

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV ROS_DISTRO humble

# RUN add-apt-repository universe

# install development tools
RUN apt update && apt install -y \
        python3-flake8-docstrings  python3-pip  python3-pytest-cov  ros-dev-tools \
        python3-flake8-blind-except python3-flake8-builtins python3-flake8-class-newline \
        python3-flake8-comprehensions python3-flake8-deprecated python3-flake8-import-order \
        python3-flake8-quotes python3-pytest-repeat python3-pytest-rerunfailures && \
    rm -rf /var/lib/apt/lists/*

# collect ROS2 Humble sources
WORKDIR /ros2_humble
RUN mkdir src && vcs import --input https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos src && \
    rm -rf src/ros-visualization src/ros2/rviz

# install source dependencies
RUN apt update && rosdep init && rosdep update && \
    rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers" && \
    rm -rf /var/lib/apt/lists/* /root/.ros/rosdep

# build all sources
RUN colcon build --symlink-install

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
