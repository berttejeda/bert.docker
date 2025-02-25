FROM ubuntu:22.04

ENV USER=svcdevops
ENV GROUP=svcdevops
ENV USERPASSWORD=svcdevops
ENV UID=5000
ENV CERT_DIR=/usr/local/share/ca-certificates

# Change default shell for RUN from Dash to Bash
SHELL ["/bin/bash", "-exo", "pipefail", "-c"] 

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=dumb \
    PAGER=cat

RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90$USER && \
  echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90$USER && \
  apt-get update && apt-get install -y \
    curl \
    locales \
    sudo \
  && \
  locale-gen en_US.UTF-8 && \
  rm -rf /var/lib/apt/lists/* && \
  useradd --uid=$UID --user-group --create-home $USER && \
  echo '$USER ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-$USER && \
  echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep && \
  sudo -u $USER mkdir /home/$USER/project && \
  sudo -u $USER mkdir /home/$USER/bin

ENV PATH=/home/$USER/bin:/home/$USER/.local/bin:$PATH
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN noInstallRecommends="" && \
  if [[ "22.04" == "22.04" ]]; then \
    noInstallRecommends="--no-install-recommends"; \
  fi && \
  apt-get update && apt-get install -y $noInstallRecommends \
    autoconf \
    build-essential \
    ca-certificates \
    cmake \
    # already installed but here for consistency
    curl \
    gnupg \
    gzip \
    jq \
    libcurl4-openssl-dev \
    # popular DB lib - MariaDB
    libmariadb-dev \
    # allows MySQL users to use MariaDB lib
    libmariadb-dev-compat \
    # popular DB lib - PostgreSQL
    libpq-dev \
    libssl-dev \
    libsqlite3-dev \
    make \
    # for ssh-enabled builds
    nano \
    net-tools \
    netcat \
    openssh-client \
    parallel \
    # compiling tool
    pkg-config \
    postgresql-client \
    shellcheck \
    software-properties-common \
    # already installed but here for consistency
    sudo \
    tar \
    tzdata \
    unzip \
    # for ssh-enabled builds
    vim-tiny \
    wget \
    zip

# https://github.com/lutris/lutris/issues/4235#issuecomment-1125975574
ADD openssl.cnf /etc/ssl/openssl.cnf

COPY extra_certs /tmp

RUN if ls /tmp/extra_certs/*.crt; then \
      cp /tmp/extra_certs/*.crt $CERT_DIR; \
      update-ca-certificates; \
    fi

RUN rm -rf /tmp/extra_certs

RUN add-apt-repository ppa:git-core/ppa 

RUN apt-get install -y git python3.9 && \
rm -rf /var/lib/apt/lists/* && \
# vim-tiny doesn't include a vim binary even though it includes vim
ln -s /usr/bin/vi /usr/bin/vim

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py &&\ 
  python3 get-pip.py &&\ 
  rm -f get-pip.py

# Install Docker - needs the setup_remote_docker $USER step to work
ENV DOCKER_VERSION 5:20.10.14~3-0~ubuntu-
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $( lsb_release -cs ) stable" && \
  apt-get install -y docker-ce=${DOCKER_VERSION}$( lsb_release -cs ) docker-ce-cli=${DOCKER_VERSION}$( lsb_release -cs ) containerd.io && \
  # Quick test of the Docker install
  docker --version && \
  rm -rf /var/lib/apt/lists/*

# Install Docker Compose - see prerequisite above
ENV COMPOSE_VERSION 2.4.1
ENV COMPOSE_SWITCH_VERSION 1.0.4
RUN dockerPluginDir=/usr/local/lib/docker/cli-plugins && \
  mkdir -p $dockerPluginDir && \
  curl -sSL "https://github.com/docker/compose/releases/download/v${COMPOSE_VERSION}/docker-compose-linux-$(uname -m)" -o $dockerPluginDir/docker-compose && \
  chmod +x $dockerPluginDir/docker-compose && \
  curl -fL https://github.com/docker/compose-switch/releases/download/v${COMPOSE_SWITCH_VERSION}/docker-compose-linux-amd64 -o /usr/local/bin/compose-switch && \
  # Quick test of the Docker Compose install
  docker compose version && \
  chmod +x /usr/local/bin/compose-switch && \
  update-alternatives --install /usr/local/bin/docker-compose docker-compose /usr/local/bin/compose-switch 99 && \
  # Tests if docker-compose for v1 is transposed to v2
  docker-compose version

RUN curl -sSL "https://github.com/mikefarah/yq/releases/download/v4.23.1/yq_linux_amd64.tar.gz" | \
  tar -xz -C /usr/local/bin && \
  mv /usr/local/bin/yq{_linux_amd64,}

ADD entrypoint.sh /usr/local/bin

RUN chmod +x /usr/local/bin/entrypoint.sh

USER $USER
# Run commands and tests as $USER user
RUN whoami && \
  # opt-out of the new security feature, not needed in a CI environment
  git config --global --add safe.directory '*'

# Match the default $USER working directory
WORKDIR /home/$USER/project

ADD . .

RUN pip3 install --user -r requirements.txt

RUN rm -f entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
