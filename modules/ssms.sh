#!/bin/bash

curl -sfLO https://download.microsoft.com/download/6b2bfeac-9c1b-4182-9a2f-ce86ff8cc371/azuredatastudio-linux-1.52.0.deb
sudo dpkg -i azuredatastudio-linux-1.52.0.deb


wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list" \
    | sudo tee /etc/apt/sources.list.d/mssql-release.list
sudo apt-get update

sudo ACCEPT_EULA=Y apt-get install -y msodbcsql18
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18

sudo apt-get install -y unixodbc-dev
