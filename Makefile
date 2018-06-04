.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
ros-kinetic-gazebo9-base: ## Build ROS-Kinetic Xenial Docker Base Image with Gazebo9
	@printf "\033[33mBuilding Docker Image: codookie/xenial:ros-kinetic-gazebo9-base\033[0m\n"	
	./scripts/build.sh codookie/xenial:ros-kinetic-gazebo9-base base
	@printf "\033[92mBuilt Docker Image: codookie/xenial:ros-kinetic-gazebo9-base\033[0m\n\n"
ros-kinetic-gazebo9-zsh: ros-kinetic-gazebo9-base ## Build ROS-Kinetic Xenial Docker Base Image with Gazebo9 and ZSH shell
	@printf "\033[33mBuilding Docker Image: codookie/xenial:ros-kinetic-gazebo9-zsh\033[0m\n"	
	./scripts/build.sh codookie/xenial:ros-kinetic-gazebo9-zsh myzsh-shell
	@printf "\033[92mBuilt Docker Image: codookie/xenial:ros-kinetic-gazebo9-zsh\033[0m\n\n"