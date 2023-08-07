#!/bin/bash

set -eu

INSTALLER_FILENAME=insightvm-agent_installer.sh

cd /opt/ami-setup

aws s3 cp "s3://${S3_PACKER_RESOURCES_PATH}/rapid7/$INSTALLER_FILENAME" .
RAPID7_INSIGHT_TOKEN=$(aws s3 cp "s3://${S3_PACKER_RESOURCES_PATH}/rapid7/rapid7_insight_token.txt" -)
chmod +x $INSTALLER_FILENAME

if [ -z "${RAPID7_PROXY_HOST:-}" ]; then
  RAPID7_PROXY_ARGS=""
else
  RAPID7_PROXY_ARGS="--https-proxy ${RAPID7_PROXY_HOST}:3128"
fi

cat > insight-install-job.sh <<EOF
#!/bin/bash

# Cron uses a restricted PATH, ensure the full root PATH is used
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

cd /opt/ami-setup

function install_insight () {
  ./$INSTALLER_FILENAME install_start \
      --token "${RAPID7_INSIGHT_TOKEN}" \
      ${RAPID7_PROXY_ARGS} \
      --attributes "workspace,ubuntu"
}

while ! systemctl status ir_agent > /dev/null; do
  echo "ir_agent (Insight Rapid7) not found, running installer"
  install_insight
  if ! systemctl status ir_agent; then
    sleep 300
  fi
done

EOF

chmod +x insight-install-job.sh

sudo tee /etc/cron.d/insight <<EOF
@reboot root /opt/ami-setup/insight-install-job.sh 2>&1 > /opt/ami-setup/insight.log
EOF
