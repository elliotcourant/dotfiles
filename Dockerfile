FROM debian:12.6 AS base
RUN  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    software-properties-common \
    build-essential \
    wget \
    git \
    cmake \
    pkg-config \
    unzip \
    libtool-bin \
    gettext


FROM base AS neovim
COPY ./tools/neovim /build
WORKDIR /build
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo

FROM base
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    postgresql-client \
    rsync \
    iputils-ping \
    dnsutils \
    traceroute \
    telnet \
    vim \
    zsh \
    redis-server # Has redis-cli

# Install kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add && \
    apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main" && \
    apt-get update -y && \
    apt-get install -y kubectl

COPY --from=neovim /build/build/bin/nvim /usr/bin/nvim

ARG USERNAME=elliotcourant
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo wget \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

USER $USERNAME

COPY ./ /home/elliotcourant/dotfiles
RUN cd /home/elliotcourant/dotfiles && make install && cd -

WORKDIR /home/elliotcourant

ENTRYPOINT [ "/bin/zsh" ]
CMD ["-l"]
