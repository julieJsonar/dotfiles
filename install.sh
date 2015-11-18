#!/bin/bash
# Please get the config into your home dir firstly.
# cd ~
# git clone https://github.com/huawenyu/dotfiles.git

sudo apt-get update

sudo apt-get remove mono-runtime-common
sudo apt-get install -y audacious gnome-mplayer xfce4-notes

sudo apt-get install -y curl zsh xterm tmux ruby
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sudo apt-get install -y git subversion
~/dotfiles/sync.sh -a pull

sudo apt-get install -y vim
sudo apt-get install -y tree cscope ctags w3m
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Develop Env
sudo apt-get install -y ia32-libs smbclient openssh-server minicom lftp meld

# Java JDK
sudo apt-add-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
# Please add this line to the shell profile
# export JAVA_HOME="/usr/lib/jvm/java-8-oracle"


# tftp
sudo apt-get install xinetd tftpd tftp
sudo cp tftp /etc/xinetd.d/tftp
sudo mkdir /tftpboot
sudo chmod -R 777 /tftpboot
sudo chown -R nobody /tftpboot
sudo service xinetd restart

# Samba
# https://help.ubuntu.com/community/Samba/SambaServerGuide
# Assume linux already have a username <wilson>, otherwise please add it first.
sudo apt-get install -y samba smbclient
sudo smbpasswd -a wilson
sudo patch -p0 /etc/samba/smb.conf patch.smbconf
sudo smbpasswd -a wilson
sudo smbd reload
sudo service smbd restart
# List all shares:
#smbclient -L //<HOST_IP_OR_NAME>/<folder_name> -U <user>
# connect:
#smbclient //<HOST_IP_OR_NAME>/<folder_name> -U <user>

vim -c 'PluginInstall'
# End of file
