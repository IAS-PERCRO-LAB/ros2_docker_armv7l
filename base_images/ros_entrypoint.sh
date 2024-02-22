#!/bin/bash
set -e

# setup ros2 environment
source "/ros2_humble/install/setup.bash" --
exec "$@"
