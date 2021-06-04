ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}

ENV DOCKER_BUILDKIT=1
ENV DOCKER_CLI_EXPERIMENTAL=enabled
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -yqq update \
  && apt-get install -yqq --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  curl \
  dumb-init \
  git \
  gnupg-agent \
  iputils-ping \
  jq \
  software-properties-common \
  wget \
  && apt-get clean \
  && rm -rf /var/cache/apt/lists/*

ARG DOCKER_COMPOSE_VERSION=1.27.3
ENV DOCKER_COMPOSE_VERSION=${DOCKER_COMPOSE_VERSION}

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
  && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  && apt-get update \
  && apt-get install -yqq --no-install-recommends \
  docker-ce-cli=5:19.03.13~3-0~ubuntu-focal \
  && apt-get clean \
  && rm -rf /var/cache/apt/lists/*

RUN curl -Lo /usr/local/bin/docker-compose \
  "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  && chmod 755 /usr/local/bin/docker-compose

RUN useradd -m actions

WORKDIR /home/actions/runner

ENV RUNNER_VERSION=2.276.1

RUN wget https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
  && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
  && rm ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R actions ~actions && ./bin/installdependencies.sh

USER actions

ENTRYPOINT ["/usr/bin/dumb-init", "--", "./run.sh"]
