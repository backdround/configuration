import os
import shutil
import install.utils
import install.i3blocks

"""install configs for desktop"""

def create_symlink_pairs_from_dir(prefix_scripts, prefix_symlinks):
    # get list of files in directory
    files = [file for file in os.listdir(prefix_scripts)
             if os.path.isfile(os.path.join(prefix_scripts, file))]

    pairs = [(os.path.join(prefix_scripts, file),
              os.path.join(prefix_symlinks, file))
             for file in files]

    return pairs

def create_i3_config(settings_object, project_root):
    # create paths
    template_file = os.path.join(project_root, "desktop/i3/config_template")
    instance_file = os.path.join(project_root, "desktop/i3/config")
    symlink_file = os.path.expanduser("~/.config/i3/config")

    # create config instance
    if os.path.isfile(instance_file):
        os.remove(instance_file)
    shutil.copyfile(template_file, instance_file)

    # create replace list
    settings = settings_object.get_i3_settings()
    position_size = settings["position_size"]
    replaces =      [('--position-{}--'.format(key), val1) for key, (val1, _) in position_size.items()]
    replaces.extend([('--size-{}--'.format(key), val2) for key, (_, val2) in position_size.items()])
    replaces.extend([(key, val) for key, val in settings["replaces"].items()])

    # replace
    install.utils.replace_in_file(instance_file, replaces)

    # return symlink_pair
    return (instance_file, symlink_file)

def create_i3blocks_config(settings_object, project_root):
    # create paths
    template_file = os.path.join(project_root, "desktop/i3blocks/config_template")
    instance_file = os.path.join(project_root, "desktop/i3blocks/config")
    symlink_file = os.path.expanduser("~/.config/i3blocks/config")

    # create instance file
    i3_settings = settings_object.get_i3blocks_settings()
    config = install.i3blocks.i3blocks_config_generator(i3_settings, template_file)
    config.create_config_file(instance_file)

    return (instance_file, symlink_file)

def main(settings_object, project_root, force = False):

    symlink_pairs = []
    # create i3 config and add symlink_pairs
    symlink_pairs.append(create_i3_config(settings_object, project_root))
    # create i3blocks config and add symlink_pairs
    symlink_pairs.append(create_i3blocks_config(settings_object, project_root))

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
    systemd_pairs = create_symlink_pairs_from_dir(systemd_directory,symlink_prefix)
    symlink_pairs.extend(systemd_pairs)

    # xkb pairs
    xkb_directory = os.path.join(project_root, "desktop/xkb/")
    symlink_prefix = os.path.expanduser("~/.config/xkb")
    xkb_pairs = [
        ["keymap/config",   "keymap/config"],
        ["symbols/nums",    "symbols/nums"],
        ["symbols/special", "symbols/special"],
    ]
    install.utils.make_absolute_path(xkb_pairs, xkb_directory, symlink_prefix)
    symlink_pairs.extend(xkb_pairs)

    # misc pairs without prefixes
    misc_pairs = [
        ["misc/compton.conf", ".config/compton.conf"],
        ["misc/dunstrc",      ".config/dunst/dunstrc"],
        ["misc/gis_weather",  ".config/gis-weather/gw_config1.json"],
        ["misc/xinitrc",      ".xinitrc"],
        ["misc/xprofile",     ".xprofile"],
        ["misc/Xresources",   ".Xresources"],
        ["i3/config",         ".config/i3/config"],
        ["i3blocks/config",   ".config/i3blocks/config"],
    ]

    # ranger settings
    settings = settings_object.get_instance()
    if settings == "home" or settings == "note":
        misc_pairs.append(["misc/ranger_home", ".config/ranger/rc.conf"])
    elif settings == "work":
        misc_pairs.append(["misc/ranger_work", ".config/ranger/rc.conf"])

    config_prefix = os.path.join(project_root, "desktop/")
    symlink_prefix = os.path.expanduser("~/")
    install.utils.make_absolute_path(misc_pairs, config_prefix, symlink_prefix)
    symlink_pairs.extend(misc_pairs)


    # process and exit
    return install.utils.create_list_of_symlink(symlink_pairs, force)

