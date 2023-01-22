#!/bin/bash
set -euo pipefail
# Script fixes this issues:
#	https://github.com/flameshot-org/flameshot/issues/3065
# Restore focus after flameshot exit.


FOCUSED_WINDOW=$(xdotool getwindowfocus)

flameshot gui || true

test "$FOCUSED_WINDOW" = "$(xdotool getwindowfocus)" || {
	xdotool windowfocus $FOCUSED_WINDOW
}
