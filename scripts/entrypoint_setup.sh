#! /bin/bash
set -e

# Functions

# TOOD: Check if we can use: getent passwd $USER to extract all variables
# TODO: Check for valid inputs, cause now it will go through even with bad inputs
check_envs () {
    DOCKER_CUSTOM_USER_OK=true;
    if [ -z ${DOCKER_USER_NAME+x} ]; then 
        DOCKER_CUSTOM_USER_OK=false;
        return;
    fi
    
    if [ -z ${DOCKER_USER_ID+x} ]; then 
        DOCKER_CUSTOM_USER_OK=false;
        return;
    else
        if ! [ -z "${DOCKER_USER_ID##[0-9]*}" ]; then 
            echo -e "\033[1;33mWarning: User-ID should be a number. Falling back to defaults.\033[0m"
            DOCKER_CUSTOM_USER_OK=false;
            return;
        fi
    fi
    
    if [ -z ${DOCKER_USER_GROUP_NAME+x} ]; then 
        DOCKER_CUSTOM_USER_OK=false;
        return;
    fi

    if [ -z ${DOCKER_USER_GROUP_ID+x} ]; then 
        DOCKER_CUSTOM_USER_OK=false;
        return;
    else
        if ! [ -z "${DOCKER_USER_GROUP_ID##[0-9]*}" ]; then 
            echo -e "\033[1;33mWarning: Group-ID should be a number. Falling back to defaults.\033[0m"
            DOCKER_CUSTOM_USER_OK=false;
            return;
        fi
    fi
}

setup_env_user () {
    USER=$1
    USER_ID=$2
    GROUP=$3
    GROUP_ID=$4

    ## Create user
    useradd -m $USER
    chown -R $USER:$GROUP /home/$DOCKER_USER_NAME

    ## Setup Password-file
    PASSWDCONTENTS=$(grep -v "^${USER}:" /etc/passwd)
    GROUPCONTENTS=$(grep -v -e "^${GROUP}:" -e "^docker:" /etc/group)

    (echo "${PASSWDCONTENTS}" && echo "${USER}:x:$USER_ID:$GROUP_ID::/home/$USER:/bin/bash") > /etc/passwd
    (echo "${GROUPCONTENTS}" && echo "${GROUP}:x:${GROUP_ID}:") > /etc/group
    (if test -f /etc/sudoers ; then echo "${USER}  ALL=(ALL)   NOPASSWD: ALL" >> /etc/sudoers ; fi)
}


# -Main-

## Defaults
if [ -z ${TERMINAL+x} ]; then
	TERMINAL="/bin/bash"
fi

if [ -z ${SHELL+x} ]; then
	SHELL="/bin/bash"
fi

# Create new user
## Check Inputs
check_envs

## Determine user & Setup Environment
if [ $DOCKER_CUSTOM_USER_OK == true ]; then
    echo "  -->DOCKER_USER Input is set to '$DOCKER_USER_NAME:$DOCKER_USER_ID:$DOCKER_USER_GROUP_NAME:$DOCKER_USER_GROUP_ID'";
    echo -e "\033[0;32mSetting up environment for user=$DOCKER_USER_NAME\033[0m"
    setup_env_user $DOCKER_USER_NAME $DOCKER_USER_ID $DOCKER_USER_GROUP_NAME $DOCKER_USER_GROUP_ID
else
    echo "  -->DOCKER_USER* variables not set. Using 'root'.";
    echo -e "\033[0;32mSetting up environment for user=root\033[0m"
    DOCKER_USER_NAME="root"
fi


## Switch to $DOCKER_USER_NAME
# su - $DOCKER_USER_NAME &

# Source ROS setup
source  "/opt/ros/kinetic/setup.bash"

# Source environment variables for Gazebo
source "/usr/share/gazebo/setup.sh"

# Disable loading of Gazebo models from online model database
# Only local models to be used when mapped accordingly yo $HOME/.gazebo/models
export GAZEBO_MODEL_DATABASE_URI=""
export GAZEBO_MODEL_PATH=$HOME/.gazebo/models

# Change shell (default will remain to /bin/bash)
usermod -s $SHELL $DOCKER_USER_NAME

exec sudo -u $DOCKER_USER_NAME -H $TERMINAL && "$@"