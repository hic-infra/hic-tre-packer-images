#!/bin/bash

curl -sfLO https://sqlopsbuilds.azureedge.net/stable/fab63efd307e54c063c8af03474bbb5d77f5fd11/azuredatastudio-linux-1.35.1.deb
sudo dpkg -i azuredatastudio-linux-1.35.1.deb


wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/prod.list)"
sudo apt-get update

sudo ACCEPT_EULA=Y apt-get install -y msodbcsql18
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18

sudo apt-get install -y unixodbc-dev
