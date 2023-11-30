#!/bin/sh
kitty --class qute_editor bash -c "nvim --cmd 'lua LightWeight = true' $@"
