#!/bin/bash
set -e

# Then build the base image
echo "=> Building the base image..."
docker build \
    -t ros:humble-base \
    -f humble-base.dockerfile .
