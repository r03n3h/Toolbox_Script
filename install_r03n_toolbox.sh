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
    python3pip
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


echo setting up shared folders 
echo -e "\n"
sleep 1
sudo cat <<EOF | sudo tee /usr/local/sbin/mount-shared-folders
vmware-hgfsclient | while read folder; do
vmwpath="/mnt/hgfs/\${folder}"
echo "[i] Mounting \${folder} (\${vmwpath})"
sudo mkdir -p "\${vmwpath}"
sudo umount -f "\${vmwpath}" 2>/dev/null
sudo vmhgfs-fuse -o allow_other -o auto_unmount ".host:/\${folder}" "\${vmwpath}"
done
sleep 2s
EOF

echo setting permissions
echo -e "\n"
sleep 2
sudo chmod +x /usr/local/sbin/mount-shared-folders

echo mounting shared folders
echo -e "\n"
sleep 2
sudo mount-shared-folders
sudo mkdir ~/shares
sudo /usr/bin/vmhgfs-fuse .host:/ ~/shares -o subtype=vmhgfs-fuse,allow_other

echo setting up terminal
echo -e "\n"
sleep 2
echo export PATH=$PATH:/home/kali/.local/bin >> ~/.zshrc

echo "alias grep='rg'" >> ~/.zshrc
echo "alias ls='exa -alg --group-directories-first'" >> ~/.zshrc
echo "alias cat='batcat'" >> ~/.zshrc

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

source ~/.zshrc

echo Installation complete, happy hacking!
