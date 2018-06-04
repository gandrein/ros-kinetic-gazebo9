#! /bin/bash
set -e

if [ -z ${TERMINAL+x} ]; then
	TERMINAL=""
fi

if [ -z ${SHELL+x} ]; then
	SHELL="/bin/bash"
fi

# Source ROS setup
source  "/opt/ros/kinetic/setup.bash"

# Source environment variables for Gazebo
source "/usr/share/gazebo/setup.sh"

# Disable loading of Gazebo models from online model database
# Only local models to be used when mapped accordingly yo $HOME/.gazebo/models
export GAZEBO_MODEL_DATABASE_URI=""
export GAZEBO_MODEL_PATH=$HOME/.gazebo/models

# Change shell (default will remain to /bin/bash)
usermod -s $SHELL $(id -un)

exec $TERMINAL && "$@"