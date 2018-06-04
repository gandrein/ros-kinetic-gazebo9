FROM ubuntu:xenial

MAINTAINER Andrei Gherghescu <andrei.gherghescu@protonmail.com>

LABEL Description="ROS-Kinetic-Full-Desktop & Gazebo 9 for Ubuntu 16.04" Version="1.0"

# ------------------------------------------ Install required (&useful) packages --------------------------------------
RUN apt-get update && apt-get install -y \
 	software-properties-common python-software-properties \
 	lsb-release locales\
 	mesa-utils apt-utils \
 	wget curl unzip \
 	git subversion \
 	nano vim zsh ssh \
 	cmake gdb \
 	sudo vim \
 	gnome-terminal terminator \
 	python-rosdep python-rosinstall \
 	python3-pip python-pip \
 	build-essential \
 	net-tools iputils-ping \
    && sudo locale-gen en_US.UTF-8 \
    && sudo rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# ---------------------------------- ROS-Kinetic Desktop Full Image -----------------------------
# Based on 
# https://github.com/osrf/docker_images/blob/5399f380af0a7735405a4b6a07c6c40b867563bd/ros/kinetic/ubuntu/xenial/desktop-full/Dockerfile

# Install ROS
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN apt-get update && apt-get install -y ros-kinetic-desktop-full \
 	&& rm -rf /var/lib/apt/lists/*

RUN pip install catkin_tools

# Configure ROS
RUN sudo rosdep init && sudo rosdep fix-permissions && rosdep update
RUN echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc


# ---------------------------------- Gazebo 9  -----------------------------
# Setup osrfoundation repository keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D2486D2DD83DB69272AFE98867170598AF249743

# Add osrfoundation repository to sources.list
RUN . /etc/os-release \
    && . /etc/lsb-release \
    && echo "deb http://packages.osrfoundation.org/gazebo/$ID-stable $DISTRIB_CODENAME main" > /etc/apt/sources.list.d/gazebo-latest.list

# Remove Gazebo installed with ROS-Kinetic full
RUN sudo apt-get purge gazebo* -y
RUN sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get install -y \
	gazebo9 \
	ros-kinetic-gazebo9-ros-pkgs \
	ros-kinetic-gazebo9-ros-control \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Setup environment
# Expose port
EXPOSE 11345

# Nvidia-docker hooks for machines that have Nvidia cards
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}


COPY ./entrypoint_setup.sh /

ENTRYPOINT ["/entrypoint_setup.sh"]

CMD ["/bin/bash"]


