#!/usr/bin/env bash

set -e

# Stand up a development environment that has everything you need.

IMAGE=devenv

# The first arg is the name of the user that will be created in the container.
# All the other args will be used arguments to docker build.
# each user will have its own home directory, if you're into that kind of thing.
USER=coder
if [[ $# -gt 0 ]]; then
    USER=$1
    shift
fi


if [[ ! -f packages.txt ]]; then
    touch packages.txt
fi


docker build -t $IMAGE --network host . --build-arg USERNAME=$USER $@

# The build process produces some files in the home directory.
# Copy them to the host, but only do this once.
if [ ! -f ./user-homedir/copied ]; then
    docker run --rm -v ./user-homedir:/data:rw $IMAGE cp -arv /home/$USER/ /data/
    touch ./user-homedir/copied_$USER
fi

 docker run -it --rm --network host \
     --privileged \
     -v ./user-homedir/$USER:/home/$USER:rw \
     $IMAGE
