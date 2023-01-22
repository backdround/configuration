#!/bin/bash
# init cnofigurations script on bare archlinux.
set -euo pipefail

############################################################
# Utils

OUTPUT_RED='\033[1;31m'
OUTPUT_YELLOW='\033[1;33m'
OUTPUT_BLUE='\033[1;34m'
OUTPUT_RESET="$(tput sgr0)"

error() {
  echo -e "$OUTPUT_RED""$@""$OUTPUT_RESET" >&2
  return 1
}

warning() {
  echo -e "$OUTPUT_YELLOW""$@""$OUTPUT_RESET" >&2
}

title() {
  echo -en "\n$OUTPUT_BLUE#######---$OUTPUT_RESET "
  echo -n "$@"
  echo -en " $OUTPUT_BLUE---#######$OUTPUT_RESET\n"
}


############################################################
# Configure

USER_PASSWORD="${1:-}"
disable_sudo_password_on_script_execution() {
  title "Temporary disabling sudo password"
  use_sudo() {
    echo "${USER_PASSWORD:-}" | sudo -p "" -S "$@" || {
      return 1
    }
  }

  # Checks sudo access.
  sudo -K
  use_sudo -v 2>/dev/null || {
    error "Unable to get sudo\nIs password correct?"
  }

  # Disables sudo cache timeout.
  SUDOERS_DISABLE_PASSWORD="$(whoami) ALL=(ALL:ALL) NOPASSWD: ALL"
  use_sudo bash -c "echo '${SUDOERS_DISABLE_PASSWORD}' >> /etc/sudoers"

  # Enables sudo cache timeout on script exit.
  undo_action() {
    title "Enabling sudo password"
    use_sudo sed -i "/${SUDOERS_DISABLE_PASSWORD}/d" /etc/sudoers
  }
  trap undo_action EXIT

  # Checks sudo execution after manipulations.
  echo "" | sudo -p "" -S ls 2>/dev/null >&2 || {
    error "Unable to disable sudo cache timeout"
  }
}

check_paswordless_sudo() {
  title "Checking presence sudo password"
  sudo -K
  echo "" | sudo -p "" -S ls 2>/dev/null >&2 || return 1
  return 0
}

base-preparations() {
  title "Providing base packages"
  sudo pacman -Fy
  sudo pacman --needed --noconfirm -Syu base base-devel git

  # Changes directory to project root level
  PROJECT_ROOT=$(git rev-parse --show-toplevel)
  cd "$PROJECT_ROOT"
}

provide-trizen() {
  title "Providing trizen"
  # Installs if needed
  which trizen > /dev/null || {
    git clone https://aur.archlinux.org/trizen.git /tmp/trizen
    (cd /tmp/trizen && makepkg --needed --install --noconfirm --syncdeps)
    rm -rf /tmp/trizen
  }

  # Updates databases
  trizen -Fy
  trizen -Sy
}

provide-home-directory-tree() {
  title "Providing home directory tree"
  mkdir -p ~/tmp
  mkdir -p ~/projects
  mkdir -p ~/downloads
  mkdir -p ~/screens
  mkdir -p ~/.tests

  # xdg user dirs
  mkdir -p ~/other/docs
  mkdir -p ~/other/music
  mkdir -p ~/other/videos
  mkdir -p ~/other/books
  mkdir -p ~/.none

  mkdir -p ~/.ssh && chmod 700 ~/.ssh
}

provide-packages() {
  title "Installing official packages"
  source packages/official
  sudo pacman --needed --noconfirm -S "${OFFICIAL_PACKAGES[@]}"

  title "Installing aur packages"
  source packages/aur
  trizen --needed --clone-dir="/tmp/trizen-clone" --noconfirm -S "${AUR_PACKAGES[@]}"

  # Remove cache
  sudo rm -rf /var/cache/pacman/pkg/*
  rm -rf /tmp/trizen-clone
}

configure-packages() {
  title "Configuring packages"

  # zsh
  echo "Setting zsh shell as default"
  sudo chsh "$(whoami)" -s /bin/zsh

  # neovim
  echo "Installation python neovim"
  pip install --user neovim

  # langtool
  echo "Installation pyLanguagetool"
  pip install --user pyLanguagetool

  # qutebrowser
  echo "Downloading qutebrowser dictionaries"
  /usr/share/qutebrowser/scripts/dictcli.py install en-US ru-RU || {
    warning "Unable to install qutebrowser spell checkings"
  }

  # rager
  echo "Downloading ranger devicons"
  test -d ~/.config/ranger/plugins/ranger_devicons || \
    git clone https://github.com/alexanderjeurissen/ranger_devicons \
      ~/.config/ranger/plugins/ranger_devicons || {
      warning "Unable to settnig up ranger icons"
  }
}

provide-systemd-services() {
  title "Providing services"
  sudo systemd-detect-virt --chroot || {
    systemctl --user daemon-reload
  }

  systemctl --user enable ddterminal.service
  systemctl --user enable picom
  systemctl --user enable dunst
  systemctl --user enable ranger
  systemctl --user enable ssh-agent
  sudo systemctl enable lightdm
}

check_paswordless_sudo || disable_sudo_password_on_script_execution

base-preparations
provide-trizen
provide-home-directory-tree
provide-packages
configure-packages
provide-systemd-services
