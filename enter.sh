#!/usr/bin/env bash

# Stand up a development environment that has everything you need.

set -e

# The first arg is the name of the user that will be created in the container.
# All the other args will be used arguments to docker build.
# each user will have its own home directory, if you're into that kind of thing.
USER=coder
if [[ $# -gt 0 ]]; then
    USER=$1
    shift
fi

# Create a user in the container with the same UID/GID as the user running the script
USER_UID=$(id -u)
USER_GID=$(id -g)

IMAGE=devenv-$USER

if [[ ! -f packages.txt ]]; then
    touch packages.txt
fi


docker build -t $IMAGE \
    --network host \
    --build-arg USERNAME=$USER \
    --build-arg USER_UID=$USER_UID \
    --build-arg USER_GID=$USER_GID \
    $@ \
    .

# The build process produces some files in the home directory.
# Copy them to the host, but only do this once.
if [ ! -f ./user-homedir/copied_$USER ]; then
    docker run --rm -v ./user-homedir:/data:rw $IMAGE cp -arv /home/$USER/ /data/
    touch ./user-homedir/copied_$USER
fi

docker run -it --rm --network host \
    --privileged \
    -v ./user-homedir/$USER:/home/$USER:rw \
    $IMAGE
