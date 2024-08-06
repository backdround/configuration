#!/bin/bash
set -euo pipefail

CONFIG="${1:-}"

test -n "$CONFIG" || {
  echo "Config path isn't set"
  exit 1
}

# Sets directory permition
CONFIG_DIRECTORY="$(dirname "$(realpath "$CONFIG")")"
chmod 700 "$CONFIG_DIRECTORY"

# Creates config
cat > "$CONFIG" <<EOF
default-cache-ttl 30
max-cache-ttl 60

pinentry-program /usr/bin/pinentry-gtk
EOF

# Sets config permition
chmod 600 "$CONFIG"
