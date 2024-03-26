#!/bin/bash
# Useful utilities/tools for development in a TRE

set -eu

sudo apt-get update -y -q
sudo apt-get install -y -q \
  meld
