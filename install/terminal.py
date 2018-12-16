import os
import install.utils

"""install configs for terminal"""


def main(settings_object, project_root, force = False):
    # all paris of [config, symlink] without prefixes
    all_pairs = (
        ("bashrc",             ".bashrc"),
        ("inputrc",            ".inputrc"),
        ("tmux",               ".tmux.conf"),
        ("zshrc",              ".zshrc"),
        ("zaw-bookmarks",      ".zaw-bookmarks"),
        ("termite",            ".config/termite/config"),
        ("termite_for_ranger", ".config/termite/config_for_ranger"),
    )

    settings = settings_object.get_terminal_settings()

    # get symlink_pairs by treatment settings
    symlink_pairs = []
    for pair in all_pairs:
        if not pair[0] in settings:
            raise Exception("settings has not value for {}".format(pair[0]))
        if settings[pair[0]]:
            symlink_pairs.append(list(pair))

    # relative prfix
    config_prefix = os.path.join(project_root, "terminal")
    symlink_prefix = os.path.expanduser("~/")
    # make absolute paths
    install.utils.make_absolute_path(symlink_pairs, config_prefix, symlink_prefix)

    # process and exit
    return install.utils.create_list_of_symlink(symlink_pairs, force)

