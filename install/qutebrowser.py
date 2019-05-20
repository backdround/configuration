import os
import install.utils

"""install configs for qutebrowser"""


def main(settings_object, project_root, force = False):
    # paris of [config, symlink] without prefixes
    symlink_pairs = [
        ["config.py",           "config.py"],
        ["my_scripts/clear.js", "my_scripts/clear.js"],
        ["theme/draw.py",       "theme/draw.py"],
    ]

    # get appropriate quickmarks
    settings = settings_object.get_qutebrowser_settings()
    if settings == "home":
        symlink_pairs.append(["quickmarks_home", "quickmarks"])
    elif settings == "work":
        symlink_pairs.append(["quickmarks_work", "quickmarks"])

    # relative prfix
    config_prefix = os.path.join(project_root, "qutebrowser")
    symlink_prefix = os.path.expanduser("~/.config/qutebrowser/")
    # make absolute paths
    install.utils.make_absolute_path(symlink_pairs, config_prefix, symlink_prefix)

    # process and exit
    return install.utils.create_list_of_symlink(symlink_pairs, force)

