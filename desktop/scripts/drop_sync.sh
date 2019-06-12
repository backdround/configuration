#!/bin/bash

if ! `rclone check drop: ./drop/ 2> /dev/null` ; then
  rclone sync drop: ~/drop/
fi
