#!/bin/bash
# init cnofigurations script on bare archlinux.

set -euo pipefail

USER_PASSWORD="${1:-}"
disable_sudo_password_on_script_execution() {
  use_sudo() {
    echo "${USER_PASSWORD:-}" | sudo -p "" -S "$@" || {
      return 1
    }
  }

  # Checks sudo access.
  sudo -K
  use_sudo -v 2>/dev/null || {
    echo "Unable to get sudo"
    echo "Is password correct?"
    return 1
  }

  # Disables sudo cache timeout.
  SUDOERS_DISABLE_PASSWORD="$(whoami) ALL=(ALL:ALL) NOPASSWD: ALL"
  use_sudo bash -c "echo '${SUDOERS_DISABLE_PASSWORD}' >> /etc/sudoers"

  # Enables sudo cache timeout on script exit.
  undo_action() {
    use_sudo sed -i "/${SUDOERS_DISABLE_PASSWORD}/d" /etc/sudoers
  }
  trap undo_action EXIT

  # Checks sudo execution after manipulations.
  echo "" | sudo -S -v || {
    echo "Unable to disable sudo cache timeout"
  }
}

check_paswordless_sudo() {
  sudo -K
  echo "" | sudo -p "" -v -S 2>/dev/null || return 1
  return 0
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

    # Changes clone directory.
    sed -i 's~^\(.*clone_dir.*\)".*"\(.*\)~\1"$ENV{HOME}/.tmp/trizen"\2~' ~/.config/trizen/trizen.conf

    # Creates clone directory.
    mkdir -p ~/.tmp/trizen
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

check_paswordless_sudo || disable_sudo_password_on_script_execution

base-preparations
update-trizen
update-home-directory-tree
update-packages
configure-packages
enable-services
