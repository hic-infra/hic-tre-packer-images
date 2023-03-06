#!/bin/bash

set -eu

sudo apt-get install -y libssl-dev libcurl4-openssl-dev libmagick++-dev emacs-nox
sudo apt-get install -y gdebi-core

# Install some typical R packages to avoid compilation from CRAN mirror
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | \
    sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc

sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

sudo apt update
sudo apt install -y r-base

# Specifying the direct path to /etc/lsb-release would probably be
# fine on an Ubuntu machine, unfortunately this fails on my local dev
# (Mac) environment. Specifying /dev/null as per docs:
#
#                               https://www.shellcheck.net/wiki/SC1091
#
# shellcheck source=/dev/null
. /etc/lsb-release
if [ "$DISTRIB_RELEASE" == "20.04" ] ; then
    wget https://s3.amazonaws.com/rstudio-ide-build/desktop/bionic/amd64/rstudio-2022.07.2-576-amd64.deb
    sudo gdebi -n rstudio-2022.07.2-576-amd64.deb
elif [ "$DISTRIB_RELEASE" == "22.04" ] ; then
    wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-2022.12.0-353-amd64.deb
    sudo gdebi -n rstudio-2022.12.0-353-amd64.deb
else
    echo "--------------------------------------------------------"
    echo "RStudio - Unsupported Ubuntu version ${DISTRIB_RELEASE}"
    echo "--------------------------------------------------------"
    lsb_release -a
    echo "--------------------------------------------------------"
    exit 1
fi

cat > "$HOME/.Rprofile" <<EOF
# Set the default help type
options(help_type="html")
# Set timezone
Sys.setenv(TZ='Europe/London')
EOF

echo "RSTUDIO_DISABLE_SECURE_DOWNLOAD_WARNING=1" >> "$HOME/.Renviron"

sudo add-apt-repository -y ppa:c2d4u.team/c2d4u4.0+
sudo apt update


sudo apt install -y r-cran-odbc r-cran-dbi r-cran-qqman r-cran-metafor \
     r-cran-tidyr r-cran-ggplot2 r-cran-hmisc r-cran-data.table \
     r-cran-dplyr r-cran-lubridate r-cran-survival r-cran-survminer
