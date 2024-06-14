FROM gitpod/openvscode-server:latest

USER root

RUN add-apt-repository ppa:longsleep/golang-backports \
    && apt-get update \
    && apt-get install golang-go rustc cargo nodejs npm snap python \
    && snap install hugo

USER openvscode-server

ENV OPENVSCODE_SERVER_ROOT="/home/.openvscode-server"
ENV OPENVSCODE="${OPENVSCODE_SERVER_ROOT}/bin/openvscode-server"

SHELL ["/bin/bash", "-c"]
RUN \
    # List the extensions in this array
    exts=(\
    # From https://open-vsx.org/ registry directly
    golang.go\
    rust-lang.rust-analyzer\
    ms-pyright.pyright\
    redhat.vscode-yaml\
    waderyan.gitblame\
    catppuccin.catppuccin-vsc\
    catppuccin.catppuccin-vsc-icons\
    # From filesystem, .vsix that we downloaded (using bash wildcard '*')
    "${tdir}"/* \
    )\
    # Install the $exts
    && for ext in "${exts[@]}"; do ${OPENVSCODE} --install-extension "${ext}"; done