#!/bin/bash

set -eu

sudo apt-get install -y libssl-dev libcurl4-openssl-dev libmagick++-dev emacs-nox
sudo apt-get install -y gdebi-core wget

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
    # Don't bother updating RStudio on 20.04 anymore
    wget https://s3.amazonaws.com/rstudio-ide-build/electron/focal/amd64/rstudio-2023.06.1-524-amd64.deb
    sudo gdebi -n rstudio-2023.06.1-524-amd64.deb
elif [ "$DISTRIB_RELEASE" == "22.04" ] ; then
    wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-2025.09.0-387-amd64.deb
    sudo gdebi -n rstudio-2025.09.0-387-amd64.deb
else
    echo "--------------------------------------------------------"
    echo "RStudio - Unsupported Ubuntu version ${DISTRIB_RELEASE}"
    echo "--------------------------------------------------------"
    lsb_release -a
    echo "--------------------------------------------------------"
    exit 1
fi


# The r2u repo provides deb packages for CRAN packages. Replaces c2d4u4
sudo apt update -qq
sudo apt install --yes --no-install-recommends wget ca-certificates gnupg
wget -q -O- https://eddelbuettel.github.io/r2u/assets/dirk_eddelbuettel_key.asc \
    | sudo tee -a /etc/apt/trusted.gpg.d/cranapt_key.asc

wget -q -O- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
    | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
echo "deb [arch=amd64] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | sudo tee /etc/apt/sources.list.d/cran_r.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 67C2D66C4B1D4339 51716619E084DAB9
sudo apt update -qq

echo "Package: *" | sudo tee /etc/apt/preferences.d/99cranapt
echo "Pin: release o=CRAN-Apt Project" | sudo tee -a /etc/apt/preferences.d/99cranapt
echo "Pin: release l=CRAN-Apt Packages" | sudo tee -a /etc/apt/preferences.d/99cranapt
echo "Pin-Priority: 700"  | sudo tee -a /etc/apt/preferences.d/99cranapt

sudo apt install --yes --no-install-recommends python3-{dbus,gi,apt} make
sudo apt update

sudo apt install -y r-cran-dbi r-cran-qqman r-cran-metafor \
     r-cran-tidyr r-cran-ggplot2 r-cran-hmisc r-cran-data.table \
     r-cran-dplyr r-cran-lubridate r-cran-survival r-cran-survminer \
     r-cran-tidyverse

# RSharp
sudo apt-get install -y dotnet-runtime-8.0 libcurl4-openssl-dev libssl-dev libxml2-dev \
     libfontconfig1-dev libharfbuzz-dev libfribidi-dev \
     libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev

sudo R --no-save <<EOF
install.packages("pak", repos = sprintf("https://r-lib.github.io/p/pak/stable/%s/%s/%s", .Platform\$pkgType, R.Version()\$os, R.Version()\$arch))
pak::pak("Open-Systems-Pharmacology/rSharp")
pak::pak("Open-Systems-Pharmacology/OSPSuite.RUtils")
pak::pak("Open-Systems-Pharmacology/OSPSuite.Plots")
pak::pak("Open-Systems-Pharmacology/OSPSuite-R")
EOF

sudo apt install -y software-properties-common
sudo add-apt-repository ppa:dotnet/backports
sudo apt update
sudo apt install -y dotnet-runtime-10.0

# Configure R CRAN access for inside the TRE.
echo "RSTUDIO_DISABLE_SECURE_DOWNLOAD_WARNING=1" >> "$HOME/.Renviron"

cat > "$HOME/.Rprofile" <<EOF
# Set the default help type
options(help_type="html")

# HIC TRE R Repository
local({r <- getOption("repos")
       r["CRAN"] <- "http://cran.hic-tre.dundee.ac.uk/"
       options(repos=r)
})

# Set timezone
Sys.setenv(TZ='Europe/London')
EOF
