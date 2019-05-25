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
    # check arg count
    count_of_args = len(sys.argv)
    if count_of_args == 2:

        instance = re.match("^(home|work|note)$", sys.argv[1])
        if not instance:
            error_exit("unknown instance")

        return instance.group(1), False

    elif count_of_args == 3:

        instance = re.match("^(home|work|note)$", sys.argv[1])
        if not instance:
            error_exit("unknown instance")

        force = re.match("^(force|f)$", sys.argv[2])
        if not force:
            error_exit("unknown option")

        return instance.group(1), True

    else:
        error_exit("unparsed count of arguments")



if __name__ == '__main__':

    # settings
    instance, force = get_arguments()
    project_root = os.path.abspath(os.path.dirname(__file__))

    # set instance for scripts
    instance_file_path = os.path.expanduser("~/.instance")
    with open(instance_file_path, 'w') as instance_file:
        instance_file.write(instance)

    # --------------------------------------------------------------------------
    # terminal
    terminal_pairs = (
        ["bashrc",             ".bashrc"],
        ["inputrc",            ".inputrc"],
        ["tmux",               ".tmux.conf"],
        ["zshrc",              ".zshrc"],
        ["zaw-bookmarks",      ".zaw-bookmarks"],
        ["termite",            ".config/termite/config"],
    )

    config_prefix = os.path.join(project_root, "terminal")
    symlink_prefix = os.path.expanduser("~/")
    utils.create_list_of_symlink(terminal_pairs, config_prefix, symlink_prefix, force)

    # --------------------------------------------------------------------------
    # qutebrowser
    qutebrowser_pairs = (
        ["config.py",           "config.py"],
        ["theme/draw.py",       "theme/draw.py"],
        ["quickmarks",          "quickmarks"],
        ["my_scripts/clear.js", "my_scripts/clear.js"],
    )

    config_prefix = os.path.join(project_root, "qutebrowser")
    symlink_prefix = os.path.expanduser("~/.config/qutebrowser/")
    utils.create_list_of_symlink(qutebrowser_pairs, config_prefix, symlink_prefix, force)

    # --------------------------------------------------------------------------
    # nvim
    nvim_pairs = [
        ["init.vim",                    ".config/nvim/init.vim"],
        ["init_for_editing.vim",        ".config/nvim/init_for_editing.vim"],
        ["coc-settings.json",           ".config/nvim/coc-settings.json"],

        ["notes/plugin_hotkeys",        ".local/share/nvim/notes/plugin_hotkeys"],
        ["notes/qute_hotkeys",          ".local/share/nvim/notes/qute_hotkeys"],
        ["notes/vim_useful_hotkeys",    ".local/share/nvim/notes/vim_useful_hotkeys"],

        ["UltiSnips/all.snippets",      ".local/share/nvim/UltiSnips/all.snippets"],
        ["UltiSnips/cpp.snippets",      ".local/share/nvim/UltiSnips/cpp.snippets"],
        ["UltiSnips/snippets.snippets", ".local/share/nvim/UltiSnips/snippets.snippets"],
    ]

    config_prefix = os.path.join(project_root, "nvim")
    symlink_prefix = os.path.expanduser("~/")
    utils.create_list_of_symlink(nvim_pairs, config_prefix, symlink_prefix, force)

    # --------------------------------------------------------------------------
    # misc
    misc_pairs = (
        ["cava",                     ".config/cava/config"],
        ["gdb",                      ".gdbinit"],
        ["gpg",                      ".gnupg/gpgconf.conf"],
        ["mouse_index.theme",        ".icons/default/index.theme"],
        ["rtorrent",                 ".rtorrent.rc"],
        ["git/gitconfig",            ".gitconfig"],
        ["git/gitignore_global",     ".gitignore_global"],
        ["gtk/gtk.css",              ".config/gtk-3.0/gtk.css"],
        ["gtk/settings.ini",         ".config/gtk-3.0/settings.ini"],
        ["gtk/gtkrc-2.0",            ".gtkrc-2.0"],
        ["mcabber/mcabber",          ".config/mcabber/mcabberrc"],
        ["mcabber/notify.mp3",       ".config/mcabber/notify.mp3"],
        ["mcabber/notify2.mp3",      ".config/mcabber/notify2.mp3"],
        ["music/mpd",                ".config/mpd/mpd.conf"],
        ["music/ncmpcpp",            ".ncmpcpp/config"],
        ["music/ncmpcpp_bindings",   ".ncmpcpp/bindings"],
    )

    config_prefix = os.path.join(project_root, "misc")
    symlink_prefix = os.path.expanduser("~/")
    utils.create_list_of_symlink(misc_pairs, config_prefix, symlink_prefix, force)

    # --------------------------------------------------------------------------
    # i3

    # generate config
    template_file = os.path.join(project_root, "desktop/i3/config_template")
    instance_file = os.path.join(project_root, "desktop/i3/config")

    # create config instance
    if os.path.isfile(instance_file):
        os.remove(instance_file)
    shutil.copyfile(template_file, instance_file)

    # make replace pairs
    if instance == "note":
        position_size = {
            "telegram":           ("400 560", "931 35"),
            "ncmpcpp":            ("50 485", "1266 250"),
            "dropdown":           ("5 5",     "1356 440"),
            "ranger":             ("5 5",     "1356 440"),
            "rtorrent":           ("192 108", "1536 864"),
            "gis_weather":        ("10 10",   ""),
            "qutebrowser_editor": ("65 65",   "540 290"),
        }
    else:
        position_size = {
            "telegram":           ("525 700", "1348 96"),
            "ncmpcpp":            ("210 745", "1500 300"),
            "dropdown":           ("5 5",     "1910 532"),
            "ranger":             ("5 5",     "1910 486"),
            "rtorrent":           ("192 108", "1536 864"),
            "gis_weather":        ("10 10",   ""),
            "qutebrowser_editor": ("65 65",   "675 336"),
        }
    replaces =      [('--position-{}--'.format(key), val1) for key, (val1, _) in position_size.items()]
    replaces.extend([('--size-{}--'.format(key), val2) for key, (_, val2) in position_size.items()])
    replaces.extend([("--inner-gaps--", "19")])

    # make replaces
    utils.replace_in_file(instance_file, replaces)

    # create symlink
    i3_pair = [["i3/config", ".config/i3/config"]]
    config_prefix = os.path.join(project_root, "desktop/")
    symlink_prefix = os.path.expanduser("~/")
    utils.create_list_of_symlink(i3_pair, config_prefix, symlink_prefix, force)

    # --------------------------------------------------------------------------
    # other desktop

    # i3 scripts
    scripts_directory = os.path.join(project_root, "desktop/i3/scripts/")
    scripts_pairs = utils.create_pairs_from_dir(scripts_directory)

    symlink_prefix = os.path.expanduser("~/Scripts/i3/")
    utils.create_list_of_symlink(scripts_pairs , scripts_directory, symlink_prefix, force)

    # systemd pairs
    systemd_directory = os.path.join(project_root, "desktop/systemd/")
    systemd_pairs = utils.create_pairs_from_dir(systemd_directory)

    symlink_prefix = os.path.expanduser("~/.config/systemd/user")
    utils.create_list_of_symlink(systemd_pairs, systemd_directory, symlink_prefix, force)

    # misc
    misc_pairs = [
        ["misc/compton.conf",   ".config/compton.conf"],
        ["misc/dunstrc",        ".config/dunst/dunstrc"],
        ["misc/gis_weather",    ".config/gis-weather/gw_config1.json"],
        ["misc/xinitrc",        ".xinitrc"],
        ["misc/xprofile",       ".xprofile"],
        ["misc/Xresources",     ".Xresources"],
        ["i3/config",           ".config/i3/config"],
        ["polybar/config",      ".config/polybar/config"],
        ["polybar/startup",     ".config/polybar/startup"],
        ["misc/ranger",         ".config/ranger/rc.conf"],
        ["xkb/keymap/config",   ".config/xkb/keymap/config"],
        ["xkb/symbols/nums",    ".config/xkb/symbols/nums"],
        ["xkb/symbols/special", ".config/xkb/symbols/special"],
    ]

    config_prefix = os.path.join(project_root, "desktop/")
    symlink_prefix = os.path.expanduser("~/")
    utils.create_list_of_symlink(misc_pairs, config_prefix, symlink_prefix, force)
