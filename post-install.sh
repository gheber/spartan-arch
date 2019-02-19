#!/bin/bash

# Run install.sh first or this will fail due to missing dependencies

# network on boot?
read -t 1 -n 1000000 discard      # discard previous input
sudo dhclient enp0s3
echo 'Waiting for internet connection'


# xinitrc
cd
head -n -5 /etc/X11/xinit/xinitrc > ~/.xinitrc
echo 'exec VBoxClient --clipboard -d &' >> ~/.xinitrc
echo 'exec VBoxClient --display -d &' >> ~/.xinitrc
echo 'exec i3 &' >> ~/.xinitrc
echo 'exec nitrogen --restore &' >> ~/.xinitrc
echo 'exec emacs' >> ~/.xinitrc

# emacs config
git clone https://github.com/abrochard/emacs-config.git
echo '(load-file "~/emacs-config/bootstrap.el")' > ~/.emacs
echo '(server-start)' >> ~/.emacs

# xterm setup
echo 'XTerm*background:black' > ~/.Xdefaults
echo 'XTerm*foreground:white' >> ~/.Xdefaults
echo 'UXTerm*background:black' >> ~/.Xdefaults
echo 'UXTerm*foreground:white' >> ~/.Xdefaults

# tmux setup like emacs
cd
echo 'unbind C-b' > ~/.tmux.conf
echo 'set -g prefix C-x' >> ~/.tmux.conf
echo 'bind C-x send-prefix' >> ~/.tmux.conf
echo 'bind 2 split-window' >> ~/.tmux.conf
echo 'bind 3 split-window -h' >> ~/.tmux.conf

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
git config --global user.name $(whoami)
git config --global user.email $(whoami)@$(hostname)
git config --global code.editor emacsclient
echo '    AddKeysToAgent yes' >> ~/.ssh/config

# if there are ssh key
if [ -d ~/workspace/ssh ]; then
    if [ -d ~/.ssh ]; then
        rm -rf ~/.ssh
    fi
    ln -s ~/workspace/ssh ~/.ssh
fi

# temporary workaround
cd
wget https://raw.githubusercontent.com/gheber/spartan-arch/master/startx.sh -O startx.sh
chmod +x startx.sh
echo 'alias startx=~/startx.sh' >> ~/.bashrc

echo 'Done'
~/startx.sh
