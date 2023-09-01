#!/bin/bash

set -eu


######################################################################
# PLINK
mkdir plink
pushd plink
curl -sfLO https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20230116.zip
unzip plink_linux_x86_64_20230116.zip
chmod +x plink
sudo ln -s "$(pwd)/plink" /usr/local/bin/plink
popd

######################################################################
# GTOOL
mkdir gtool
pushd gtool
curl -sfLO https://www.well.ox.ac.uk/~cfreeman/software/gwas/gtool_v0.7.5_x86_64.tgz
tar zxvf gtool_v0.7.5_x86_64.tgz
chmod +x gtool
sudo ln -s "$(pwd)/gtool" /usr/local/bin/gtool
popd

######################################################################
# SNPTEST
mkdir snptest
pushd snptest
curl -sfLO http://www.well.ox.ac.uk/~gav/resources/snptest_v2.5.4-beta3_linux_x86_64_static.tgz
tar zxvf snptest_v2.5.4-beta3_linux_x86_64_static.tgz
sudo cp snptest_v2.5.4-beta3_linux_x86_64_static/snptest_v2.5.4-beta3 /usr/local/bin/snptest
sudo chmod +x /usr/local/bin/snptest
popd

######################################################################
# Some TensorFlow stuff

CUDNN_PATH=$(find "$HOME/conda/envs/msc" -path "*/cudnn/lib")
echo "export LD_LIBRARY_PATH=$CUDNN_PATH:$HOME/conda/envs/msc/lib/:\$LD_LIBRARY_PATH" \
     > "$HOME/conda/envs/msc/etc/conda/activate.d/env_vars.sh"

# We want to trigger a download of EfficientNet weights
~/conda/bin/conda run -n msc python -c "\
from tensorflow.keras.applications import EfficientNetB0; \
model = EfficientNetB0(weights='imagenet')"

######################################################################
# Jupyter Notebook shortcut
sudo tee /usr/local/bin/nb <<EOF
#!/bin/bash

cd /home/ubuntu
eval "\$(/home/ubuntu/conda/bin/conda shell.bash hook)"
/home/ubuntu/conda/bin/conda activate msc

jupyter notebook &
sleep 3
notebook_url=\$(jupyter notebook list 2>&1 | awk "/http/ {print \$2}" | tail -n1)

unset LD_LIBRARY_PATH
xdg-open "\$notebook_url"

wait
EOF

sudo chmod +x /usr/local/bin/nb

cat <<EOF | tee /home/ubuntu/Desktop/Notebook.desktop
[Desktop Entry]
Name=Jupyter Notebook
GenericName=Python Notebook
Comment=Launch Jupyter Notebook
Terminal=true
Exec=/usr/bin/bash -c "source /home/ubuntu/conda/etc/profile.d/conda.sh && /usr/local/bin/nb"
Icon=/home/ubuntu/conda/envs/msc/share/icons/hicolor/scalable/apps/notebook.svg
Type=Application
EOF
sudo chmod +x /home/ubuntu/Desktop/Notebook.desktop

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
# Test custom installs
R --no-save -e "library('ggrepel')"
R --no-save -e "library('gwasurvivr')"
R --no-save -e "library('qvalue')"
