#!/bin/bash

set -eu

if [ -z "$SHARED_SERVICES_DOMAIN" ]; then
  SHARED_SERVICES_DOMAIN="tre.internal"
fi
if [ -z "$SHARED_SERVICES_DNS" ]; then
  SHARED_SERVICES_DNS="10.253.0.253"
fi

cat <<EOF > "$HOME/.condarc"
channels:
  - conda-forge
channel_alias: "http://conda.${SHARED_SERVICES_DOMAIN}/"
EOF

cat <<EOF >> "$HOME/.Rprofile"
# TRE CRAN repository
local({r <- getOption("repos")
  r["CRAN"] <- "http://cran.${SHARED_SERVICES_DOMAIN}/"
  options(repos=r)
})
EOF

# The following sets the global DNS server which is used for entries in
# the Domains key when prefixed with a tilde. The Link name server (set
# by DHCP) is used for all other queries, allowing SSM endpoints etc to
# still be resolved within the VPC.
echo "DNS=${SHARED_SERVICES_DNS}" | sudo tee -a /etc/systemd/resolved.conf
echo "Domains=~${SHARED_SERVICES_DOMAIN}" | sudo tee -a /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved
