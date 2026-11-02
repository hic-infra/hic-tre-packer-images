#!/bin/bash
# Run this script as a user with sudo privileges
set -eu

SETUPDIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
cd "$SETUPDIR"

PYCHARM_VERSION=2026.2.4
PYCHARM_SHA256=87d39ae1125f7298e8f8c4b96aac836043eb15053f8dc5d7c52356eaab5762a8

echo "Installing PyCharm"
curl -sfLO https://download.jetbrains.com/python/pycharm-${PYCHARM_VERSION}.tar.gz
echo "$PYCHARM_SHA256 pycharm-${PYCHARM_VERSION}.tar.gz" | sha256sum -c -

sudo tar -zxf pycharm-${PYCHARM_VERSION}.tar.gz -C /opt
rm pycharm-${PYCHARM_VERSION}.tar.gz

sudo ln -s /opt/pycharm-${PYCHARM_VERSION} /opt/pycharm

cat <<EOF | sudo tee /opt/pycharm/PyCharm.desktop
[Desktop Entry]
Name=PyCharm
GenericName=Python IDE
Comment=Launch JetBrains PyCharm Development Environment
Terminal=true
Exec=/opt/pycharm-${PYCHARM_VERSION}/bin/pycharm.sh
Icon=/opt/pycharm-${PYCHARM_VERSION}/bin/pycharm.svg
Type=Application
EOF
sudo chmod +x /opt/pycharm/PyCharm.desktop
ln -s /opt/pycharm/PyCharm.desktop /home/ubuntu/Desktop/PyCharm.desktop
