import os
import install.utils

"""install configs for nvim"""


def main(settings_object, project_root, force = False):
    # all paris of [config, symlink] without prefixes
    symlink_pairs = [
        ["init.vim",                    ".config/nvim/init.vim"],
        ["init_for_editing.vim",        ".config/nvim/init_for_editing.vim"],
        ["settings.json",               ".config/nvim/settings.json"],

        ["notes/plugin_hotkeys",        ".local/share/nvim/notes/plugin_hotkeys"],
        ["notes/qute_hotkeys",          ".local/share/nvim/notes/qute_hotkeys"],
        ["notes/vim_useful_hotkeys",    ".local/share/nvim/notes/vim_useful_hotkeys"],

        ["UltiSnips/all.snippets",      ".local/share/nvim/UltiSnips/all.snippets"],
        ["UltiSnips/cpp.snippets",      ".local/share/nvim/UltiSnips/cpp.snippets"],
        ["UltiSnips/snippets.snippets", ".local/share/nvim/UltiSnips/snippets.snippets"],
    ]

    # relative prfix
    config_prefix = os.path.join(project_root, "nvim")
    symlink_prefix = os.path.expanduser("~/")
    # make absolute paths
    install.utils.make_absolute_path(symlink_pairs, config_prefix, symlink_prefix)

    # process and exit
    return install.utils.create_list_of_symlink(symlink_pairs, force)

