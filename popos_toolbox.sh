#!/bin/bash

set -eu -o pipefail

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo "repistory update"
sudo apt update

echo "setting up installation files en repo's"

#yubikey
mkdir Tools
cd Tools
mkdir yubikey
cd yubikey
wget https://developers.yubico.com/yubikey-manager-qt/Releases/yubikey-manager-qt-latest-linux.AppImage
wget https://developers.yubico.com/yubioath-desktop/Releases/yubioath-desktop-latest-linux.AppImage
chmod +x ~/Tools/yubikey/*.AppImage
sudo bash ~/Tools/yubikey/yubikey-manager-qt-1.2.4b-linux.AppImage
sudo bash ~/Tools/yubikey/yubioath-desktop-5.1.0-linux.AppImage

#screenrec
sudo wget -q -O - https://screenrec.com/download/pub.asc | sudo apt-key add -
sudo add-apt-repository 'deb https://screenrec.com/download/ubuntu stable main'



echo "installing the must-have pre-requisites"
sudo apt update

while read -r p ; do sudo apt-get install -y $p ; done < <(cat << "EOF"
    tmux
    locate
    figlet
    hardinfo
    gnome-tweaks
    flameshot
    htop
    protonvpn
    tree
    ripgrep
    bat
    neofetch
    screenrec
EOF
)

sudo apt-get install -y tig

echo "alias grep='rg'" >> ~/.zshrc
echo "alias ls='exa -alg --group-directories-first'" >> ~/.zshrc
echo "alias cat='batcat'" >> ~/.zshrc

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
source ~/.zshrc

echo "Installation complete!"
