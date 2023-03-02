#!/bin/bash


# Installs a MATLAB runtime when the environment variable
# MATLAB_RUNTIME is set a runtime download URL (as a zip file).
#
# e.g. for MATLAB 2020a
# MATLAB_RUNTIME=https://ssd.mathworks.com/supportfiles/downloads/R2020b/Release/8/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2020b_Update_8_glnxa64.zip
#
# These links can be found here:
# https://uk.mathworks.com/products/compiler/matlab-runtime.html

set -eu

name=$(echo "${MATLAB_RUNTIME}" | awk -F'/' '{ print $NF }')
echo "Installing MATLAB runtime: ${name}"

curl "${MATLAB_RUNTIME}" --output "/tmp/${name}"

mkdir -p "/tmp/matlab_runtime"
unzip "/tmp/${name}" -d "/tmp/matlab_runtime"
rm  "/tmp/${name}"

pushd "/tmp/matlab_runtime"
sudo ./install \
     -agreeToLicense yes \
     -mode silent
popd

rm -rf "/tmp/matlab_runtime"
