#!/usr/bin/env bash
set -euo pipefail

WORKSPACES="$(i3-msg -t get_workspaces)"

GET_UNFOCUSED_OUTPUT="\
  .[] | select(.visible == true and .focused == false) | .output"
DISPLAY_OUTPUT="$(echo "$WORKSPACES" | jq "$GET_UNFOCUSED_OUTPUT")"

i3-msg focus output "$DISPLAY_OUTPUT"
