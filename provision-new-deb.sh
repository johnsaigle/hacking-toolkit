#!/usr/bin/env bash
# Run this script on a new Debian machine in order to get busy hacking.
set -e

apt update -y && apt upgrade -y
# THe following packages allow apt to communicate over HTTPS
apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
# Get software
apt install build-essential curl gcc git make python3-pip sudo tmux tig ripgrep neovim zip zsh -y

# Add docker files to apt repository
# https://www.linuxshelltips.com/install-docker-in-debian/
# TODO is there an easier way to do this?
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt -y install docker-ce docker-ce-cli containerd.io
# Install docker-compose. NOTE: Update version number
# https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-debian-10
# TODO This version should probably be updated
curl -L https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install Go. Adapted from https://go.dev/doc/install
LATEST="1.21.5"
ARCHIVE="go${LATEST}linux-amd64.tar.gz"
URL="https://go.dev/dl/${ARCHIVE}"
DST="/tmp/${ARCHIVE}"
cd /tmp/
curl -L $URL -o $DST # download and save to /tmp/
tar -C /usr/local -xzf $DST
# XXX: might also need ~/go/bin/
echo 'export PATH=$PATH:/usr/local/go/bin:' >> $HOME/.profile

# Use nvim as default editor
cat >> $HOME/.profile<< EOF
EDITOR=nvim
VISUAL=$EDITOR
export EDITOR VISUAL
EOF
source ~/.profile

# Install go tools
# TODO: add `anew`
# go get -v github.com/OWASP/Amass/v3/...
# go install github.com/ffuf/ffuf@latest
# go install github.com/tomnomnom/meg@latest
# go install github.com/tomnomnom/httprobe@latest

# python3 -m pip install trufflehog3

# Git tools:
#   - SQLmap

# cd /opt/
# git clone https://github.com/sqlmapproject/sqlmap.git
# git clone https://github.com/johnsaigle/hacking-toolkit

# Wordlists
# mkdir -p /usr/share/wordlists/
# cd /usr/share/wordlists/
# git clone https://github.com/danielmiessler/SecLists.git

cd
# Pull tmux config. I'm not expecting this to change much so avoid
# creating a git repository in $HOME
curl -O https://raw.githubusercontent.com/johnsaigle/rcs/master/.tmux.conf

# Setup nvim
git clone https://github.com/johnsaigle/nvim-config.git ~/.config/nvim/

# Install Oh my Zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
sed -i 's/robbyrussell/ys/g' ~/.zshrc # change theme 
source ~/.zshrc

# Create new SSH key for github access
# This must of course be added to GitHub afterward
KEY_FILE=$HOME/.ssh/github
echo 'Creating new SSH key...'
ssh-keygen -t ed25519 -C '' -f $KEY_FILE

# Make SSH key usable
eval $(ssh-agent)
ssh-add $KEY_FILE

cat > $HOME/.ssh/config<< EOF
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github
EOF

# Install Rust. Interactive shell script. Maybe there's a way to do it non-interactively?
# TODO: There appears to be an version of this in unstable (sid): https://packages.debian.org/sid/rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup toolchain install nightly

# Cleanup
apt autoremove

echo "Add the following key to GitHub:"
cat $HOME/.ssh/github.pub
