#!/usr/bin/env bash
# Run this script on a new Debian machine in order to get busy hacking.
set -e

sudo apt update && sudo apt upgrade

sudo apt install python3-pip y

# Install golang via Google repo instead. The apt version seems broken (doesn't
# support all operation modes).
#sudo apt install gobuster
sudo apt install nmap

# Git tools:
#   - GraphQL Map
#   - jwt_tool
#   - SQLmap
#   - XXEInjector

cd /opt/
sudo git clone https://github.com/securing/DumpsterDiver.git
sudo git clone https://github.com/sqlmapproject/sqlmap.git
sudo git clone https://github.com/swisskyrepo/GraphQLmap.git
sudo git clone https://github.com/ticarpi/jwt_tool.git
sudo git clone https://github.com/enjoiz/XXEinjector.git

# Wordlists
mkdir $HOME/wordlists
git clone https://github.com/danielmiessler/SecLists.git $HOME/wordlists

