#!/usr/bin/env bash
# Run this script on a new Debian machine in order to get busy hacking.
set -e

apt update -y && apt upgrade -y
# THe following packages allow apt to communicate over HTTPS
apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
# Get software
apt install curl git nmap sudo zip exiftool tmux python3-pip vim whois zsh -y

# Add docker files to apt repository
# https://www.linuxshelltips.com/install-docker-in-debian/
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt -y install docker-ce docker-ce-cli containerd.io
# Install docker-compose. NOTE: Update version number
# https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-debian-10
curl -L https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install Go
cd /tmp/
curl -L -O https://go.dev/dl/go1.17.4.linux-amd64.tar.gz
tar -xvf go1.17.4.linux-amd64.tar.gz
chown -R root:root ./go
mv go /usr/local
rm go1.17.4.linux-amd64.tar.gz
cd
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.profile

# Use vim as default editor
cat >> $HOME/.profile<< EOF
EDITOR=vim
VISUAL=$EDITOR
export EDITOR VISUAL
EOF
source ~/.profile

# Install go tools
# TODO: add `anew`
go get -v github.com/OWASP/Amass/v3/...
go install github.com/ffuf/ffuf@latest
go install github.com/tomnomnom/meg@latest
go install github.com/tomnomnom/httprobe@latest

python3 -m pip install trufflehog3

# Git tools:
#   - SQLmap

cd /opt/
git clone https://github.com/sqlmapproject/sqlmap.git
git clone https://github.com/johnsaigle/hacking-toolkit

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

cat > $HOME/.ssh/config<< EOF
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github
EOF
