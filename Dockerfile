# Inspired by https://github.com/fhivemind/concourse-dind

FROM debian:bullseye-slim

ENV DOCKER_CHANNEL=stable \
    DOCKER_VERSION=20.10.17 \
    DOCKER_COMPOSE_VERSION=2.9.0 \
    DOCKER_SQUASH=0.2.0 \
    DEBIAN_FRONTEND=noninteractive \
    JAVA_MAJORVER=17 \
    GRAALVM_ARCH=amd64 \
    GRAALVM_VERSION=22.2.0

# Install Docker, Docker Compose, Docker Squash
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install \
        bash \
        curl \
        iptables \
        util-linux \
        ca-certificates \
        git \
        wget \
        net-tools \
        iproute2 \
        && \
    echo curl -fL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" && \
    curl -fL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" | tar zx && \
    mv /docker/* /bin/ && chmod +x /bin/docker* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache

# Install openjdk
# RUN apt-get -y install jq openjdk-17-jdk
# RUN wget -L https://github.com/docker/machine/releases/download/v0.8.0-rc1/docker-machine-`uname -s`-`uname -m` && \
# 	mv docker-machine-`uname -s`-`uname -m` /usr/local/bin/docker-machine && \
# 	chmod +x /usr/local/bin/docker-machine

# Install graalvm
RUN mkdir /usr/lib/jvm; \
    wget "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-java${JAVA_MAJORVER}-linux-${GRAALVM_ARCH}-${GRAALVM_VERSION}.tar.gz"; \
    tar -zxC /usr/lib/jvm -f graalvm-ce-java${JAVA_MAJORVER}-linux-${GRAALVM_ARCH}-${GRAALVM_VERSION}.tar.gz; \
    rm -f graalvm-ce-java${JAVA_MAJORVER}-linux-${GRAALVM_ARCH}-${GRAALVM_VERSION}.tar.gz


WORKDIR /shared
COPY docker-entrypoint.sh /bin/entrypoint.sh

ENV PATH "$PATH:/usr/lib/jvm/graalvm-ce-java${JAVA_MAJORVER}-${GRAALVM_VERSION}/bin/"
ENV JAVA_HOME "/usr/lib/jvm/graalvm-ce-java${JAVA_MAJORVER}-${GRAALVM_VERSION}/"
ENV GRAALVM_HOME "/usr/lib/jvm/graalvm-ce-java${JAVA_MAJORVER}-${GRAALVM_VERSION}/"

# native-image building needs gcc, make, ...
RUN gu install native-image
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install build-essential libz-dev zlib1g-dev
RUN apt-get install -y kmod

ENTRYPOINT ["/bin/entrypoint.sh"]
