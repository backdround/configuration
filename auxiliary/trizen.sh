#!/bin/bash
# Install trizen package

cd /tmp/
git clone https://aur.archlinux.org/trizen.git
cd trizen/
makepkg --needed --install --noconfirm --syncdeps
sed 's~^\(.*clone_dir.*\)".*"\(.*\)~\1"$ENV{HOME}/.tmp/trizen"\2~' -i ~/.config/trizen/trizen.conf
