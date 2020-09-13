#!/bin/bash

# Update and Upgrade
sudo apt-get update --assume-yes && sudo apt-get upgrade --assume-yes

# Configure and enable UFW 
sudo ufw allow 22
sudo ufw allow 8080
sudo ufw allow 8443
sudo ufw allow 8880
sudo ufw allow 8843
sudo ufw allow 6789
sudo ufw allow 27117
sudo ufw allow 3478/udp
sudo ufw allow 10001/udp
sudo ufw allow 1900/udp
sudo ufw enable --assume-yes

# install hyper-v tools
echo installing hyper-v tools
sudo apt-get install linux-azure --assume-yes
 
# Install Unifi
# From: https://help.ubnt.com/hc/en-us/articles/220066768-UniFi-How-to-Install-Update-via-APT-on-Debian-or-Ubuntu
   # Dependencies
sudo apt-get update && sudo apt-get install ca-certificates apt-transport-https --assume-yes
echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list
sudo wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg 

wget -qO - https://www.mongodb.org/static/pgp/server-3.4.asc | sudo apt-key add -
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get update --assume-yes

sudo apt-mark hold openjdk-11-* --assume-yes

   # Unifi
sudo apt-get update && sudo apt-get install unifi -y --assume-yes

# may be needed
# sudo apt-get install default-jre --assume-yes


# Install Remote Management Tools


# Install Complete

read -p "Launch http://x.x.x.x:8080/ to access the controller"
