#!/bin/bash
# This script must be runnable as an unprivileged user
# To automatically install packages in the base environment add
# conda-environment.yml to the remote directory
set -eu

# To prevent attempting mamba env update on a glob string if no conda
# environments exist.
shopt -s nullglob

SETUPDIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

MAMBAFORGE_VERSION=22.11.1-4
MAMBAFORGE_SHA256=16c7d256de783ceeb39970e675efa4a8eb830dcbb83187f1197abfea0bf07d30

echo "Installing Conda"
pushd /tmp
curl -sfLO https://github.com/conda-forge/miniforge/releases/download/$MAMBAFORGE_VERSION/Mambaforge-$MAMBAFORGE_VERSION-Linux-x86_64.sh
echo "$MAMBAFORGE_SHA256 Mambaforge-$MAMBAFORGE_VERSION-Linux-x86_64.sh" | sha256sum -c -
bash Mambaforge-$MAMBAFORGE_VERSION-Linux-x86_64.sh -b -f -p ~/conda
rm -f Mambaforge-$MAMBAFORGE_VERSION-Linux-x86_64.sh
popd

echo "Searching for conda environments"
~/conda/bin/mamba init

for env in "${SETUPDIR}"/conda-environment*.yml ; do
    echo "Creating environment from $env"
    ~/conda/bin/mamba env update --file "$env"
done

echo "Specifying repo"
cat > $HOME/.condarc <<EOF
channels:
  - conda-forge
channel_alias: http://conda.hic-tre.dundee.ac.uk
EOF
