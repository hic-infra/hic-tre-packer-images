#!/bin/bash

set -eu
cd /opt/ami-setup

deb=freesurfer_7.2.0_amd64.deb

aws s3 cp "s3://${S3_PACKER_RESOURCES_PATH}/${deb}" ./

sudo apt install -y "/opt/ami-setup/${deb}"


