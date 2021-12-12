#!/usr/bin/env bash
# Run this script on a new Debian machine in order to get busy hacking.
set -e

apt update -y && apt upgrade -y
apt install curl git sudo zip exiftool tmux python3-pip vim zsh -y

# Install Go
cd /tmp/
curl -L -O https://go.dev/dl/go1.17.4.linux-amd64.tar.gz
tar -xvf go1.17.4.linux-amd64.tar.gz
sudo chown -R root:root ./go
sudo mv go /usr/local
rm go1.17.4.linux-amd64.tar.gz
cd
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.profile
source ~/.profile

# Install go tools
go get -v github.com/OWASP/Amass/v3/...
go install github.com/ffuf/ffuf@latest
go install github.com/tomnomnom/meg@latest
go install github.com/tomnomnom/httprobe@latest

python3 -m pip install trufflehog3

# Git tools:
#   - SQLmap

cd /opt/
git clone https://github.com/sqlmapproject/sqlmap.git

# Wordlists
mkdir -p /usr/share/wordlists/
cd /usr/share/wordlists/
git clone https://github.com/danielmiessler/SecLists.git

# vim and tmux settings
cd
curl -O https://raw.githubusercontent.com/johnsaigle/rcs/master/.tmux.conf
curl -O https://raw.githubusercontent.com/johnsaigle/rcs/master/.vimrc

# Install Oh my Zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
sed -i 's/robbyrussell/ys/g' ~/.zshrc # change theme to 'ys'
source ~/.zshrc

# Create new SSH key for github access
KEY_FILE=$HOME/.ssh/github
echo 'Creating new SSH key...'
ssh-keygen -t ecdsa -C '' -f $KEY_FILE
eval $(ssh-agent)
ssh-add $KEY_FILE
