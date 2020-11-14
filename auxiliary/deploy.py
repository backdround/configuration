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
    instance = re.match("^(home|work|note|server)$", sys.argv[1])
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
        ["configs/terminal/p10k.zsh",                "~/.p10k.zsh"],
        ["configs/terminal/kitty.conf",              "~/.config/kitty/kitty.conf"],
        ["configs/terminal/ranger",                  "~/.config/ranger/rc.conf"],

        # Git
        ["configs/git/gitconfig",                    "~/.gitconfig"],
        ["configs/git/gitignore_global",             "~/.gitignore_global"],

        # Nvim
        ["configs/nvim/init.vim",                    "~/.config/nvim/init.vim"],
        ["configs/nvim/coc-settings.json",           "~/.config/nvim/coc-settings.json"],
        ["configs/nvim/keymap/custom_ru.vim",        "~/.config/nvim/keymap/custom_ru.vim"],

        ["configs/nvim/UltiSnips/all.snippets",      "~/.local/share/nvim/UltiSnips/all.snippets"],
        ["configs/nvim/UltiSnips/cpp.snippets",      "~/.local/share/nvim/UltiSnips/cpp.snippets"],
        ["configs/nvim/UltiSnips/qml.snippets",      "~/.local/share/nvim/UltiSnips/qml.snippets"],
        ["configs/nvim/UltiSnips/snippets.snippets", "~/.local/share/nvim/UltiSnips/snippets.snippets"],

        # Misc
        ["configs/misc/trizen.conf",                 "~/.config/trizen/trizen.conf"],
        ["configs/misc/xprofile",                    "~/.xprofile"],
        ["configs/misc/Xresources",                  "~/.Xresources"],
    )
    deployer.create_list_of_symlink(minimal_config_pairs)

    deployer.symlink_all_files_in_dir("scripts/",  "~/.local/bin/")

    if instance == "server":
        sys.exit(0)

    # --------------------------------------------------------------------------
    # Desktop confis
    desktop_config_pairs = (
        # Qutebrowser
        ["configs/qutebrowser/config.py",           "~/.config/qutebrowser/config.py"],
        ["configs/qutebrowser/style.css",           "~/.config/qutebrowser/style.css"],
        ["configs/qutebrowser/theme/draw.py",       "~/.config/qutebrowser/theme/draw.py"],
        ["configs/qutebrowser/quickmarks",          "~/.config/qutebrowser/quickmarks"],
        ["configs/qutebrowser/greasemonkey",        "~/.local/share/qutebrowser/greasemonkey"],
        ["configs/qutebrowser/my_scripts/clear.js", "~/.config/qutebrowser/my_scripts/clear.js"],

        # Polybar
        ["configs/polybar/config",                  "~/.config/polybar/config"],
        ["configs/polybar/startup",                 "~/.config/polybar/startup"],

        # Keyboard
        ["configs/keyboard/keymap/config",          "~/.config/xkb/keymap/config"],
        ["configs/keyboard/symbols/dv_layout",      "~/.config/xkb/symbols/dv_layout"],
        ["configs/keyboard/symbols/ru_layout",      "~/.config/xkb/symbols/ru_layout"],

        # Gtk
        ["configs/gtk/gtk.css",                     "~/.config/gtk-3.0/gtk.css"],
        ["configs/gtk/settings.ini",                "~/.config/gtk-3.0/settings.ini"],
        ["configs/gtk/gtkrc-2.0",                   "~/.gtkrc-2.0"],

        # Rofi
        ["configs/rofi/style.rasi",                 "~/.config/rofi/style.rasi"],
        ["configs/rofi/config.rasi",                "~/.config/rofi/config.rasi"],

        # Desktop
        ["configs/desktop/picom.conf",              "~/.config/picom.conf"],
        ["configs/desktop/dunstrc",                 "~/.config/dunst/dunstrc"],
        ["configs/desktop/mouse_index.theme",       "~/.icons/default/index.theme"],
        ["configs/desktop/user-dirs.dirs",          "~/.config/user-dirs.dirs"],
        ["configs/desktop/mimeapps.list",           "~/.config/mimeapps.list"],

        # Misc
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
    if os.path.exists(instance_file) or os.path.islink(instance_file):
        os.remove(instance_file)
    shutil.copyfile(template_file, instance_file)

    # make replace pairs
    position_size = {
        "telegram":           ("1348 96", "525 700"),
        "dropdown":           ("18 46",   "1884 499"),
        "ranger":             ("18 46",   "1884 499"),
        "qutebrowser_editor": ("",        "675 336"),
    }

    if instance == "home":
        position_size["dropdown"] = ("978 352", "1884 499")
        position_size["ranger"] = ("978 352", "1884 499")
        position_size["telegram"] = ("2872 468", "580 740")

    replaces =      [('--position-{}--'.format(key), val1) for key, (val1, _) in position_size.items()]
    replaces.extend([('--size-{}--'.format(key), val2) for key, (_, val2) in position_size.items()])
    replaces.extend([("--inner-gaps--", "19")])

    if instance == "home":
        replaces.extend([("--left_monitor--", "DP-1")])
        replaces.extend([("--right_monitor--", "DVI-D-1")])
    elif instance == "work":
        replaces.extend([("--left_monitor--", "DP-1")])
        replaces.extend([("--right_monitor--", "HDMI-2")])

    # make replaces
    utils.replace_in_file(instance_file, replaces)

    # --------------------------------------------------------------------------
    # less
    lesskey_input = os.path.join(project_root, "configs/terminal/lesskeys")
    lesskey_output = os.path.expanduser("~/.lesskey")
    lesskey_command = "lesskey -o {} -- {}".format(lesskey_output, lesskey_input)
    os.system(lesskey_command)

    # --------------------------------------------------------------------------
    # other desktop
    deployer.symlink_all_files_in_dir("services/", "~/.config/systemd/user")
    deployer.symlink_all_files_in_dir("links/",    "~/.local/share/applications")
    deployer.create_list_of_symlink([["templates", "~/templates"]])
