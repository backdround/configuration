import os
import install.utils

"""install configs for desktop"""

def create_symlink_pairs_from_dir(prefix_scripts, prefix_symlinks):
    files = [file for file in os.listdir(prefix_scripts)
             if os.path.isfile(os.path.join(prefix_scripts, file))]

    pairs = [[os.path.join(prefix_scripts, file),
              os.path.join(prefix_symlinks, file)]
             for file in files]

    return pairs


def main(settings_object, project_root, force = False):
    symlink_pairs = []

    # i3 script pairs
    directory_with_scripts = os.path.join(project_root, "desktop/i3/scripts/")
    symlink_prefix = os.path.expanduser("~/Scripts/i3/")
    i3_pairs = create_symlink_pairs_from_dir(directory_with_scripts,symlink_prefix)
    symlink_pairs.extend(i3_pairs)

    # i3blocks script pairs
    directory_with_scripts = os.path.join(project_root, "desktop/i3blocks/scripts/")
    symlink_prefix = os.path.expanduser("~/Scripts/i3blocks/")
    i3blocks_pairs = create_symlink_pairs_from_dir(directory_with_scripts,symlink_prefix)
    symlink_pairs.extend(i3blocks_pairs)

    # systemd pairs
    systemd_directory = os.path.join(project_root, "desktop/systemd/")
    symlink_prefix = os.path.expanduser("~/.config/systemd/user")
    i3_pairs = create_symlink_pairs_from_dir(systemd_directory,symlink_prefix)
    symlink_pairs.extend(i3_pairs)

    # misc pairs without prefixes
    misc_pairs = [
        ["misc/compton.conf", ".config/compton.conf"],
        ["misc/dunstrc",      ".config/dunst/dunstrc"],
        ["misc/gis_weather",  ".config/gis-weather/gw_config1.json"],
        ["misc/ranger",       ".config/ranger/rc.conf"],
        ["misc/xinitrc",      ".xinitrc"],
        ["misc/xprofile",     ".xprofile"],
        ["misc/Xresources",   ".Xresources"],
        ["i3/config",         ".config/i3/config"],
        ["i3blocks/config",   ".config/i3blocks/config"],
    ]
    config_prefix = os.path.join(project_root, "desktop/")
    symlink_prefix = os.path.expanduser("~/")
    install.utils.make_absolute_path(misc_pairs, config_prefix, symlink_prefix)
    symlink_pairs.extend(misc_pairs)


    # process and exit
    return install.utils.create_list_of_symlink(symlink_pairs, force)

