#!/usr/bin/env bash

# Stand up a development environment that has everything you need.

IMAGE=devenv

docker build -t $IMAGE --network host .

# The build process produces some files in the home directory.
# Copy them to the host, but only do this once.

# test if a file exists. If it does not exist, then copy the files.
if [ ! -f ./user-homedir/copied ]; then
    docker run --rm -v ./user-homedir:/data:rw $IMAGE cp -arv /home/ubuntu/ /data/
    touch ./user-homedir/copied
fi

# # run the container with the home directory mounted to the container.
#
 docker run -it --rm --network host -v ./user-homedir/ubuntu:/home/ubuntu:rw $IMAGE
