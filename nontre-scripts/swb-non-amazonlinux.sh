#!/bin/bash

# Service workbench environment files only support Amazon Linux in userdata
# https://github.com/awslabs/service-workbench-on-aws/blob/v4.3.1/addons/addon-base-raas/packages/base-raas-cfn-templates/src/templates/service-catalog/ec2-linux-instance.cfn.yml
# https://github.com/awslabs/service-workbench-on-aws/blob/v4.3.1/main/solution/post-deployment/config/environment-files/get_bootstrap.sh
# https://github.com/awslabs/service-workbench-on-aws/blob/v4.3.1/main/solution/post-deployment/config/environment-files/bootstrap.sh
# https://github.com/awslabs/service-workbench-on-aws/tree/v4.3.1/main/solution/post-deployment/config/environment-files

# To work around this install required packages here, and bundle a modified
# bootstrap script that can be called from userdata

set -eu

SETUPDIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
cd "$SETUPDIR"

sudo apt-get update -y -q

sudo apt-get install -y -q \
  fuse3 \
  jq \
  python3-pip

sudo wget -qO /usr/local/bin/goofys https://github.com/kahing/goofys/releases/download/v0.24.0/goofys
sudo chmod a+x /usr/local/bin/goofys

# https://github.com/awslabs/aws-cloudformation-templates/blob/f14e6284488e0a3ac1f9238e3a15bbe0dd4216bd/aws/solutions/OperatingSystems/Ubuntu22.04_cfn-hup.yaml#L310C16-L316
sudo mkdir -p /opt/aws/bin/
sudo pip3 install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-py3-latest.tar.gz
sudo ln -s /usr/local/init/ubuntu/cfn-hup /etc/init.d/cfn-hup
sudo ln -s /usr/local/bin/cfn-* /opt/aws/bin/

sudo useradd -m -s /bin/bash ec2-user

sudo sed -i s/ubuntu/ec2-user/g /etc/systemd/system/vncserver@.service
sudo cp -a /home/ubuntu/Desktop /home/ec2-user/
sudo chown -R ec2-user:ec2-user /home/ec2-user/Desktop

# Allow ec2-user to sudo without a password, same as default ubuntu user
echo 'ec2-user ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers.d/99-ec2-user
