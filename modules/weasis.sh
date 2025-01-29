#!/bin/bash
# Run this script as the default ubuntu user
set -eu

SETUPDIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
cd "$SETUPDIR"

curl -sfLO https://github.com/nroduit/Weasis/releases/download/v4.5.1/weasis_4.5.1-1_amd64.deb
sudo dpkg -i weasis_4.5.1-1_amd64.deb



