FROM docker:dind

RUN apk update
RUN apk add git jq openjdk17 alpine-sdk libstdc++ gcompat wget
RUN wget -L https://github.com/docker/machine/releases/download/v0.8.0-rc1/docker-machine-`uname -s`-`uname -m`
RUN mv docker-machine-`uname -s`-`uname -m` /usr/local/bin/docker-machine
RUN chmod +x /usr/local/bin/docker-machine
