#!/bin/bash
set -e

# First build the core image
echo "=> Building the core image..."
docker build \
    -t ros:humble-ros-core \
    -f humble-ros-core.dockerfile .

# Then build the base image
echo "=> Building the base image..."
docker build \
    -t ros:humble-ros-base \
    -f humble-ros-base.dockerfile .
