#!/usr/bin/env bash

# Idea: drop this on a new Debian VM and get going
sudo apt update && sudo apt upgrade

# Install golang via Google repo instead. The apt version seems broken (doesn't
# support all operation modes).
#sudo apt install gobuster
sudo apt install nmap
