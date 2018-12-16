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


class HomeSettings(__DefaultSettings__):
    """settings only for home pc"""


class NoteSettings(__DefaultSettings__):
    """settings only for laptop pc"""


class WorkSettings(__DefaultSettings__):
    """settings only for work pc"""

    def get_qutebrowser_settings(self):
        """quickmarks for"""
        return "work"
