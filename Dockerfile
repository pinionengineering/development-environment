FROM ubuntu:latest

ARG KUBECTL_VERSION=1.30.3
ARG KUBESEAL_VERSION=0.27.1
ARG USERNAME=coder
ARG USER_UID=5000
ARG USER_GID=5000

# the container has an 'ubuntu' user.
# Change the username to something else.
RUN userdel -r ubuntu
RUN groupadd -g $USER_GID $USERNAME || echo reusing existing group
RUN useradd -m $USERNAME -s /usr/bin/bash -u $USER_UID -g $USER_GID
RUN usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USERNAME


RUN apt-get update
RUN apt-get install -y curl

# install gcloud
# This is a big file, so keep it toward the top
RUN curl -L https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz | tar -C / -xzvf -
RUN chown -R $USERNAME: /google-cloud-sdk

# install kubeseal
RUN curl -L "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz" | tar -C /usr/local/bin -xzvf - kubeseal

# install other stuff we need in our environment
RUN apt-get install -y podman podman-docker git make

# install whatever other applications you might want
COPY packages.txt /tmp/packages.txt
RUN apt-get install -y $(cat /tmp/packages.txt)

USER $USERNAME
WORKDIR /home/$USERNAME
RUN /google-cloud-sdk/install.sh -q --rc-path=/home/$USERNAME/.bashrc  --path-update=true
RUN /google-cloud-sdk/bin/gcloud components install kubectl -q

CMD ["/bin/bash"]
