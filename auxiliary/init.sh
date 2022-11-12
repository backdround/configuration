#!/bin/bash
# Setup script on bare archlinux.

# Exit script on any error
set -e

# Get setup instonse
INSTANCES="^(home|work|note)$"
if [[ ! "$1" =~ $INSTANCES ]]; then
  echo "couldn't get install type (work|home|note)"
  exit 1
fi

# Get project root
PROJECT_ROOT=$(git rev-parse --show-toplevel)



# Update
sudo pacman -Fy
sudo pacman --needed --noconfirm -Syu base base-devel git

cd "$PROJECT_ROOT"

############################################################
# Install trizen

which trizen > /dev/null || {
  cd /tmp/
  git clone https://aur.archlinux.org/trizen.git
  cd trizen/
  makepkg --needed --install --noconfirm --syncdeps

  # Generate config.
  trizen -q > /dev/null

  # Change tmp dir.
  sed 's~^\(.*clone_dir.*\)".*"\(.*\)~\1"$ENV{HOME}/.tmp/trizen"\2~' -i ~/.config/trizen/trizen.conf
}

# Update
trizen -Fy
trizen -Sy

############################################################
# Create directory tree
mkdir -p ~/.nvimbk
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/bin

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


############################################################
# Install packages

# Install common packages
trizen --needed --noconfirm -S - < ./packages/common_packets

# Install configuration
sudo chsh "`whoami`" -s /bin/zsh
npm --prefix ./auxiliary/deploy ci && \
  npm --prefix ./auxiliary/deploy run deploy -- --instance $1

pip install --user neovim


# Install packages
gpg --recv-keys 9B8450B91D1362C1
sudo pacman --needed --noconfirm -S - < packages/packets
trizen --needed --noconfirm -S - < packages/aur_packets


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

# go
go env -w GOMODCACHE="/home/$(whoami)/.go"
go env -w GOPATH="/home/$(whoami)/.go"

# rager
test -d ~/.config/ranger/plugins/ranger_devicons || \
git clone -q git@github.com:alexanderjeurissen/ranger_devicons.git ~/.config/ranger/plugins/ranger_devicons


############################################################
# Services

systemctl --user daemon-reload
systemctl --user enable telegram.service
systemctl --user enable ddterminal.service
systemctl --user enable picom
systemctl --user enable ranger
systemctl --user enable ssh-agent
sudo systemctl enable lightdm
sudo systemctl enable tor
