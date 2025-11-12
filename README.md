# Openvscode Server

*Custom Open-VSCode Server Docker Image*

[![CI](https://github.com/chadsr/ovsc-server/actions/workflows/ci.yml/badge.svg)](https://github.com/chadsr/ovsc-server/actions/workflows/ci.yml)
[![Docker](https://github.com/chadsr/ovsc-server/actions/workflows/docker.yml/badge.svg)](https://github.com/chadsr/ovsc-server/actions/workflows/docker.yml)

## Running

```shell
docker run -p 3000:3000 -v "./workspace:/home/workspace" -v "./goose:/home/openvscode-server/.config/goose" ghcr.io/chadsr/ovsc-server:latest
```
