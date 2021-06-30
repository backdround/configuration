#!/bin/bash
# Setup script on bare archlinux.

# Exit script on any error
set -e

# Get setup instonse
INSTANCES="^(home|work|note|server)$"
if [[ ! "$1" =~ $INSTANCES ]]; then
  echo "couldn't get install type (work|home|note|server)"
  exit 1
fi

# Get project root
PROJECT_ROOT=$(git rev-parse --show-toplevel)


############################################################
# Common preset intall

# Install base / trizen / common packages

# Update
sudo pacman -Fy
sudo pacman --needed --noconfirm -Syu base base-devel git

cd "$PROJECT_ROOT"
if [[ "$1" == "server"  ]]; then

  # Create not root user (trizen)
  ./auxiliary/scripts/server_user.sh "$@"

  # Install trizen
  sudo -u trizen ./auxiliary/scripts/trizen.sh "$@"

  # Install packages
  sudo -u trizen trizen --needed --noconfirm -S $(cat ./dependencies/common_packets)
else

  # Install trizen
  ./auxiliary/scripts/trizen.sh "$@"

  # Install packages
  trizen --needed --noconfirm -S - < ./dependencies/common_packets
fi


# Create directory tree
mkdir -p ~/.nvimbk
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/bin


# Install configuration
sudo chsh "`whoami`" -s /bin/zsh
npm --prefix ./auxiliary/deploy ci && \
  npm --prefix ./auxiliary/deploy run deploy -- --instance $1

pip install --user neovim


# End of server install
if [ "$1" == "server" ]; then
  exit 0
fi


############################################################
# Desktop preset intall

# Create directory tree
mkdir -p ~/tmp
mkdir -p ~/downloads
mkdir -p ~/build
mkdir -p ~/projects

mkdir -p ~/other/videos
mkdir -p ~/other/music
mkdir -p ~/other/books
mkdir -p ~/other/screens
mkdir -p ~/other/docs
mkdir -p ~/other/test_projects

mkdir -p ~/.tmp/trizen
mkdir -p ~/.ssh && chmod 700 ~/.ssh


# Install packages
gpg --recv-keys 9B8450B91D1362C1
sudo pacman --needed --noconfirm -S - < dependencies/packets
trizen --needed --noconfirm -S - < dependencies/aur_packets


############################################################
# Configure packages

# Add desktop configurations
gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/kitty

# lang tool
pip install --user pyLanguagetool

# qutebrowser
/usr/share/qutebrowser/scripts/dictcli.py install en-US ru-RU

# npm
mkdir -p ~/.npm-global
npm config set prefix "~/.npm-global"
npm config set init-author-email "backdround@yandex.ru"
npm config set init-author-name "Vlad Chepaykin"
npm config set init-license "MIT"

# rager
test -d ~/.config/ranger/plugins/ranger_devicons || \
git clone -q git@github.com:alexanderjeurissen/ranger_devicons.git ~/.config/ranger/plugins/ranger_devicons


############################################################
# Services

systemctl --user daemon-reload
systemctl --user enable words-pad.service
systemctl --user enable telegram.service
systemctl --user enable ddterminal.service
systemctl --user enable picom
systemctl --user enable ranger
systemctl --user enable ssh-agent
systemctl --user enable dropbox_monitor
systemctl --user enable dropbox_sync.timer
sudo systemctl enable lightdm
sudo systemctl enable tor
