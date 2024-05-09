#!/bin/bash

set -eu

# Install required dependencies for STATA
# Expect is for automatically entering the license info
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
    libtinfo5 \
    libncurses5 \
    expect

# Set up termporary directory for installation files
mkdir /tmp/stata

aws s3 cp "s3://${S3_PACKER_RESOURCES_PATH}/Stata17Linux64.tar.gz" \
    /tmp/stata/Stata17Linux64.tar.gz

pushd /tmp/stata
tar -zxf Stata17Linux64.tar.gz
popd

# Install stata - it asks a few y/n questions
sudo mkdir -p /usr/local/stata17
pushd /usr/local/stata17
yes | sudo /tmp/stata/install
popd

sudo rm -rf /tmp/stata


pushd /usr/local/stata17

# Create a file at the relevant location the relevant details:
#         set SERIAL {xxxxxxxxxxxx
#         set CODE   {xxxx xxxx xxxx xxxx xxxx xxxx xxxx x}
#         set AUTH   {xxxx}
#         set LINE1  {xxxxxxxxxxxxxxxxxxxxxxxxx}
#         set LINE2  {xxxxxxxxxxxxxxxxxxxx}

(
    aws s3 cp "s3://${S3_PACKER_RESOURCES_PATH}/stata-license-vars.expect" -
cat <<EOF
proc yes {} {
  expect "and press enter:" {
    send "y\r"
  }
}

spawn ./stinit

yes
yes

expect "Serial number:" {
  send "\$SERIAL\r"
}

expect "Code:" {
  send "\$CODE\r"
}

expect "Authorization:" {
  send "\$AUTH\r"
}

yes
yes

expect "first line to say:" {
  send "\$LINE1\r"
}

expect "second line to say:" {
  send "\$LINE2\r"
}

yes

expect "Continue with the instructions"
EOF
) | sudo /usr/bin/expect

popd

cat <<EOF > ~/Desktop/Stata.desktop
[Desktop Entry]
Name=Stata 17
GenericName=Stata
Comment=Statistical software for data science
Terminal=false
Exec=bash -c "LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libodbc.so /usr/local/stata17/xstata-mp"
Icon=/usr/local/stata17/stata17.png
Type=Application
EOF
chmod +x ~/Desktop/Stata.desktop

