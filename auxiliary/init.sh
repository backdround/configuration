#!/bin/bash
# Setup script on bare archlinux.

# Get setup instonse
INSTANCES="^(home|work|note|server)$"
if [[ ! "$1" =~ $INSTANCES ]]; then
  echo "couldn't get install type (work|home|note|server)"
  exit 1
fi

# Get project root
SCRIPT_PATH=$(dirname "$0")
PROJECT_ROOT=$(realpath "${SCRIPT_PATH}/..")


############################################################
# Common preset intall

# Install base / trizen / common packages

# Update
sudo pacman -Fy
sudo pacman --needed --noconfirm -Syu base base-devel git

cd "$PROJECT_ROOT"
if [[ "$1" == "server"  ]]; then

  # Create not root user (trizen)
  ./auxiliary/server_user.sh "$@"

  # Install trizen
  sudo -u trizen ./auxiliary/trizen.sh "$@"

  # Install packages
  sudo -u trizen sh -c "trizen --needed --noconfirm -S - < ./dependencies/common_packets"
else

  # Install trizen
  ./auxiliary/trizen.sh "$@"

  # Install packages
  trizen --needed --noconfirm -S - < ./dependencies/common_packets
fi


# Create directory tree
mkdir ~/.nvimbk
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/other
mkdir -p ~/.local/bin


# Install configuration
sudo chsh "$USER" -s /bin/zsh
./auxiliary/deploy.py "$@"
pip install --user neovim


# End of server install
if [ "$1" == "server" ]; then
  exit 0
fi


############################################################
# Desktop preset intall

# Create directory tree
mkdir ~/tmp
mkdir ~/drop
mkdir ~/downloads
mkdir ~/build

mkdir -p ~/other/videos
mkdir -p ~/other/music
mkdir -p ~/other/books
mkdir -p ~/other/screens
mkdir -p ~/other/docs

mkdir ~/.password-store
mkdir -p ~/.tmp/trizen
mkdir ~/.ssh && chmod 700 ~/.ssh


# Install packages
gpg --recv-keys 9B8450B91D1362C1
sudo pacman --needed --noconfirm -S - < dependencies/packets
trizen --needed --noconfirm -S - < dependencies/aur_packets


############################################################
# Configure packages

# Add desktop configurations
gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/termite
gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-x"

# lang tool
pip install --user pyLanguagetool

# qutebrowser
/usr/share/qutebrowser/scripts/dictcli.py install en-US ru-RU

# npm
mkdir ~/.npm-global
npm config set prefix "~/.npm-global"
npm config set init-author-email "backdround@yandex.ru"
npm config set init-author-name "Vlad Chepaykin"
npm config set init-license "MIT"


############################################################
# Services

systemctl --user daemon-reload
systemctl --user enable telegram.service
systemctl --user enable ddterminal.service
systemctl --user enable compton
systemctl --user enable ranger
systemctl --user enable ssh-agent
systemctl --user enable dropbox_monitor
systemctl --user enable dropbox_sync.timer
sudo systemctl enable lightdm
sudo systemctl enable tor
