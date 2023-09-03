#!/bin/bash

set -eu -o pipefail

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo repistory update
sudo apt update

echo setting up terminal
echo -e "\n"
sleep 2
echo export PATH=$PATH:/home/kali/.local/bin >> ~/.zshrc

echo "alias grep='rg'" >> ~/.zshrc
echo "alias ls='exa -alg --group-directories-first'" >> ~/.zshrc
echo "alias cat='batcat'" >> ~/.zshrc
echo "alias listener='sudo rlwrap nc -lvnp 4321'" >> ~/.zshrc

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

source ~/.zshrc

echo Setting up tmux 
sleep 1
cd
git clone https://github.com/r03n3h/.tmux.git
sleep 1
ln -s -f .tmux/.tmux.conf
sleep 1
cp .tmux/.tmux.conf.local .

echo Installation complete, happy hacking!
