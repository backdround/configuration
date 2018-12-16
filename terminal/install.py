import os
import utils.fs


def main(settings_object, force = False):
    # get pairs which will be preocess
    all_pairs = (
        ("bashrc",             "~/.bashrc"),
        ("inputrc",            "~/.inputrc"),
        ("tmux",               "~/.tmux.conf"),
        ("zshrc",              "~/.zshrc"),
        ("zaw-bookmarks",      "~/.zaw-bookmarks"),
        ("termite",            "~/.config/termite/config"),
        ("termite_for_ranger", "~/.config/termite/config_for_ranger"),
    )

    symlink_pairs = []
    settings = settings_object.get_terminal_settings()

    for pair in all_pairs:
        if not pair[0] in settings:
            raise Exception("Logic error")
        if settings[pair[0]]:
            symlink_pairs.append(pair)

    # create symlinks
    # dest is a user config
    # src is a local files
    config_prefix = os.path.dirname(os.path.abspath(__file__))

    ret_val = True
    for config, symlink in symlink_pairs:
        config_file = os.path.join(config_prefix, config)

        if utils.fs.create_symlink(config_file, symlink, force):
            print("{}: symlink was succesfully created".format(config))
        else:
            print("{}: symlink wasn't created".format(config))
            ret_val = False

    return ret_val
