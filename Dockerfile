FROM docker:20.10.17-dind-alpine3.16
# the tmpfs "fix" below is so fragile, we better
# version lock this to a specific version of dind

RUN apk update
RUN apk add git jq openjdk17 alpine-sdk libstdc++ gcompat wget bash
RUN wget -L https://github.com/docker/machine/releases/download/v0.8.0-rc1/docker-machine-`uname -s`-`uname -m`
RUN mv docker-machine-`uname -s`-`uname -m` /usr/local/bin/docker-machine
RUN chmod +x /usr/local/bin/docker-machine

# dind mounts /tmp as tmpfs; this breaks concourse
RUN sed -E -i 's/mount -t tmpfs none/: #mount -t tmpfs none/' /usr/local/bin/dind