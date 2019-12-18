#!/bin/bash

# create backup only when first run
BACKUP_FLAG=/tmp/drop_backup
if [ ! -f $BACKUP_FLAG ] ; then
  touch $BACKUP_FLAG

  # remove older backup
  rm -rf ~/.local/share/drop
  mkdir -p ~/.local/share/

  cp -rf ~/drop ~/.local/share/
fi

# sync notes
if ! `rclone check drop: ./drop/ 2> /dev/null` ; then
  rclone sync drop: ~/drop/
fi
