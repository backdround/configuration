#!/bin/bash
# Script setup my system on bare archlinux

# Check
if [ "$#" -lt 1 ]; then
  echo "couldn't get install type (work|home|note)"
  exit 1
fi

# Preparation
sudo pacman -Fy
sudo pacman --needed --noconfirm -Syu base base-devel git

# Create my directory tree
mkdir ~/drop
mkdir ~/tmp
mkdir ~/build
mkdir ~/.nvimbk
mkdir ~/.password-store
mkdir -p ~/.tmp/trizen

# create default dirs
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/other
mkdir -p ~/.local/bin
mkdir ~/downloads
mkdir ~/templates
mkdir ~/docs
mkdir ~/music
mkdir ~/videos
mkdir ~/books
mkdir ~/screens

# Install trizen
cd ~/tmp/
git clone https://aur.archlinux.org/trizen.git
cd trizen/
makepkg --needed --install --noconfirm --syncdeps
sed 's~^\(.*clone_dir.*\)".*"\(.*\)~\1"$ENV{HOME}/.tmp/trizen"\2~' -i ~/.config/trizen/trizen.conf

# Install packages
cd ~/configuration
gpg --recv-keys 9B8450B91D1362C1
sudo pacman --needed --noconfirm -S - < deps
trizen --needed --noconfirm -S - < deps_aur

# Install configuration
sudo chsh "$USER" -s /bin/zsh
gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/termite
gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-x"
./deploy.py "$@"

# Install dependencies
/usr/share/qutebrowser/scripts/dictcli.py install en-US ru-RU
pip install --user neovim
pip install --user pyLanguagetool

# Setup default services
systemctl --user daemon-reload
systemctl --user enable telegram.service
systemctl --user enable ddterminal.service
systemctl --user enable compton
systemctl --user enable ncmpcpp
systemctl --user enable ranger
systemctl --user enable dropbox_monitor
systemctl --user enable dropbox_sync.timer
sudo systemctl enable lightdm
sudo systemctl enable tor
