#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install --no-install-{suggests,recommends} -y git vim-nox curl python3 python3-pip build-essential
apt-get clean
