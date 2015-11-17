#!/bin/bash

sudo apt-get update

sudo apt-get remove mono-runtime-common
sudo apt-get install -y audacious gnome-mplayer xfce4-notes

sudo apt-get install -y curl zsh xterm tmux
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sudo apt-get install -y git subversion
git clone https://github.com/huawenyu/dotfiles.git
~/dotfiles/sync.sh -a pull

sudo apt-get install -y vim
sudo apt-get install -y tree cscope ctags w3m
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Develop Env
sudo apt-get install -y ia32-libs smbclient openssh-server minicom lftp meld

# JDK
sudo apt-add-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
# export JAVA_HOME="/usr/lib/jvm/java-8-oracle"

vim -c 'PluginInstall'
# End of file
