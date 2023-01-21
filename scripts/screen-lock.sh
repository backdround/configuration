#!/bin/bash
# i3lock wrapper that has a nice and fast blur.

REAL_SCREEN="/tmp/real-screen.xwd"
LOCK_SCREEN="/tmp/lock-screen.png"

# Prints screen
xwd -silent -root -out "$REAL_SCREEN"

# Blurs
convert "$REAL_SCREEN" -scale 10% -resize 1000% "$LOCK_SCREEN"

# Locks
i3lock --pointer "default" --image "$LOCK_SCREEN"

# Cleans up
rm -rf "$REAL_SCREEN"
rm -rf "$LOCK_SCREEN"
