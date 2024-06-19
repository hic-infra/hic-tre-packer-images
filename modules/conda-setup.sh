#!/bin/bash
# This script must be runnable as an unprivileged user
# To automatically install packages in the base environment add
# conda-environment.yml to the remote directory
set -eu

# To prevent attempting mamba env update on a glob string if no conda
# environments exist.
shopt -s nullglob

SETUPDIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

MAMBAFORGE_VERSION=23.1.0-3
MAMBAFORGE_SHA256=7a6a07de6063245163a87972fb15be3a226045166eb7ee526344f82da1f3b694

echo "Installing Conda"
pushd /tmp
curl -sfLO "https://github.com/conda-forge/miniforge/releases/download/$MAMBAFORGE_VERSION/Mambaforge-$MAMBAFORGE_VERSION-Linux-x86_64.sh"
echo "$MAMBAFORGE_SHA256 Mambaforge-$MAMBAFORGE_VERSION-Linux-x86_64.sh" | sha256sum -c -
bash "Mambaforge-$MAMBAFORGE_VERSION-Linux-x86_64.sh" -b -f -p ~/conda
rm -f "Mambaforge-$MAMBAFORGE_VERSION-Linux-x86_64.sh"
popd

echo "Searching for conda environments"
~/conda/bin/mamba init

for env in "${SETUPDIR}"/conda-environment*.yml ; do
    echo "Creating environment from $env"
    ~/conda/bin/mamba env update --file "$env"
done

# Internal Conda proxy or repository
if [ -n "${CONDA_PROXY_SERVER:-}" ]; then
    echo "Configuring Conda proxy ${CONDA_PROXY_SERVER}"
    cat > "$HOME/.condarc" <<EOF
channels:
  - conda-forge
channel_alias: ${CONDA_PROXY_SERVER}
EOF
fi
