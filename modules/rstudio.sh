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

wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-2021.09.2-382-amd64.deb
sudo gdebi -n rstudio-2021.09.2-382-amd64.deb

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

echo "RSTUDIO_DISABLE_SECURE_DOWNLOAD_WARNING=1" >> "$HOME/.Renviron"

sudo add-apt-repository -y ppa:c2d4u.team/c2d4u4.0+
sudo apt update


sudo apt install -y r-cran-odbc r-cran-dbi r-cran-qqman r-cran-metafor \
     r-cran-tidyr r-cran-ggplot2 r-cran-hmisc r-cran-data.table \
     r-cran-dplyr r-cran-lubridate r-cran-survival r-cran-survminer
