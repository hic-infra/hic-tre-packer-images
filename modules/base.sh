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
  ubuntu-mate-desktop

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
