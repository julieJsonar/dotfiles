#!/bin/bash

sudo apt-get update

sudo apt-get remove mono-runtime-common
sudo apt-get install -y audacious gnome-mplayer xfce4-notes

sudo apt-get install -y curl
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sudo agt-get install -y git subversion
git clone https://github.com/huawenyu/dotfiles.git
~/dotfiles/sync.sh -a pull

sudo apt-get install -y vim
sudo apt-get install -y tree cscope ctags w3m
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c 'PluginInstall'

# End of file
