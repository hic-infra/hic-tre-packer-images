#!/bin/bash

set -eu

######################################################################
# Set up R environment

sudo apt install -y r-cran-ggrepel r-cran-biocmanager r-cran-devtools \
     r-cran-xml libcurl4-openssl-dev

# We move the Rprofile (configured in the RStudio module) to avoid
# these installations from hitting the currently non-existant CRAN
# mirror.
mv "${HOME}/.Rprofile" "${HOME}/tmp_Rprofile"

sudo R --no-save -e "BiocManager::install('gwasurvivr')"
sudo R --no-save -e "devtools::install_github('jdstorey/qvalue')"

mv "${HOME}/tmp_Rprofile" "${HOME}/.Rprofile"

######################################################################
# Set up python environments

# pinning numpy to supress a warning about numpy needing to be less
# than 1.23.0 with scikit, even though the deps specify numpy 1.23.1.
read -ra BASE_PKG <<<"numpy==1.23.0 matplotlib scikit-learn pillow pandas"
~/conda/bin/mamba create -y -n pytorch
~/conda/bin/mamba install -y pytorch torchvision "${BASE_PKG[@]}" -c pytorch -n pytorch
~/conda/bin/mamba create -y -n tensorflow
~/conda/bin/mamba install -y tensorflow "${BASE_PKG[@]}" -c anaconda -n tensorflow

######################################################################
# Test custom installs
R --no-save -e "library('ggrepel')"
R --no-save -e "library('gwasurvivr')"
R --no-save -e "library('qvalue')"
