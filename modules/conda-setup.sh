#!/bin/bash
# This script must be runnable as an unprivileged user
# To automatically install packages in the base environment add
# conda-environment.yml to the remote directory
set -eu

# To prevent attempting mamba env update on a glob string if no conda
# environments exist.
shopt -s nullglob

SETUPDIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

MAMBAFORGE_VERSION=26.9.4-1
MAMBAFORGE_SHA256=571b410272cc434f28bc6c5c49ca8ffd4a4d1bcba9f57f1b6baccdb46446cfcc

echo "Installing Conda"
pushd /tmp
curl -sfLO "https://github.com/conda-forge/miniforge/releases/download/$MAMBAFORGE_VERSION/Miniforge3-$MAMBAFORGE_VERSION-Linux-x86_64.sh"
echo "$MAMBAFORGE_SHA256 Miniforge3-$MAMBAFORGE_VERSION-Linux-x86_64.sh" | sha256sum -c -
bash "Miniforge3-$MAMBAFORGE_VERSION-Linux-x86_64.sh" -b -f -p ~/conda
rm -f "Miniforge3-$MAMBAFORGE_VERSION-Linux-x86_64.sh"
popd

echo "Searching for conda environments"
export MAMBA_ROOT_PREFIX=$HOME/conda
eval "$(~/conda/bin/mamba shell hook --shell bash)"
~/conda/bin/mamba shell init --shell bash

for env in "${SETUPDIR}"/conda-environment*.yml ; do
    echo "Creating environment from $env"
    ~/conda/bin/mamba env create --file "$env"
done

echo "Setting default conda channel"
cat > "$HOME/.condarc" <<EOF
channels:
  - conda-forge
channel_alias: http://conda.hic-tre.dundee.ac.uk
EOF
