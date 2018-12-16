"""settings store"""
# default settings
class __DefaultSettings__:
    def get_terminal_settings(self):
        settings = {
            "bashrc":             True,
            "inputrc":            True,
            "tmux":               True,
            "zshrc":              True,
            "zaw-bookmarks":      True,
            "termite":            True,
            "termite_for_ranger": True,
        }
        return settings

    def get_qutebrowser_settings(self):
        """quickmarks for"""
        return "home"

    def get_misc_settings(self):
        settings = {
            "cava":              True,
            "gdb":               True,
            "git":               True,
            "gpg":               True,
            "gtk":               True,
            "mcabber":           True,
            "mouse_index.theme": True,
            "music":             True,
            "rtorrent":          True,
        }
        return settings


class HomeSettings(__DefaultSettings__):
    """settings only for home pc"""


class NoteSettings(__DefaultSettings__):
    """settings only for laptop pc"""


class WorkSettings(__DefaultSettings__):
    """settings only for work pc"""

    def get_qutebrowser_settings(self):
        """quickmarks for"""
        return "work"

    def get_misc_settings(self):
        settings = super(WorkSettings, self).get_misc_settings()

        settings["cava"]     = False
        settings["mcabbler"] = False
        settings["rtorrent"] = False

        return settings
