#!/bin/bash
set -e

# setup ros2 environment
source "/ros2_humble/install/setup.bash" --
source "/home/docker/ws_deps/install/local_setup.bash" --
exec "$@"
