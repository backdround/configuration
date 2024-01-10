#!/usr/bin/env bash

if [ -z ${NVIM_APPNAME+x} ]; then
  export NVIMPAGER_NVIM=nvimpager.sh
  exec nvimpager "$@"
else
  export NVIM_APPNAME=nvim
  exec nvim --cmd 'lua LightWeight = true' "$@"
fi
