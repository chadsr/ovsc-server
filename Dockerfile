FROM gitpod/openvscode-server:1.90.1

USER root

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install htop python3

USER openvscode-server

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
    waderyan.gitblame \
    catppuccin.catppuccin-vsc \
    catppuccin.catppuccin-vsc-icons \
    )\
    # Install the $exts
    && for ext in "${exts[@]}"; do ${OPENVSCODE} --install-extension "${ext}"; done
