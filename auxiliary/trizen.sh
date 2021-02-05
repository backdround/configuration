#!/bin/bash

# Exit script on any error
set -e

# Install trizen package
cd /tmp/
git clone https://aur.archlinux.org/trizen.git
cd trizen/
makepkg --needed --install --noconfirm --syncdeps

# Generate config.
trizen -q > /dev/null

# Change tmp dir.
sed 's~^\(.*clone_dir.*\)".*"\(.*\)~\1"$ENV{HOME}/.tmp/trizen"\2~' -i ~/.config/trizen/trizen.conf
