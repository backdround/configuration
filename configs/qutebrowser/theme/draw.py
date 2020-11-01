import os


def get_color(string):
    process = os.popen("xrdb -query | grep \"{}:\" | cut -f 2| tr -d '\n'".format(string))
    color = process.read()
    process.close()
    return color

def set_colors(c):
    palette = {}
    palette['rock-dark']   = get_color("background")
    palette['rock-light']  = get_color("color0")
    palette['gray']        = get_color("color8")
    palette['cloud-dark']  = get_color("foreground")
    palette['cloud-light'] = get_color("color15")

    palette['cyan']        = get_color("color6")
    palette['green']       = get_color("color2")
    palette['red']         = get_color("color1")
    palette['purple']      = get_color("color5")
    palette['yellow']      = get_color("color3")

    colors = {
        # tabs
        'tabs-bg':          palette['rock-dark'],
        'tabs-fg':          palette['cloud-dark'],
        'tabs-selected-bg': "#474B4D",
        'tabs-selected-fg': palette['cyan'],

        # url
        'url-fg':      palette['cloud-light'],
        'url-warn':    palette['yellow'],
        'url-error':   palette['red'],
        'url-hover':   palette['purple'],
        'url-success': palette['green'],

        # status
        'sts-caret-fg':           palette['rock-dark'],
        'sts-caret-bg':           palette['purple'],
        'sts-caret-selection-fg': palette['rock-dark'],
        'sts-caret-selection-bg': palette['red'],

        'sts-command-bg':         palette['rock-dark'],
        'sts-command-fg':         palette['purple'],
        'sts-command-private-bg': palette['rock-light'],
        'sts-command-private-fg': palette['purple'],

        'sts-passthrough-bg':     palette['cyan'],
        'sts-passthrough-fg':     palette['rock-dark'],

        'sts-insert-bg':          palette['green'],
        'sts-insert-fg':          palette['rock-dark'],

        'sts-private-bg':         palette['gray'],
        'sts-private-fg':         palette['green'],

        'sts-progress-bg':        palette['rock-dark'],

        # prompts
        'prompt-bg':       palette['rock-light'],
        'prompt-fg':       palette['purple'],
        'prompt-border':   palette['red'],
        'prompt-selected': palette['gray'],

        # messages
        'msg-bg':          palette['rock-dark'],
        'msg-info':        palette['green'],
        'msg-warning':     palette['yellow'],
        'msg-error':       palette['red'],

        # keyhints
        'kh-bg':           palette['rock-light'],
        'kh-fg':           palette['cloud-light'],
        'kh-suffix':       palette['cyan'],

        # hints
        'hints-bg':        palette['green'],
        'hints-fg':        palette['rock-dark'],
        'hints-match':     palette['cloud-dark'],
        'hints-border':    palette['cloud-light'],

        # download bar
        'db-bg':           palette['rock-dark'],
        'db-file-fg':      palette['rock-dark'],
        'db-file-error':   palette['red'],
        'db-file-start':   palette['cyan'],
        'db-file-stop':    palette['green'],

        # completion widget
        'cw':              palette['cloud-dark'],
        'cw-comment':      palette['cyan'],
        'cw-bind':         palette['green'],
        'cw-header':       palette['green'],
        'cw-header-bg':    palette['rock-light'],
        'cw-selection':    palette['rock-dark'],
        'cw-selection-bg': palette['green'],
        'cw-match':        palette['red'],
        'cw-scrollbar':    palette['green'],
        'cw-scrollbar-bg': palette['rock-dark'],
    }

    ## Completion widget
    # header
    c.colors.completion.category.bg            = colors['cw-header-bg']
    c.colors.completion.category.fg            = colors['cw-header']
    c.colors.completion.category.border.bottom = colors['cw-header']
    c.colors.completion.category.border.top    = colors['cw-header']

    # rows
    c.colors.completion.even.bg = palette['rock-dark']
    c.colors.completion.odd.bg  = palette['rock-light']
    c.colors.completion.fg      = [colors['cw'], colors['cw-comment'], colors['cw-bind']]

    # selected item
    c.colors.completion.item.selected.bg            = colors['cw-selection-bg']
    c.colors.completion.item.selected.fg            = colors['cw-selection']
    c.colors.completion.item.selected.border.bottom = colors['cw-selection']
    c.colors.completion.item.selected.border.top    = colors['cw-selection']

    # other
    c.colors.completion.match.fg     = colors['cw-match']
    c.colors.completion.scrollbar.bg = colors['cw-scrollbar-bg']
    c.colors.completion.scrollbar.fg = colors['cw-scrollbar']

    ## Download bar
    c.colors.downloads.bar.bg   = colors['db-bg']
    c.colors.downloads.error.bg = colors['db-file-error']
    c.colors.downloads.error.fg = colors['db-file-fg']
    c.colors.downloads.start.bg = colors['db-file-start']
    c.colors.downloads.start.fg = colors['db-file-fg']
    c.colors.downloads.stop.bg  = colors['db-file-stop']
    c.colors.downloads.stop.fg  = colors['db-file-fg']

    ## Keyhints
    c.colors.keyhint.bg        = colors['kh-bg']
    c.colors.keyhint.fg        = colors['kh-fg']
    c.colors.keyhint.suffix.fg = colors['kh-suffix']
    c.keyhint.radius           = 0

    ## Hints
    c.colors.hints.bg       = colors['hints-bg']
    c.colors.hints.fg       = colors['hints-fg']
    c.colors.hints.match.fg = colors['hints-match']
    c.hints.border          = '1px solid ' + colors['hints-border']
    c.hints.radius          = 0

    ## Messages
    c.colors.messages.error.bg       = colors['msg-bg']
    c.colors.messages.error.border   = colors['msg-error']
    c.colors.messages.error.fg       = colors['msg-error']
    c.colors.messages.info.bg        = colors['msg-bg']
    c.colors.messages.info.border    = colors['msg-info']
    c.colors.messages.info.fg        = colors['msg-info']
    c.colors.messages.warning.bg     = colors['msg-bg']
    c.colors.messages.warning.border = colors['msg-warning']
    c.colors.messages.warning.fg     = colors['msg-warning']

    ## Prompts
    c.colors.prompts.bg = colors['prompt-bg']
    c.colors.prompts.fg = colors['prompt-fg']
    c.colors.prompts.border = '1px solid ' + colors['prompt-border']
    c.colors.prompts.selected.bg = colors['prompt-selected']

    ## Statusbar
    # caret
    c.colors.statusbar.caret.bg           = colors['sts-caret-bg']
    c.colors.statusbar.caret.fg           = colors['sts-caret-fg']
    c.colors.statusbar.caret.selection.bg = colors['sts-caret-selection-bg']
    c.colors.statusbar.caret.selection.fg = colors['sts-caret-selection-fg']

    # command
    c.colors.statusbar.command.bg         = colors['sts-command-bg']
    c.colors.statusbar.command.fg         = colors['sts-command-fg']
    c.colors.statusbar.command.private.bg = colors['sts-command-private-bg']
    c.colors.statusbar.command.private.fg = colors['sts-command-private-fg']

    # insert
    c.colors.statusbar.insert.bg = colors['sts-insert-bg']
    c.colors.statusbar.insert.fg = colors['sts-insert-fg']

    # normal
    c.colors.statusbar.normal.bg = palette['rock-dark']
    c.colors.statusbar.normal.fg = palette['cloud-dark']

    # passthrough
    c.colors.statusbar.passthrough.bg = colors['sts-passthrough-bg']
    c.colors.statusbar.passthrough.fg = colors['sts-passthrough-fg']

    # private
    c.colors.statusbar.private.bg = colors['sts-private-bg']
    c.colors.statusbar.private.fg = colors['sts-private-fg']

    # progress
    c.colors.statusbar.progress.bg = colors['sts-progress-bg']

    ## Url
    c.colors.statusbar.url.fg               = colors['url-fg']
    c.colors.statusbar.url.error.fg         = colors['url-error']
    c.colors.statusbar.url.hover.fg         = colors['url-hover']
    c.colors.statusbar.url.success.http.fg  = colors['url-success']
    c.colors.statusbar.url.success.https.fg = colors['url-success']
    c.colors.statusbar.url.warn.fg          = colors['url-warn']

    ## Tab bar
    # unselected tabs
    c.colors.tabs.bar.bg           = colors['tabs-bg']
    c.colors.tabs.even.bg          = colors['tabs-bg']
    c.colors.tabs.even.fg          = colors['tabs-fg']
    c.colors.tabs.odd.bg           = colors['tabs-bg']
    c.colors.tabs.odd.fg           = colors['tabs-fg']

    # selected
    c.colors.tabs.selected.even.bg = colors['tabs-selected-bg']
    c.colors.tabs.selected.even.fg = colors['tabs-selected-fg']
    c.colors.tabs.selected.odd.bg  = colors['tabs-selected-bg']
    c.colors.tabs.selected.odd.fg  = colors['tabs-selected-fg']

    # indicator
    c.colors.tabs.indicator.error  = palette['red']
    c.colors.tabs.indicator.start  = palette['cyan']
    c.colors.tabs.indicator.stop   = palette['green']

    c.colors.webpage.bg = "#FFFFFF"


