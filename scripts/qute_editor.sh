#!/bin/sh
termite --class qute_editor --exec="bash -c \"sleep 0.06 && nvim $@ --cmd 'let g:editor = 1'\""
