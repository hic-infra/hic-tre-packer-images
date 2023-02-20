#!/bin/bash
# This script must be runnable as an unprivileged user
# To automatically install packages in the base environment add
# conda-environment.yml to the remote directory
set -eu

SETUPDIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

MAMBAFORGE_VERSION=4.11.0-0
MAMBAFORGE_SHA256=49268ee30d4418be4de852dda3aa4387f8c95b55a76f43fb1af68dcbf8b205c3

echo "Installing Conda"
pushd /tmp
curl -sfLO https://github.com/conda-forge/miniforge/releases/download/$MAMBAFORGE_VERSION/Mambaforge-$MAMBAFORGE_VERSION-Linux-x86_64.sh
echo "$MAMBAFORGE_SHA256 Mambaforge-$MAMBAFORGE_VERSION-Linux-x86_64.sh" | sha256sum -c -
bash Mambaforge-$MAMBAFORGE_VERSION-Linux-x86_64.sh -b -f -p ~/conda
rm -f Mambaforge-$MAMBAFORGE_VERSION-Linux-x86_64.sh
popd

BASE_ENVIRONMENT_YML="$SETUPDIR/conda-environment.yml"
if [ -f "$BASE_ENVIRONMENT_YML" ]; then
    echo "Conda: Configuring shell and installing packages"
    # Activates the conda environment in bashrc
    ~/conda/bin/mamba init
    ~/conda/bin/mamba env update --file "$BASE_ENVIRONMENT_YML"
else
    echo "$BASE_ENVIRONMENT_YML not found, skipping"
fi
