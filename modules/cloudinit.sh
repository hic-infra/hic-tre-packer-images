#!/bin/bash

/usr/bin/cloud-init status --wait
sudo apt remove -y unattended-upgrades
