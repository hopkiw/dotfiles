#!/bin/bash

set -e

if [[ $(id -u) -eq 0 ]]; then
  exec su -s /bin/bash - developer "$0" || :
fi

mkdir goroot
curl -s "https://dl.google.com/go/go1.18.3.linux-amd64.tar.gz" -o go.tar.gz
tar -C ~/goroot --strip-components=1 -xf go.tar.gz
rm go.tar.gz

export PATH=$HOME/.local/bin:$HOME/goroot/bin:$HOME/go/bin:$PATH
echo 'PATH=$HOME/.local/bin:$HOME/goroot/bin:$HOME/go/bin:$PATH' >> .bashrc
echo whoami $(whoami)

git clone --depth 1 https://github.com/hopkiw/dotfiles
cp .bashrc .bashrc.bak
cd dotfiles
for f in *; do mv "$f" "${HOME}/.${f}"; done
cd ..
rm -rf dotfiles
echo 'PATH=$HOME/goroot/bin:$HOME/go/bin:$HOME/.local/bin:$PATH' >> .bashrc

git clone https://github.com/tomasr/molokai
mkdir .vim
mv molokai/colors .vim/
rm -rf molokai

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vi +PluginInstall +qall  >/dev/null </dev/null
vi +GoInstallBinaries +qall  >/dev/null </dev/null

# TODO: where to get git config and live credentials from?

export PATH=$HOME/.local/bin:$PATH
pip install IPython flake8
