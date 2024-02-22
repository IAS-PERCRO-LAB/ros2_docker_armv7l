#!/bin/bash
set -e

script_dir="$( cd "$(dirname "$0")" ; pwd -P )"

# detect host architecture
host_arch=$(uname -m)

if [ $host_arch != 'armv7l' ]; then
    ARGS="--platform linux/arm/v7"
fi

docker run -it --rm $ARGS \
    --env TERM=xterm-256color \
    --group-add tty \
    --group-add dialout \
    --group-add uucp \
    --privileged \
    --network host \
    -v /dev:/dev \
    -v "$script_dir"/ws:/home/docker/ws \
    --name ros2 \
    ros2
