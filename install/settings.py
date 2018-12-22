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

    def get_instance(self):
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

    def get_i3_settings(self):
        position_size = {
            "telegram":           ("525 700", "1375 10"),
            "ncmpcpp":            ("210 745", "1500 300"),
            "dropdown":           ("5 5",     "1910 534"),
            "ranger":             ("5 5",     "1910 490"),
            "rtorrent":           ("192 108", "1536 864"),
            "gis_weather":        ("10 10",   ""),
            "qutebrowser_editor": ("65 65",   "675 342"),
        }
        return position_size

    def get_i3blocks_settings(self):
        settings = {
            "list_of_blocks": (
                "volume",
                "memoryO",
                "cpu_usage",
                "language",
                "celandar",
                "time",
            ),
            "colors": {
                "background1": "#333333",
                "background2": "#1A1A1A",
                "label": "#BBFFDD",
            }
        }
        return settings


class HomeSettings(__DefaultSettings__):
    """settings only for home pc"""


class NoteSettings(__DefaultSettings__):
    """settings only for laptop pc"""

    def get_instance(self):
        return "note"


class WorkSettings(__DefaultSettings__):
    """settings only for work pc"""

    def get_instance(self):
        return "work"

    def get_misc_settings(self):
        settings = super(WorkSettings, self).get_misc_settings()

        settings["cava"]     = False
        settings["mcabbler"] = False
        settings["rtorrent"] = False

        return settings
