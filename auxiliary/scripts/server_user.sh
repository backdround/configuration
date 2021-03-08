#!/bin/bash
# Create trizen user to install aur packages from not root user.

# Check root required
if [[ "$EUID" != 0 ]]; then
  echo "To create trizen user, you should have root rights"
  exit 1
fi

# Check trizen user exist
grep -q "trizen" /etc/shadow
if [ $? -eq 0 ]; then
  echo "User already exists"
  exit 0
fi


# Add sudo rights without password
sed "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/" /etc/sudoers > /tmp/sudoers.bak
visudo -cf /tmp/sudoers.bak

if [ $? -eq 0 ]; then
  mv -f /tmp/sudoers.bak /etc/sudoers
else
  echo "Couldn't add change sudoers"
  exit 1
fi


# Create trizen user
useradd trizen -s /usr/bin/bash -m -d /home/trizen
passwd -d trizen
usermod -a -G wheel trizen
