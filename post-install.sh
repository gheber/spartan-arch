#!/bin/bash

# Run install.sh first or this will fail due to missing dependencies

# network on boot?
read -t 1 -n 1000000 discard      # discard previous input
sudo dhclient enp0s3
echo 'Waiting for internet connection'


# xinitrc
cd
head -n -5 /etc/X11/xinit/xinitrc > ~/.xinitrc
echo 'xrandr --output Virtual-1 --mode 1920x1200' >> ~/.xinitrc
echo 'exec VBoxClient --clipboard -d &' >> ~/.xinitrc
echo 'exec VBoxClient --display -d &' >> ~/.xinitrc
echo 'exec i3 &' >> ~/.xinitrc
echo 'exec emacs' >> ~/.xinitrc

# xterm setup
echo 'XTerm*background:white' > ~/.Xdefaults
echo 'XTerm*foreground:black' >> ~/.Xdefaults
echo 'UXTerm*background:white' >> ~/.Xdefaults
echo 'UXTerm*foreground:black' >> ~/.Xdefaults

# environment variable
echo 'export EDITOR=emacsclient' >> ~/.bashrc
echo 'export TERMINAL=lxterminal' >> ~/.bashrc

# i3status
if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi
mkdir ~/.config/i3status
cp /etc/i3status.conf ~/.config/i3status/config
sed -i 's/^order += "ipv6"/#order += "ipv6"/' ~/.config/i3status/config
sed -i 's/^order += "run_watch VPN"/#order += "run_watch VPN"/' ~/.config/i3status/config
sed -i 's/^order += "wireless _first_"/#order += "wireless _first_"/' ~/.config/i3status/config
sed -i 's/^order += "battery 0"/#order += "battery 0"/' ~/.config/i3status/config

# git first time setup
git config --global user.name "Gerd Heber"
git config --global user.email "gheber@hdfgroup.org"
git config --global code.editor emacsclient

# temporary workaround
cd
wget https://raw.githubusercontent.com/gheber/spartan-arch/master/startx.sh -O startx.sh
chmod +x startx.sh
echo 'alias startx=~/startx.sh' >> ~/.bashrc

echo 'Done'
~/startx.sh
