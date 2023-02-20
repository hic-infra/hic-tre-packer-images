#!/bin/bash

set -eu

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2019.list)"
sudo apt-get update
sudo apt-get install -y mssql-server

sudo tee /var/opt/mssql/mssql.conf <<EOF
[sqlagent]
enabled = true

[EULA]
accepteula = true
EOF

sudo tee /etc/cron.d/mssql-install <<EOF
@reboot root /opt/ami-setup/mssql-setup.sh 2>&1 > /opt/ami-setup/mssql.log
EOF

cat > /opt/ami-setup/mssql-setup.sh <<EOF
#!/bin/bash

[ -f /.first-boot ] && exit 0

PASSWORD=\$(openssl rand -base64 15)aA1\$

sudo MSSQL_SA_PASSWORD="\$PASSWORD" \
    /opt/mssql/bin/mssql-conf set-sa-password

IP=\$(ip addr | grep inet | awk '{ print \$2 }' | \
          grep -o 10.[0-9]*.[0-9]*.[0-9]*)

cat <<ABC > /home/ubuntu/Desktop/readme.txt

   MSSQL address: \$IP
   Initial login: sa
Initial password: \$PASSWORD

The password can be changed manually with:

/opt/mssql/mssql-bin/mssql-conf set-sa-password

Or from SQL Management Studio on a remote machine.

ABC

sudo systemctl enabled mssql-server
sudo systemctl start mssql-server

sudo touch /.first-boot
EOF

chmod +x /opt/ami-setup/mssql-setup.sh




