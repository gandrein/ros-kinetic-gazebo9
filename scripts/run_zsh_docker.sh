#!/usr/bin/env bash

# Check args
if [ "$#" -lt 1 ]; then
  echo "usage: ./run_base_docker.sh IMAGE_NAME"
  return 1
fi

set -e

IMAGE_NAME=$1 && shift 1
# NVIDIA_DOCKER_VERSION=$(dpkg -l | grep nvidia-docker | awk '{ print $3 }' | awk -F'[_.]' '{print $1}')

# Determine the appropriate version of the docker run command
# if [ $NVIDIA_DOCKER_VERSION = "1" ]; then
    docker_run_cmd="nvidia-docker run --rm"
# elif [ $NVIDIA_DOCKER_VERSION = "2" ]; then
    # docker_run_cmd="docker run --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=0 --rm"
# else
#     echo "[Warning] nvidia-docker not installed, running docker without Nvidia hardware acceleration / OpenGL support"
#     docker_run_cmd="docker run --rm"
# fi

# Determine configured user for the docker image
# docker_user=$(docker image inspect --format '{{.Config.User}}' $IMAGE_NAME)
docker_user=$(id -un)
if [ "$docker_user" = "" ]; then
    dHOME_FOLDER="/root"
else
    dHOME_FOLDER="/home/$docker_user"    
fi

MODELS_FOLDER=$HOME/Projects/devs/simulation/gazebo/utils/models_online_db

# Run the container with NVIDIA Graphics acceleration, shared network interface, shared hostname, shared X11
$(echo $docker_run_cmd) \
  --net=host \
  --ipc=host \
  --privileged \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v $HOME/.Xauthority:$dHOME_FOLDER/.Xauthority \
  -e XAUTHORITY=$dHOME_FOLDER/.Xauthority \
  -e DISPLAY=$DISPLAY \
  -e DOCKER_USER_NAME=$(id -un) \
  -e DOCKER_USER_ID=$(id -u) \
  -e DOCKER_USER_GROUP_NAME=$(id -gn) \
  -e DOCKER_USER_GROUP_ID=a$(id -g) \
  -e SHELL=/usr/bin/zsh \
  -v $HOME/Projects/devs/simulation/gazebo/utils/models_online_db:$dHOME_FOLDER/.gazebo/models \
  -it $IMAGE_NAME "$@"