def set_style(c):

    padding = {
        'left': 8,
        'right': 8,
        'bottom': 4,
        'top': 4,
    }

    c.statusbar.padding = padding

    ## Tab padding
    c.tabs.padding = padding
    c.tabs.indicator.width = 3
    c.tabs.favicons.scale = 1

    # Fonts
    font_size_str                    = '12pt'
    font_size_small_str              = '10pt'

    c.fonts.default_family           = '"FantasqueSansMono", Menlo, "xos4 Terminus", Terminus, Monospace, Monaco, "Vera Sans Mono", "Andale Mono", "Courier New", Courier, "Liberation Mono", monospace, Consolas, Terminal'
    c.fonts.completion.entry         = font_size_small_str
    c.fonts.completion.category      = 'bold'
    c.fonts.debug_console            = font_size_str
    c.fonts.downloads                = 'bold ' + font_size_str
    c.fonts.hints                    = 'bold ' + font_size_small_str
    c.fonts.keyhint                  = font_size_str
    c.fonts.messages.error           = font_size_str
    c.fonts.messages.info            = font_size_str
    c.fonts.messages.warning         = font_size_str
    c.fonts.prompts                  = font_size_str
    c.fonts.statusbar                = font_size_small_str
    c.fonts.tabs.selected            = 'bold '
    c.fonts.tabs.unselected          = font_size_str
    c.fonts.web.family.standard      = ''
    c.fonts.web.family.fixed         = ''
    c.fonts.web.family.serif         = ''
    c.fonts.web.family.sans_serif    = ''
    c.fonts.web.family.cursive       = ''
    c.fonts.web.family.fantasy       = ''
    c.fonts.web.size.default         = 16
    c.fonts.web.size.default_fixed   = 13
    c.fonts.web.size.minimum         = 0
    c.fonts.web.size.minimum_logical = 6

