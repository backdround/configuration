#!/bin/bash
# init cnofigurations script on bare archlinux.

set -euo pipefail

USER_PASSWORD="${1:-}"
use_sudo() {
  echo "${USER_PASSWORD:-}" | sudo -p "" -S "$@" || {
    return 1
  }
}

check_sudo_access() {
  use_sudo ls > /dev/null || {
    echo "Unable to get sudo"
    return 1
  }
}

base-preparations() {
  # Changes directory to project root level
  PROJECT_ROOT=$(git rev-parse --show-toplevel)
  cd "$PROJECT_ROOT"

  # Updates databases
  sudo pacman -Fy
  sudo pacman --needed --noconfirm -Syu base base-devel git
}

update-trizen() {
  # Installs if needed
  which trizen > /dev/null || {
    git clone https://aur.archlinux.org/trizen.git /tmp/trizen
    (cd /tmp/trizen && makepkg --needed --install --noconfirm --syncdeps)

    # Generates config.
    trizen -q > /dev/null

    # Changes tmp dir.
    sed 's~^\(.*clone_dir.*\)".*"\(.*\)~\1"$ENV{HOME}/.tmp/trizen"\2~' -i ~/.config/trizen/trizen.conf
  }

  # Updates databases
  trizen -Fy
  trizen -Sy
}

update-home-directory-tree() {
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
}

update-packages() {
  # Installs common packages
  trizen --needed --noconfirm -S - < ./packages/common_packets

  # Install packages
  sudo pacman --needed --noconfirm -S - < packages/packets
  trizen --needed --noconfirm -S - < packages/aur_packets
}

configure-packages() {
  # Adds desktop configurations
  gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/kitty

  # zsh
  sudo chsh "$(whoami)" -s /bin/zsh

  # neovim
  pip install --user neovim

  # langtool
  pip install --user pyLanguagetool

  # qutebrowser
  /usr/share/qutebrowser/scripts/dictcli.py install en-US ru-RU

  # go
  go env -w GOMODCACHE="/home/$(whoami)/.go"
  go env -w GOPATH="/home/$(whoami)/.go"

  # rager
  test -d ~/.config/ranger/plugins/ranger_devicons || \
  git clone -q git@github.com:alexanderjeurissen/ranger_devicons.git ~/.config/ranger/plugins/ranger_devicons
}

enable-services() {
  systemctl --user daemon-reload
  systemctl --user enable ddterminal.service
  systemctl --user enable picom
  systemctl --user enable ranger
  systemctl --user enable ssh-agent
  sudo systemctl enable lightdm
}

check_sudo_access
base-preparations
update-trizen
update-home-directory-tree
update-packages
configure-packages
enable-services
