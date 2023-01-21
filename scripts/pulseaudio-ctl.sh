#!/bin/bash
set -euo pipefail

# Gets action
ACTION="${1:-}"
if [[ ! "$ACTION" =~ ^(up|down)$ ]]; then
  echo "Action must be up or down" >&1
  exit 1
fi


# Gets current volume
VOLUME="$(pamixer --get-volume)"

# Rounds to 5
VOLUME="$((($VOLUME + 2) / 5 * 5))"


# Calculates result volume
if [[ "$ACTION" == up ]]; then
  VOLUME="$((VOLUME + 5))"
else
  VOLUME="$((VOLUME - 5))"
fi

# Sets new volmue
pamixer --set-limit 130 --allow-boost --set-volume "$VOLUME"
