#!/bin/bash

set -eu -o pipefail

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo repistory update
sudo apt update

echo installing the must-have pre-requisites
while read -r p ; do sudo apt-get install -y $p ; done < <(cat << "EOF"
    fuse3
    open-vm-tools
    open-vm-tools-desktop
    ltrace
    strace
    flameshot
    jd-gui
    ghidra
    wkhtmltopdf
    adb
    apktool
    dex2jar
    python3-pip
    tree
    feroxbuster
    jq
    terminator
    cupp
    ripgrep
    bat
    exa
    gobuster
    sqlmap
    hcxtools 
    tmux
    cargo
    xclip
EOF
)

sudo apt-get install -y tig

command -v locate seclists >/dev/null 2>&1 ||
while true; do
    read -p "SecLists from Daniel Miessler is the security tester's companion, do you wish to install this big list (do you have some time?) " yn
    case $yn in
        [Yy]* ) sudo apt install seclists  -y; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo python apps
echo -e "\n"
sleep 1

pip3 install pwntools --no-warn-script-location
pip3 install apkid
pip3 install apkleaks

echo variable aanpassen
echo -e "\n"
sleep 1
export PATH=$PATH:/home/kali/.local/bin

echo "Setting up your fancy hacking terminal"
echo -e "\n"
sleep 2
echo export PATH=$PATH:~/.local/bin >> ~/.zshrc

echo "alias grep='rg'" >> ~/.zshrc
echo "alias ls='exa -alg --group-directories-first'" >> ~/.zshrc
echo "alias cat='batcat'" >> ~/.zshrc

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

source ~/.zshrc

echo "Setting op credmp's hed for easy host edit"
sleep 1
cargo install hed
sleep 1
echo export PATH=\$PATH:~/.cargo/bin >> ~/.zshrc
echo export PATH=\$PATH:~/.cargo/bin >> ~/.bashrc

echo "Setting up your special tmux hacking  setting"
sleep 1
cd
git clone https://github.com/gpakosz/.tmux.git
sleep 1
ln -s -f .tmux/.tmux.conf
sleep 1
cp .tmux/.tmux.conf.local .

echo "Installation complete, happy hacking!"
