#!/bin/bash

# Install trizen package
cd /tmp/
git clone https://aur.archlinux.org/trizen.git
cd trizen/
makepkg --needed --install --noconfirm --syncdeps

# Generate config.
trizen -q

# Change tmp dir.
sed 's~^\(.*clone_dir.*\)".*"\(.*\)~\1"$ENV{HOME}/.tmp/trizen"\2~' -i ~/.config/trizen/trizen.conf

# Ignore further changes in trizen config.
TRIZEN_PATH=$(find . -name "trizen.conf")
git update-index --assume-unchanged "$TRIZEN_PATH"
