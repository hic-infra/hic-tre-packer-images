#!/bin/bash

set -eu

mv "$HOME/.Rprofile"{,.bak}

sudo apt install -y r-cran-devtools

sudo R --no-save <<EOF
devtools::install_github("ModelOriented/EIX")
devtools::install_github("ModelOriented/treeshap")
EOF

mv "$HOME/.Rprofile"{.bak,}
