#!/bin/bash

# Checks
if [ "$#" -lt 1 ]; then
  echo "couldn't get install type (work|home|note)"
  exit 1
fi

if [ `sudo -v` ]; then
  echo "couldn't get sudo rights"
  exit 1
fi

# Preparation
sudo pacman -Fy
sudo pacman --needed --noconfirm -Syu base base-devel git

# Create directory tree
mkdir ~/Downloads
mkdir ~/tmp
mkdir ~/build
mkdir -p ~/Pictures/Screens
mkdir ~/.nvimbk
mkdir ~/.password-store
mkdir -p ~/.tmp/trizen

# Install trizen
cd ~/tmp/
git clone https://aur.archlinux.org/trizen.git
cd trizen/
makepkg --install --noconfirm --syncdeps
sed 's~^\(.*clone_dir.*\)".*"\(.*\)~\1"/home/vlad/.tmp/trizen"\2~' -i ~/.config/trizen/trizen.conf

# Install application with pacman
cd ~/configuration
gpg --recv-keys 9B8450B91D1362C1
sudo pacman --needed --noconfirm -S - < deps
trizen --needed --noconfirm -S - < deps_aur

# Install configuration
sudo chsh vlad -s /bin/zsh
./deploy.py "$@"
systemctl --user daemon-reload
systemctl --user enable telegram.service
systemctl --user enable ddterminal.service
systemctl --user enable compton
systemctl --user enable ncmpcpp
systemctl --user enable ranger
sudo systemctl enable lightdm
sudo systemctl enable tor
/usr/share/qutebrowser/scripts/dictcli.py install en-US ru-RU
pip install --user neovim
pip install --user pyLanguagetool
