#!/bin/bash

set -eu

# The version of slurm in apt repos does not support the newly
# introduced dynamic nodes feature, which will make it much easier to
# work with hostnames such as ip-XXX-XXX-XXX-XXX since these are not
# assigned contigously (ranges across large subnet will use
# significant RAM).

sudo apt install -y emacs-nox
sudo apt install -y bzip2 build-essential libjwt-dev libmunge-dev munge \
     libhwloc-dev libbpf-dev libbpf0 libdbus-1-dev \
     libjson-c-dev libyaml-dev libjwt-dev

SLURM_VERSION=22.05.3
SLURM_SHA256=7ca051c66ce85242ca6f25fae1c0d804d785dba30b2e27c4964544d74ddac823

wget https://download.schedmd.com/slurm/slurm-${SLURM_VERSION}.tar.bz2
echo "${SLURM_SHA256} slurm-${SLURM_VERSION}.tar.bz2" | sha256sum -c -

tar xf slurm-${SLURM_VERSION}.tar.bz2
pushd slurm-${SLURM_VERSION}

./configure --prefix=
make -j "$(nproc)"

sudo make install
sudo cp etc/*.service /etc/systemd/system/

popd
rm -rf slurm-${SLURM_VERSION}.tar.bz2 slurm-${SLURM_VERSION}

sudo groupadd -g 992 slurm
sudo useradd -g slurm -u 992 slurm
sudo mkdir /var/lib/slurm
sudo chown slurm /var/lib/slurm

