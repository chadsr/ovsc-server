FROM gitpod/openvscode-server:1.103.1

ARG TARGETOS
ARG TARGETARCH

USER root

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends htop python3 python3-pip neovim nano nodejs npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install latest go version
RUN GO_ARCHIVE="$(wget --progress=dot -qO- https://go.dev/VERSION?m=text | head -n1)"."${TARGETOS}"-"${TARGETARCH}".tar.gz \
    && wget --progress=dot:giga https://go.dev/dl/"${GO_ARCHIVE}" \
    && tar -C /usr/local -xzf "${GO_ARCHIVE}" \
    && rm -f "${GO_ARCHIVE}"

USER openvscode-server

WORKDIR ${HOME}
COPY .bash_profile .bash_profile

ENV OPENVSCODE_SERVER_ROOT="/home/.openvscode-server"
ENV OPENVSCODE="${OPENVSCODE_SERVER_ROOT}/bin/openvscode-server"

SHELL ["/bin/bash", "-c"]
RUN \
    # List the extensions in this array
    exts=(\
    # From https://open-vsx.org/ registry directly
    golang.go \
    rust-lang.rust-analyzer \
    ms-pyright.pyright \
    redhat.vscode-yaml \
    fwcd.kotlin \
    sswg.swift-lang \
    svelte.svelte-vscode \
    waderyan.gitblame \
    esbenp.prettier-vscode \
    catppuccin.catppuccin-vsc \
    catppuccin.catppuccin-vsc-icons \
    streetsidesoftware.code-spell-checker \
    )\
    # Install the $exts
    && for ext in "${exts[@]}"; do ${OPENVSCODE} --install-extension "${ext}"; done
