#!/bin/bash

set -eu

NVIDIA_HASH=e99c217f289365626468298310e66a60c3539311f41888d0686c8b5c0ffe46bf
NVIDIA_FILE=nvidia-driver-local-repo-ubuntu2004-525.60.13_1.0-1_amd64.deb

curl -sfL "https://us.download.nvidia.com/tesla/525.60.13/${NVIDIA_FILE}" \
     -o "${NVIDIA_FILE}"

echo "${NVIDIA_HASH} ${NVIDIA_FILE}" | sha256sum -c -

sudo dpkg -i "${NVIDIA_FILE}"

# Install keyring to prevent future apt installs from failing.
sudo cp /var/nvidia-driver-local-repo-*/nvidia-driver-local-*-keyring.gpg /usr/share/keyrings/

sudo apt update -y
sudo apt install -y nvidia-dkms-525 nvidia-utils-525
