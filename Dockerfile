# hadolint global ignore=DL4001
FROM gitpod/openvscode-server:1.105.1

ARG TARGETOS
ARG TARGETARCH

USER root

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends \
    git \
    ca-certificates \
    htop \
    python3 \
    python3-pip \
    neovim \
    nano \
    nodejs \
    npm \
    bzip2 \
    libssl3 \
    libdbus-1-3 \
    libxcb1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install latest go version
RUN GO_ARCHIVE="$(wget --progress=dot -qO- https://go.dev/VERSION?m=text | head -n1)"."${TARGETOS}"-"${TARGETARCH}".tar.gz \
    && wget --progress=dot:giga https://go.dev/dl/"${GO_ARCHIVE}" \
    && tar -C /usr/local -xzf "${GO_ARCHIVE}" \
    && rm -f "${GO_ARCHIVE}"

USER openvscode-server
ENV HOME="/home/openvscode-server"
WORKDIR ${HOME}
COPY --chown=openvscode-server bash/.bash_profile ${HOME}/.bash_profile

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV BASH_ENV="/home/openvscode-server/.bash_env"
# hadolint ignore=SC2016
RUN touch "${BASH_ENV}" && echo '. "${BASH_ENV}"' >> ~/.bashrc

# Download and install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | PROFILE="${BASH_ENV}" bash
RUN echo node > .nvmrc && nvm install stable && nvm alias default stable

# Install latest uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN ~/.local/bin/uv python install

# Install latest rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN ~/.cargo/bin/rustup toolchain update

# Install latest Goose CLI
ENV GOOSE_DISABLE_KEYRING=true
RUN curl -fsSL https://github.com/block/goose/releases/download/stable/download_cli.sh | CONFIGURE=false bash
RUN ~/.local/bin/goose update

ENV OPENVSCODE_SERVER_ROOT="/home/.openvscode-server"
ENV OPENVSCODE="${OPENVSCODE_SERVER_ROOT}/bin/openvscode-server"

RUN \
    # List the extensions in this array
    exts=(\
    # From https://open-vsx.org/ registry directly
    ms-python.python \
    ms-python.debugpy \
    ms-python.isort \
    ms-python.vscode-python-envs \
    ms-python.pylint \
    ms-python.flake8 \
    ms-python.autopep8 \
    ms-toolsai.jupyter \
    magicstack.MagicPython \
    detachhead.basedpyright \
    charliermarsh.ruff \
    golang.go \
    rust-lang.rust-analyzer \
    ms-pyright.pyright \
    redhat.java \
    redhat.vscode-yaml \
    fwcd.kotlin \
    sswg.swift-lang \
    svelte.svelte-vscode \
    waderyan.gitblame \
    esbenp.prettier-vscode \
    catppuccin.catppuccin-vsc \
    catppuccin.catppuccin-vsc-icons \
    streetsidesoftware.code-spell-checker \
    eamodio.gitlens \
    )\
    # Install the $exts
    && for ext in "${exts[@]}"; do ${OPENVSCODE} --install-extension "${ext}"; done
