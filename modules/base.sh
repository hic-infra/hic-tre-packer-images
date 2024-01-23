#!/bin/bash
# Run this script as the default ubuntu user
set -eu

SETUPDIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
cd "$SETUPDIR"

sudo apt-get -y -q update

# Desktop environment and VNC server
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
  jq \
  tigervnc-standalone-server \
  ubuntu-mate-desktop firefox

# Don't boot into desktop (graphical.target)
sudo systemctl set-default multi-user.target
sudo cp vncserver@.service /etc/systemd/system/
sudo systemctl enable vncserver@1

# Disable scrensaver/screenlock
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false
gsettings set org.mate.screensaver lock-enabled false
gsettings set org.mate.screensaver idle-activation-enabled false

# AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install

# Add terminal shortcut to desktop for easy access
mkdir -p ~/Desktop
ln -s /usr/share/applications/mate-terminal.desktop ~/Desktop/

# Replace firefox snap with debian package if it's installed
# snap packages have some issues with VNC because of cgroup
if [ -f /snap/bin/firefox ] ; then
    # On Ubuntu 22.04+, deb `firefox` package is transitional package
    # and results in the snap package installation.
    sudo snap remove firefox
    sudo add-apt-repository -y ppa:mozillateam/ppa
    sudo apt install -y -q firefox-esr
fi
