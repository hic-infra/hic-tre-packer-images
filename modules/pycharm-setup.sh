#!/bin/bash
# Run this script as a user with sudo privileges
set -eu

SETUPDIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
cd "$SETUPDIR"

PYCHARM_VERSION=2023.2.1
PYCHARM_SHA256=5956c6cb5a5bad1d9749e487b3bb69fcbf0170f52324e4ff009283b723838778

echo "Installing PyCharm"
curl -sfLO https://download-cdn.jetbrains.com/python/pycharm-community-${PYCHARM_VERSION}.tar.gz
echo "$PYCHARM_SHA256 pycharm-community-${PYCHARM_VERSION}.tar.gz" | sha256sum -c -

sudo tar -zxf pycharm-community-${PYCHARM_VERSION}.tar.gz -C /opt
rm pycharm-community-${PYCHARM_VERSION}.tar.gz

sudo ln -s /opt/pycharm-community-${PYCHARM_VERSION} /opt/pycharm

cat <<EOF | sudo tee /opt/pycharm/PyCharm.desktop
[Desktop Entry]
Name=PyCharm
GenericName=Python IDE
Comment=Launch JetBrains PyCharm Development Environment
Terminal=true
Exec=/opt/pycharm-community-${PYCHARM_VERSION}/bin/pycharm.sh
Icon=/opt/pycharm-community-${PYCHARM_VERSION}/bin/pycharm.svg
Type=Application
EOF
sudo chmod +x /opt/pycharm/PyCharm.desktop
ln -s /opt/pycharm/PyCharm.desktop /home/ubuntu/Desktop/PyCharm.desktop
