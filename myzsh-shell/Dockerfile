# Based on the base/generic image
FROM codookie/xenial:ros-kinetic-gazebo9-base

MAINTAINER Andrei Gherghescu <andrei.gherghescu@protonmail.com>

LABEL Description="ROS-Kinetic-Full-Desktop & Gazebo 9 for Ubuntu 16.04 with OhMyZSH" Version="1.0"

# Install and configure OhMyZSH
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true \
 && git clone https://github.com/sindresorhus/pure $HOME/.oh-my-zsh/custom/pure \
 && ln -s $HOME/.oh-my-zsh/custom/pure/pure.zsh-theme $HOME/.oh-my-zsh/custom/ \
 && ln -s $HOME/.oh-my-zsh/custom/pure/async.zsh $HOME/.oh-my-zsh/custom/ \
 && sed -i -e 's/robbyrussell/refined/g' $HOME/.zshrc

# Copy Terminator Configuration files
# '$HOME' does not seem to work with the COPY directive
RUN mkdir -p /root/.config/terminator/
COPY configs/terminator_config /root/.config/terminator/config
COPY configs/bash_aliases /root/.bash_aliases

# Using the "exec" form for the Entrypoint command
ENTRYPOINT ["./entrypoint_setup.sh"]
CMD ["/bin/bash"]
