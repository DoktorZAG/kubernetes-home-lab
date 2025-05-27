#!/bin/bash

set -euo pipefail

# --- install Cilium CLI ----------------------------------------------------
CILIUM_CLI_VERSION="$(curl -fsSL https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)"
ARCH="$(dpkg --print-architecture)"          # debian style: amd64 | arm64
curl -L --fail --remote-name-all \
  "https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${ARCH}.tar.gz{,.sha256sum}"

sha256sum --check "cilium-linux-${ARCH}.tar.gz.sha256sum"

sudo tar -xzvf "cilium-linux-${ARCH}.tar.gz" -C /usr/local/bin
rm "cilium-linux-${ARCH}.tar.gz" "cilium-linux-${ARCH}.tar.gz.sha256sum"

cilium install --version 1.17.4 --helm-set "ipam.mode=kubernetes"

# verify it’s on the PATH
cilium version
