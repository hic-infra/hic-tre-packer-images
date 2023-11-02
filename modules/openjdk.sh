#!/bin/bash

set -eu

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
     wget apt-transport-https gnupg
sudo apt-get -y -q update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y temurin-17-jdk
