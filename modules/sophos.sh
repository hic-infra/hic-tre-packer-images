#!/bin/bash

set -eu

cd /opt/ami-setup

# There have been a few cases where this 'downloads' but is zero bytes,
# hence this rather disgusting loop.
while [ ! -s SophosSetup.sh ] ; do
    sleep 5
    curl -o SophosSetup.sh "${SOPHOS_SETUP_SH}"
    chmod +x SophosSetup.sh
done

# if https://central.sophos.com is accessible assume full outbound access
cat > sophos-install-job.sh <<EOF
#!/bin/bash

# Cron uses a restricted PATH, ensure the full root PATH is used
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

install_sophos() {
  [ -d /opt/sophos-spl ] && rm -rf /opt/sophos-spl

  while ! curl -s http://${SOPHOS_MESSAGE_RELAY} && ! curl -s https://central.sophos.com > /dev/null ; do
    date
    echo "${SOPHOS_MESSAGE_RELAY} not available yet, sleeping..."
    sleep 60
  done

  echo "Sophos is reachable!"

  date
  /opt/ami-setup/SophosSetup.sh --group="HIC - AWS - Cloud TRE\\\\${SOPHOS_GROUP}"

  date
  echo "Sophos install complete"
}

[ -f /.sophos ] && exit 0

while ! systemctl status sophos-spl > /dev/null; do
  echo "sophos-spl not found, running installer"
  install_sophos
  if ! systemctl status sophos-spl; then
    sleep 300
  fi
done

echo "Creating /.sophos to prevent future installs"
touch /.sophos
EOF

chmod +x sophos-install-job.sh

sudo tee /etc/cron.d/sophos <<EOF
@reboot root /opt/ami-setup/sophos-install-job.sh 2>&1 > /opt/ami-setup/sophos.log
EOF
