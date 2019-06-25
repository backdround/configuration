#!/bin/sh
exec termite --class qute_editor --exec="nvim $@ --cmd 'let g:editor = 1'"
