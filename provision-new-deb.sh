#!/usr/bin/env bash
# Run this script on a new Debian machine in order to get busy hacking.
set -e

sudo apt update && sudo apt upgrade

# Install golang via Google repo instead. The apt version seems broken (doesn't
# support all operation modes).
#sudo apt install gobuster
sudo apt install nmap

mkdir $HOME/wordlists
git clone https://github.com/danielmiessler/SecLists.git $HOME/wordlists
