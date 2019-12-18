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
    # terminal
    terminal_pairs = (
        ["terminal/inputrc",            "~/.inputrc"],
        ["terminal/bat",                "~/.config/bat/config"],
        ["terminal/tmux",               "~/.tmux.conf"],
        ["terminal/zshrc",              "~/.zshrc"],
        ["terminal/termite",            "~/.config/termite/config"],
    )
    deployer.create_list_of_symlink(terminal_pairs)

    # --------------------------------------------------------------------------
    # qutebrowser
    qutebrowser_pairs = (
        ["qutebrowser/config.py",           "~/.config/qutebrowser/config.py"],
        ["qutebrowser/theme/draw.py",       "~/.config/qutebrowser/theme/draw.py"],
        ["qutebrowser/quickmarks",          "~/.config/qutebrowser/quickmarks"],
        ["qutebrowser/my_scripts/clear.js", "~/.config/qutebrowser/my_scripts/clear.js"],
    )
    deployer.create_list_of_symlink(qutebrowser_pairs)

    # --------------------------------------------------------------------------
    # nvim
    nvim_pairs = [
        ["nvim/init.vim",                    "~/.config/nvim/init.vim"],
        ["nvim/coc-settings.json",           "~/.config/nvim/coc-settings.json"],

        ["nvim/notes/plugin_hotkeys",        "~/.local/share/nvim/notes/plugin_hotkeys"],
        ["nvim/notes/qute_hotkeys",          "~/.local/share/nvim/notes/qute_hotkeys"],
        ["nvim/notes/vim_useful_hotkeys",    "~/.local/share/nvim/notes/vim_useful_hotkeys"],

        ["nvim/UltiSnips/all.snippets",      "~/.local/share/nvim/UltiSnips/all.snippets"],
        ["nvim/UltiSnips/cpp.snippets",      "~/.local/share/nvim/UltiSnips/cpp.snippets"],
        ["nvim/UltiSnips/snippets.snippets", "~/.local/share/nvim/UltiSnips/snippets.snippets"],
    ]
    deployer.create_list_of_symlink(nvim_pairs)

    # --------------------------------------------------------------------------
    # misc
    misc_pairs = (
        ["misc/cava",                     "~/.config/cava/config"],
        ["misc/gpg",                      "~/.gnupg/gpgconf.conf"],
        ["misc/mouse_index.theme",        "~/.icons/default/index.theme"],
        ["misc/git/gitconfig",            "~/.gitconfig"],
        ["misc/git/gitignore_global",     "~/.gitignore_global"],
        ["misc/gtk/gtk.css",              "~/.config/gtk-3.0/gtk.css"],
        ["misc/gtk/settings.ini",         "~/.config/gtk-3.0/settings.ini"],
        ["misc/gtk/gtkrc-2.0",            "~/.gtkrc-2.0"],
        ["misc/mcabber/mcabber",          "~/.config/mcabber/mcabberrc"],
        ["misc/mcabber/notify.mp3",       "~/.config/mcabber/notify.mp3"],
        ["misc/mcabber/notify2.mp3",      "~/.config/mcabber/notify2.mp3"],
        ["misc/music/mpd",                "~/.config/mpd/mpd.conf"],
        ["misc/music/ncmpcpp",            "~/.ncmpcpp/config"],
        ["misc/music/ncmpcpp_bindings",   "~/.ncmpcpp/bindings"],
    )
    deployer.create_list_of_symlink(misc_pairs)

    # --------------------------------------------------------------------------
    # i3 template

    # generate config
    template_file = os.path.join(project_root, "desktop/i3/config_template")
    instance_file = os.path.join(project_root, "desktop/i3/config")

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

    # create symlink
    i3_pair = [["desktop/i3/config", "~/.config/i3/config"]]
    deployer.create_list_of_symlink(i3_pair)

    # --------------------------------------------------------------------------
    # other desktop

    # scripts
    deployer.symlink_all_files_in_dir("desktop/scripts/", "~/.local/bin/")

    # systemd
    deployer.symlink_all_files_in_dir("desktop/systemd/", "~/.config/systemd/user")

    # desktop links
    deployer.symlink_all_files_in_dir("desktop/applications/", "~/.local/share/applications")


    # misc
    misc_pairs = [
        ["desktop/misc/pulse",          "~/.config/pulseaudio-ctl/config"],
        ["desktop/misc/user-dirs.dirs", "~/.config/user-dirs.dirs"],
        ["desktop/misc/compton.conf",   "~/.config/compton.conf"],
        ["desktop/misc/trizen.conf",    "~/.config/trizen/trizen.conf"],
        ["desktop/misc/dunstrc",        "~/.config/dunst/dunstrc"],
        ["desktop/misc/gis_weather",    "~/.config/gis-weather/gw_config1.json"],
        ["desktop/misc/xinitrc",        "~/.xinitrc"],
        ["desktop/misc/xprofile",       "~/.xprofile"],
        ["desktop/misc/Xresources",     "~/.Xresources"],
        ["desktop/misc/mimeapps.list",  "~/.config/mimeapps.list"],
        ["desktop/i3/config",           "~/.config/i3/config"],
        ["desktop/polybar/config",      "~/.config/polybar/config"],
        ["desktop/polybar/startup",     "~/.config/polybar/startup"],
        ["desktop/misc/ranger",         "~/.config/ranger/rc.conf"],
        ["desktop/xkb/keymap/config",   "~/.config/xkb/keymap/config"],
        ["desktop/xkb/symbols/nums",    "~/.config/xkb/symbols/nums"],
        ["desktop/xkb/symbols/special", "~/.config/xkb/symbols/special"],
    ]
    deployer.create_list_of_symlink(misc_pairs)

    # templates
    deployer.create_list_of_symlink([["templates", "~/templates"]])
