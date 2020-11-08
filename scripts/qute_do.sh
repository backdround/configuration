#!/bin/sh

if grep -q home ~/.instance; then
  export QT_AUTO_SCREEN_SCALE_FACTOR=1
  export QT_SCALE_FACTOR=1.5
fi

socket="${XDG_RUNTIME_DIR}/qutebrowser/ipc-$(echo -n "$USER" | md5sum | cut -d' ' -f1)"
bin="/usr/bin/qutebrowser"

printf '{"args": ["%s"], "target_arg": null, "protocol_version": 1}\n' "$@" \
  | socat - UNIX-CONNECT:"${socket}" 2>/dev/null || "$bin" "$@" &
