#!/bin/bash
# Please get the config into your home dir firstly.
# cd ~
# git clone https://github.com/huawenyu/dotfiles.git

sudo apt-get update
sudo apt-get install -f
sudo update-rc.d cron defaults

sudo apt-get remove mono-runtime-common
sudo apt-get install -y audacious gnome-mplayer xfce4-notes

sudo apt-get install -y curl zsh xterm tmux ruby silversearcher-ag traceroute smbclient openssh-server minicom lftp meld
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sudo apt-get install -y git subversion
# vim (+clientserver)
sudo apt-get install -y vim-gnome
# vim (+lua): apt-cache search libluajit
sudo apt-get install libluajit-5.1-2
# ansi2txt (kbtin)
sudo apt-get install -y tree cscope ctags w3m kbtin
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Develop Env
sudo apt-get install -y build-essential ia32-libs libc6-dbg:i386 manpages-dev
# Gcc Compile: check header not found error
# sudo updatedb
# locate stdio.h

# neovim
sudo apt-get install python-dev python-pip python3-dev python3-pip
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim
# nvim :help nvim_python
sudo pip install neovim

# Java JDK
sudo apt-add-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
# Please add this line to the shell profile
# export JAVA_HOME="/usr/lib/jvm/java-8-oracle"

# wireshark
sudo apt-get install wireshark
sudo dpkg-reconfigure wireshark-common
sudo usermod -a -G wireshark $USER

# tshark, command-line of wireshark
# tshark -i eth0 -w tmp.pcap
sudo apt-get install --force-yes tshark
sudo chgrp $USER /usr/bin/dumpcap
sudo chmod 750 /usr/bin/dumpcap
sudo setcap cap_net_raw,cap_net_admin+eip /usr/bin/dumpcap

# tftp
sudo apt-get install xinetd tftpd tftp
sudo cp tftp /etc/xinetd.d/tftp
sudo mkdir /tftpboot
sudo chmod -R 777 /tftpboot
sudo chown -R nobody /tftpboot
sudo service xinetd restart

## Samba
## https://help.ubuntu.com/community/Samba/SambaServerGuide
## Assume linux already have a username $USER, otherwise please add it first.
#sudo apt-get install -y samba smbclient
#sudo smbpasswd -a $USER
#sudo patch -p0 /etc/samba/smb.conf patch.smbconf
#sudo smbpasswd -a $USER
#sudo smbd reload
#sudo service smbd restart
## List all shares:
##smbclient -L //<HOST_IP_OR_NAME>/<folder_name> -U <user>
## connect:
##smbclient //<HOST_IP_OR_NAME>/<folder_name> -U <user>

# If laptop, install battery
#sudo apt-get install indicator-power

# Startup.sh
crontab -l > /tmp/my-crontab
echo "@reboot sh /home/$USER/.startup.sh > /tmp/cronlog 2>&1" >> /tmp/my-crontab
sudo crontab /tmp/my-crontab

vim -c 'PluginInstall'
# End of file

