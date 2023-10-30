#!/usr/bin/env sh
exec nvim +'set nobackup | set nowritebackup | set noswapfile' "$@"
