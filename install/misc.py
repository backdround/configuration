import os
import install.utils

"""install configs for misc"""

def main(settings_object, project_root, force = False):
    # all paris of [config, symlink] without prefixes
    misc_pairs = (
        ("cava",                     ".config/cava/config"),
        ("gdb",                      ".gdbinit"),
        ("gpg",                      ".gnupg/gpgconf.conf"),
        ("mouse_index.theme",        ".icons/default/index.theme"),
        ("rtorrent",                 ".rtorrent.rc"),
    )

    groups = {
        "git": (
            ("git/gitconfig",            ".gitconfig"),
            ("git/gitignore_global",     ".gitignore_global"),
        ),

        "gtk": (
            ("gtk/gtk.css",              ".config/gtk-3.0/gtk.css"),
            ("gtk/settings.ini",         ".config/gtk-3.0/settings.ini"),
            ("gtk/gtkrc-2.0",            ".gtkrc-2.0"),
        ),

        "mcabber": (
            ("mcabber/mcabber",          ".config/mcabber/mcabberrc"),
            ("mcabber/notify.mp3",       ".config/mcabber/notify.mp3"),
            ("mcabber/notify2.mp3",      ".config/mcabber/notify2.mp3"),
        ),

        "music": (
            ("music/mpd",                ".config/mpd/mpd.conf"),
            ("music/ncmpcpp",            ".ncmpcpp/config"),
            ("music/ncmpcpp_bindings",   ".ncmpcpp/bindings"),
        ),
    }

    settings = settings_object.get_misc_settings()

    # get symlink_pairs by treatment settings
    symlink_pairs = install.utils \
        .get_symlink_pairs_by_treatment_settigns(misc_pairs, settings)

    for group_name, pairs in groups.items():
        if not group_name in settings:
            raise Exception("settings has not value for {}".format(pair[0]))
        if settings[group_name]:
            for pair in pairs:
                symlink_pairs.append(list(pair))


    # relative prfix
    config_prefix = os.path.join(project_root, "misc")
    symlink_prefix = os.path.expanduser("~/")
    # make absolute paths
    install.utils.make_absolute_path(symlink_pairs, config_prefix, symlink_prefix)

    # process and exit
    return install.utils.create_list_of_symlink(symlink_pairs, force)

