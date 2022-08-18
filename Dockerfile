# Inspired by https://github.com/fhivemind/concourse-dind

FROM debian:bullseye-slim

ENV DOCKER_CHANNEL=stable \
    DOCKER_VERSION=20.10.17 \
    DOCKER_COMPOSE_VERSION=2.9.0 \
    DOCKER_SQUASH=0.2.0 \
    DEBIAN_FRONTEND=noninteractive

# Install Docker, Docker Compose, Docker Squash
RUN apt-get update && \
    apt-get -y install \
        bash \
        curl \
     #   device-mapper \
        # python-pip \
        # python-dev \
        iptables \
        util-linux \
        ca-certificates \
        # gcc \
        # libc-dev \
        # libffi-dev \
        # libssl-dev \
        # make \
        git \
        wget \
        net-tools \
        iproute2 \
        && \
    echo curl -fL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" && \
    curl -fL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" | tar zx && \
    mv /docker/* /bin/ && chmod +x /bin/docker* && \
    # pip install docker-compose==${DOCKER_COMPOSE_VERSION} && \
    # curl -fL "https://github.com/jwilder/docker-squash/releases/download/v${DOCKER_SQUASH}/docker-squash-linux-amd64-v${DOCKER_SQUASH}.tar.gz" | tar zx && \
    # mv /docker-squash* /bin/ && chmod +x /bin/docker-squash* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache

RUN apt-get -y install jq openjdk-17-jdk
RUN wget -L https://github.com/docker/machine/releases/download/v0.8.0-rc1/docker-machine-`uname -s`-`uname -m` && \
	mv docker-machine-`uname -s`-`uname -m` /usr/local/bin/docker-machine && \
	chmod +x /usr/local/bin/docker-machine

WORKDIR /shared
COPY docker-entrypoint.sh /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
