#!/bin/bash

set -eu

cd /opt/ami-setup

# This is a dump of /usr/local/MATLAB, configured to use the HIC Cloud
# TRE matlab license server. - approx 27GB
aws s3 cp "s3://${S3_PACKER_RESOURCES_PATH}/matlab_installed_r2021b.tar" - | \
    sudo tar xC /usr/local/

cat <<EOF > ~/Desktop/MATLAB.desktop
[Desktop Entry]
Name=MATLAB R2021b
GenericName=MATLAB
Comment=Numerical computing environment
Terminal=false
Exec=/usr/local/MATLAB/R2021b/bin/matlab -desktop
Icon=/usr/local/MATLAB/R2021b/bin/glnxa64/cef_resources/matlab_icon.png
Type=Application
EOF
chmod +x ~/Desktop/MATLAB.desktop
