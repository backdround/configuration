#!/bin/python
import os
import sys
import re
import shutil
import utils

def error_exit(error_string):
    print("error was occured!!")
    print(error_string, "\n")
    sys.exit(1)

def get_arguments():
    count_of_args = len(sys.argv)

    # check arg count
    if count_of_args != 2 and count_of_args != 3:
        error_exit("unparsed count of arguments")

    # get force
    force = False
    if count_of_args == 3:
        force = re.match("^(force|f)$", sys.argv[2])
        if not force:
            error_exit("unknown option")

    # get instance name
    instance = re.match("^(home|work|note)$", sys.argv[1])
    if not instance:
        error_exit("unknown instance")

    return instance.group(1), force


if __name__ == '__main__':

    # settings
    instance, force = get_arguments()
    project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), "../"))

    # set instance for scripts
    instance_file_path = os.path.expanduser("~/.instance")
    with open(instance_file_path, 'w') as instance_file:
        instance_file.write(instance)

    # create deployer
    deployer = utils.Deployer(project_root, force)

    # --------------------------------------------------------------------------
    # Minimals shared configs
    minimal_config_pairs = (
        # Terminal
        ["configs/terminal/inputrc",                 "~/.inputrc"],
        ["configs/terminal/bat",                     "~/.config/bat/config"],
        ["configs/terminal/tmux",                    "~/.tmux.conf"],
        ["configs/terminal/zshrc",                   "~/.zshrc"],
        ["configs/terminal/termite",                 "~/.config/termite/config"],
        ["configs/terminal/ranger",                  "~/.config/ranger/rc.conf"],

        # Git
        ["configs/git/gitconfig",                    "~/.gitconfig"],
        ["configs/git/gitignore_global",             "~/.gitignore_global"],

        # Nvim
        ["configs/nvim/init.vim",                    "~/.config/nvim/init.vim"],
        ["configs/nvim/coc-settings.json",           "~/.config/nvim/coc-settings.json"],

        ["configs/nvim/notes/plugin_hotkeys",        "~/.local/share/nvim/notes/plugin_hotkeys"],
        ["configs/nvim/notes/qute_hotkeys",          "~/.local/share/nvim/notes/qute_hotkeys"],
        ["configs/nvim/notes/vim_useful_hotkeys",    "~/.local/share/nvim/notes/vim_useful_hotkeys"],

        ["configs/nvim/UltiSnips/all.snippets",      "~/.local/share/nvim/UltiSnips/all.snippets"],
        ["configs/nvim/UltiSnips/cpp.snippets",      "~/.local/share/nvim/UltiSnips/cpp.snippets"],
        ["configs/nvim/UltiSnips/snippets.snippets", "~/.local/share/nvim/UltiSnips/snippets.snippets"],

        # Misc
        ["configs/misc/trizen.conf",                 "~/.config/trizen/trizen.conf"],
        ["configs/misc/xprofile",                    "~/.xprofile"],
        ["configs/misc/Xresources",                  "~/.Xresources"],
    )
    deployer.create_list_of_symlink(minimal_config_pairs)

    # --------------------------------------------------------------------------
    # Desktop confis
    desktop_config_pairs = (
        # Qutebrowser
        ["configs/qutebrowser/config.py",           "~/.config/qutebrowser/config.py"],
        ["configs/qutebrowser/theme/draw.py",       "~/.config/qutebrowser/theme/draw.py"],
        ["configs/qutebrowser/quickmarks",          "~/.config/qutebrowser/quickmarks"],
        ["configs/qutebrowser/my_scripts/clear.js", "~/.config/qutebrowser/my_scripts/clear.js"],

        # Polybar
        ["configs/polybar/config",                  "~/.config/polybar/config"],
        ["configs/polybar/startup",                 "~/.config/polybar/startup"],

        # Keyboard
        ["configs/keyboard/keymap/config",          "~/.config/xkb/keymap/config"],
        ["configs/keyboard/symbols/nums",           "~/.config/xkb/symbols/nums"],
        ["configs/keyboard/symbols/special",        "~/.config/xkb/symbols/special"],

        # Gtk
        ["configs/gtk/gtk.css",                     "~/.config/gtk-3.0/gtk.css"],
        ["configs/gtk/settings.ini",                "~/.config/gtk-3.0/settings.ini"],
        ["configs/gtk/gtkrc-2.0",                   "~/.gtkrc-2.0"],

        # Music
        ["configs/music/mpd",                       "~/.config/mpd/mpd.conf"],
        ["configs/music/ncmpcpp",                   "~/.ncmpcpp/config"],
        ["configs/music/ncmpcpp_bindings",          "~/.ncmpcpp/bindings"],

        # Desktop
        ["configs/desktop/compton.conf",            "~/.config/compton.conf"],
        ["configs/desktop/dunstrc",                 "~/.config/dunst/dunstrc"],
        ["configs/desktop/mouse_index.theme",       "~/.icons/default/index.theme"],
        ["configs/desktop/user-dirs.dirs",          "~/.config/user-dirs.dirs"],
        ["configs/desktop/mimeapps.list",           "~/.config/mimeapps.list"],

        # Misc
        ["configs/misc/gis_weather",                "~/.config/gis-weather/gw_config1.json"],
        ["configs/misc/gpg",                        "~/.gnupg/gpgconf.conf"],
        ["configs/misc/pulse",                      "~/.config/pulseaudio-ctl/config"],
    )
    deployer.create_list_of_symlink(desktop_config_pairs)

    # --------------------------------------------------------------------------
    # i3 template

    # generate config
    template_file = os.path.join(project_root, "configs/desktop/i3_template")
    instance_file = os.path.expanduser("~/.config/i3/config")

    # create config instance
    if os.path.isfile(instance_file):
        os.remove(instance_file)
    shutil.copyfile(template_file, instance_file)

    # make replace pairs
    position_size = {
        "telegram":           ("525 700", "1348 96"),
        "ncmpcpp":            ("210 745", "1500 300"),
        "dropdown":           ("5 5",     "1910 532"),
        "ranger":             ("5 5",     "1910 486"),
        "gis_weather":        ("10 10",   ""),
        "qutebrowser_editor": ("",        "675 336"),
    }
    replaces =      [('--position-{}--'.format(key), val1) for key, (val1, _) in position_size.items()]
    replaces.extend([('--size-{}--'.format(key), val2) for key, (_, val2) in position_size.items()])
    replaces.extend([("--inner-gaps--", "19")])

    if instance == "home":
        replaces.extend([("--primary--", "DVI-D-1")])
        replaces.extend([("--secondary--", "DP-1")])
    elif instance == "work":
        replaces.extend([("--primary--", "DP-1")])
        replaces.extend([("--secondary--", "HDMI-2")])

    # make replaces
    utils.replace_in_file(instance_file, replaces)

    # --------------------------------------------------------------------------
    # other desktop
    deployer.symlink_all_files_in_dir("scripts/",  "~/.local/bin/")
    deployer.symlink_all_files_in_dir("services/", "~/.config/systemd/user")
    deployer.symlink_all_files_in_dir("links/",    "~/.local/share/applications")
    deployer.create_list_of_symlink([["templates", "~/templates"]])
