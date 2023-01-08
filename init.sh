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

provide-home-directory-tree() {
  title "Providing home directory tree"
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

provide-packages() {
  title "Installing official packages"
  source packages/official
  sudo pacman --needed --noconfirm -S "${OFFICIAL_PACKAGES[@]}"

  title "Installing aur packages"
  source packages/aur
  trizen --needed --noconfirm -S "${AUR_PACKAGES[@]}"
}

configure-packages() {
  title "Configuring packages"

  # Adds desktop configurations
  gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/kitty

  # zsh
  sudo chsh "$(whoami)" -s /bin/zsh

  # neovim
  pip install --user neovim

  # langtool
  pip install --user pyLanguagetool

  # qutebrowser
  /usr/share/qutebrowser/scripts/dictcli.py install en-US ru-RU || {
    warning "Unable to install qutebrowser spell checkings"
  }

  # go
  go env -w GOMODCACHE="/home/$(whoami)/.go"
  go env -w GOPATH="/home/$(whoami)/.go"

  # rager
  test -d ~/.config/ranger/plugins/ranger_devicons || \
    git clone -q git@github.com:alexanderjeurissen/ranger_devicons.git ~/.config/ranger/plugins/ranger_devicons || {
    warning "Unable to settnig up ranger icons"
  }
}

provide-systemd-services() {
  title "Providing services"
  systemctl --user daemon-reload || {
    warning "Unable to systemctl daemon-reload"
    warning "Possible chroot environment"
  }
  systemctl --user enable ddterminal.service
  systemctl --user enable picom
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
