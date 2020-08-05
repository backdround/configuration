#!/bin/sh
kitty --class qute_editor bash -c "nvim $@ --cmd 'let g:editor = 1'"
