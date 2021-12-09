#!/usr/bin/env bash
# Run this script on a new Debian machine in order to get busy hacking.
set -e

apt update -y && apt upgrade -y
apt install curl git sudo zip exiftool
apt install python3-pip -y

cd /tmp/
curl -L -O https://go.dev/dl/go1.17.4.linux-amd64.tar.gz
tar -xvf go1.17.4.linux-amd64.tar.gz
sudo chown -R root:root ./go
sudo mv go /usr/local
rm go1.17.4.linux-amd64.tar.gz
cd
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile

pip install trufflehog3

# Install golang via Google repo instead. The apt version seems broken (doesn't
# support all operation modes).
#sudo apt install gobuster
apt install nmap

# Git tools:
#   - SQLmap

cd /opt/
git clone https://github.com/sqlmapproject/sqlmap.git

# Wordlists
mkdir -p /usr/share/wordlists/
cd /usr/share/wordlists/
git clone https://github.com/danielmiessler/SecLists.git
