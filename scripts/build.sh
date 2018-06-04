#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
  echo "usage: ./build.sh IMAGE_NAME TARGET_PLATFORM_NAME"
  exit 1
fi

IMAGE_NAME=$1
TARGET_PLATFORM_NAME=$2

# Copy custom config files
this_dir=$(dirname "$0")
# Copy custom entrypoint script
cp $this_dir/entrypoint_setup.sh $TARGET_PLATFORM_NAME/entrypoint_setup.sh

# Build the docker image
docker build \
  -t $IMAGE_NAME $TARGET_PLATFORM_NAME

# Clean up
# Remove copied script
rm -rf $TARGET_PLATFORM_NAME/entrypoint_setup.sh


