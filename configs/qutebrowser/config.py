import os
import theme.draw

theme.draw.set_colors(c)
theme.draw.set_style(c, {
    'spacing': {
        'vertical': 3,
        'horizontal': 8
    },
    'font': {
        'family': '"xos4 Terminus", Monospace',
        'size': 12
    }
})

c.aliases = {'w': 'session-save', 'q': 'quit', 'wq': 'quit --save', 'x': 'quit --save'}
c.auto_save.interval = 15000
c.auto_save.session = False

c.bindings.key_mappings = {
    'Й': 'Q', 'й': 'q',
    'Ц': 'W', 'ц': 'w',
    'У': 'E', 'у': 'e',
    'К': 'R', 'к': 'r',
    'Е': 'T', 'е': 't',
    'Н': 'Y', 'н': 'y',
    'Г': 'U', 'г': 'u',
    'Ш': 'I', 'ш': 'i',
    'Щ': 'O', 'щ': 'o',
    'З': 'P', 'з': 'p',
    'Х': '{', 'х': '[',
    'Ъ': '}', 'ъ': ']',
    'Ф': 'A', 'ф': 'a',
    'Ы': 'S', 'ы': 's',
    'В': 'D', 'в': 'd',
    'А': 'F', 'а': 'f',
    'П': 'G', 'п': 'g',
    'Р': 'H', 'р': 'h',
    'О': 'J', 'о': 'j',
    'Л': 'K', 'л': 'k',
    'Д': 'L', 'д': 'l',
    'Ж': ':', 'ж': ';',
    'Э': '"', 'э': '\'',
    'Я': 'Z', 'я': 'z',
    'Ч': 'X', 'ч': 'x',
    'С': 'C', 'с': 'c',
    'М': 'V', 'м': 'v',
    'И': 'B', 'и': 'b',
    'Т': 'N', 'т': 'n',
    'Ь': 'M', 'ь': 'm',
    'Б': '<', 'б': ',',
    'Ю': '>', 'ю': '.',
    ',': '?', '.': '/',

    '<Alt-й>': '<Alt-q>',
    '<Alt-ц>': '<Alt-w>',
    '<Alt-у>': '<Alt-e>',
    '<Alt-к>': '<Alt-r>',
    '<Alt-е>': '<Alt-t>',
    '<Alt-н>': '<Alt-y>',
    '<Alt-г>': '<Alt-u>',
    '<Alt-ш>': '<Alt-i>',
    '<Alt-щ>': '<Alt-o>',
    '<Alt-з>': '<Alt-p>',
    '<Alt-х>': '<Alt-[>',
    '<Alt-ъ>': '<Alt-]>',
    '<Alt-ф>': '<Alt-a>',
    '<Alt-ы>': '<Alt-s>',
    '<Alt-в>': '<Alt-d>',
    '<Alt-а>': '<Alt-f>',
    '<Alt-п>': '<Alt-g>',
    '<Alt-р>': '<Alt-h>',
    '<Alt-о>': '<Alt-j>',
    '<Alt-л>': '<Alt-k>',
    '<Alt-д>': '<Alt-l>',
    '<Alt-ж>': '<Alt-;>',
    '<Alt-э>': '<Alt-\'>',
    '<Alt-я>': '<Alt-z>',
    '<Alt-ч>': '<Alt-x>',
    '<Alt-с>': '<Alt-c>',
    '<Alt-м>': '<Alt-v>',
    '<Alt-и>': '<Alt-b>',
    '<Alt-т>': '<Alt-n>',
    '<Alt-ь>': '<Alt-m>',
    '<Alt-б>': '<Alt-,>',
    '<Alt-ю>': '<Alt-.>',
    '<Alt-.>': '<Alt-/>'
}

c.completion.cmd_history_max_items = 400
c.completion.delay = 10
c.completion.height = '65%'
c.completion.scrollbar.padding = 3
c.completion.scrollbar.width = 14
c.completion.web_history.exclude = []

c.content.autoplay = True

# c.content.canvas_reading = True
c.content.canvas_reading = False
# c.content.geolocation = 'ask'
c.content.geolocation = False
# c.content.headers.referer = 'same-domain'
c.content.headers.referer = 'never'

# c.content.javascript.can_access_clipboard = False
# c.content.javascript.can_close_tabs = False
# c.content.javascript.can_open_tabs_automatically = False
# c.content.javascript.modal_dialog = False
# c.content.media_capture = 'ask'
# c.content.mouse_lock = 'ask'
c.content.notifications = False
c.content.pdfjs = True
# c.content.persistent_storage = 'ask'
c.content.plugins = True
# c.content.private_browsing = False
# c.content.register_protocol_handler = 'ask'
# c.content.ssl_strict = 'ask'

c.downloads.location.directory = '~/downloads'
c.downloads.location.prompt = False
c.downloads.location.suggestion = 'filename'
editor_script = os.path.expanduser('~/.local/bin/qute_editor.sh')
c.editor.command = [editor_script, '{} -c \'normal {line}G{column0}l\'']

both_hands_chars = 'asdghklqwertyuiopzxcvbnmfj;'
left_hand_chars = 'asdgqwertzxcv'
c.hints.chars = '{}'.format(both_hands_chars)
c.hints.dictionary = '/usr/share/dict/words'

c.hints.next_regexes = ['\\bnext\\b',
                        '\\bmore\\b',
                        '\\bnewer\\b',
                        '\\b[>→≫]\\b',
                        '\\b(>>|»)\\b',
                        '\\bcontinue\\b',
                        '\\bпродолжить\\b',
                        '\\bслед(ующая)\\b',
                        '\\bдальше\\b']

c.hints.prev_regexes = ['\\bprev(ious)?\\b',
                        '\\bback\\b',
                        '\\bolder\\b',
                        '\\b[<←≪]\\b',
                        '\\b(<<|«)\\b',
                        '\\bвернуться\\b',
                        '\\bпред(ыдущая)\\b',
                        '\\bназад\\b']

instance = ""
instance_file_path = os.path.expanduser("~/.instance")
with open(instance_file_path, 'r') as file:
    intsance = file.read()

if instance == "home":
    c.zoom.default = 125


c.hints.uppercase = True
c.input.partial_timeout = 10000
c.keyhint.delay = 200
c.messages.timeout = 5000
c.scrolling.smooth = True
c.session.default_name = 'default'
c.session.lazy_restore = True

c.spellcheck.languages = ['en-US', 'ru-RU']
c.tabs.last_close = 'close'

c.url.default_page = 'https://google.com/'
c.url.start_pages = ['https://google.com']

c.url.searchengines['DEFAULT'] = 'http://www.google.com/search?hl=en&q={}'
c.url.searchengines['a'] = 'https://wiki.archlinux.org/?search={}'
c.url.searchengines['d'] = 'https://duckduckgo.com/?q={}'
c.url.searchengines['y'] = 'https://www.youtube.com/results?search_query={}'


c.bindings.default['normal'] = {}
c.bindings.default['caret'] = {}
c.bindings.default['command'] = {}
c.bindings.default['hint'] = {}
c.bindings.default['insert'] = {}
c.bindings.default['passthrough'] = {}
#  *****************************************************************************
## normal mode

# download
config.bind('Dp', 'download --mhtml')
config.bind('Ds', 'download-cancel')
config.bind('Dc', 'download-clear')
config.bind('Dd', 'download-delete')
config.bind('Do', 'download-open')
config.bind('Dr', 'download-retry')

# yanks
config.bind('yd', 'yank domain')
config.bind('yD', 'yank domain -s')
config.bind('yp', 'yank pretty-url')
config.bind('yP', 'yank pretty-url -s')
config.bind('yt', 'yank title')
config.bind('yT', 'yank title -s')
config.bind('yy', 'yank selection')
config.bind('yY', 'yank seleciion -s')
config.bind('yl', 'hint links yank')
config.bind('yL', 'hint links yank-primary')

# hints
config.bind(';h', 'hint all hover')
config.bind(';i', 'hint inputs --first')
config.bind(';I', 'hint inputs')
config.bind(';m', 'hint images')
config.bind(';M', 'hint images tab')
config.bind(';b', 'hint all tab-bg')
config.bind(';r', 'hint --rapid links tab-bg')
config.bind(';w', 'hint all window')
config.bind(';d', 'hint links download')
config.bind('f',  'hint')
config.bind('F',  'hint all tab')

# tabs
for i in range(1, 10):
    config.bind('<Alt-{}>'.format(i), 'tab-focus {}'.format(i))
config.bind('<Alt-0>', 'tab-focus -1')

config.bind('H', 'back')
config.bind('L', 'forward')
config.bind('J', 'tab-prev')
config.bind('K', 'tab-next')

config.bind('<', 'tab-move -')
config.bind('>', 'tab-move +')

# tab managment
config.bind('To', 'tab-only')
config.bind('Tc', 'tab-clone --bg')
config.bind('TC', 'tab-clone --window')
config.bind('Tg', 'tab-give')
config.bind('TG', 'set-cmd-text -s :tab-give')
config.bind('Tt', 'set-cmd-text -s :tab-take')
config.bind('TT', 'set-cmd-text -s :tab-take --keep')

# choose tab(go to)
config.bind('gt', 'tab-focus')
config.bind('gT', 'tab-prev')
config.bind('go', 'set-cmd-text -s :buffer ')
config.bind('g4', 'tab-focus -1')

# open in background/new/current tab or new window
commands_with_prefix = [
    # navigate related current page
    ('i', 'navigate increment {}'),
    ('d', 'navigate decrement {}'),
    ('p', 'navigate prev {}'),
    ('n', 'navigate next {}'),
    ('u', 'navigate up {}'),
    ('h', 'back {}'),
    ('l', 'forward {}'),

    #quickmarks/bockmarks
    ('b', 'set-cmd-text -s :bookmark-load {}'),
    ('B', 'open {} qute://bookmarks#bookmarks'),
    ('q', 'set-cmd-text -s :quickmark-load {}'),
    ('Q', 'open {} qute://bookmarks'),

    #other
    ('y', 'open {} {{clipboard}}'),
    ('Y', 'open {} {{primary}}'),
    ('e', 'edit-url {}'),
    ('o', 'open {}'),
    ('m', 'messages {}'),
    ('H', 'open {} qute://history')
]
ways_to_open = [
    ('c', ''),
    ('t', '--tab'),
    ('b', '--bg'),
    ('W', '--window')
]
for way in ways_to_open:
    for command in commands_with_prefix:
        keychain = way[0] + command[0]
        cmd = command[1].format(way[1])
        config.bind(keychain, cmd)

config.bind(ways_to_open[0][0] + 'f', 'hint all current')
config.bind(ways_to_open[1][0] + 'f', 'hint all tab-fg')
config.bind(ways_to_open[2][0] + 'f', 'hint all tab-bg')
config.bind(ways_to_open[3][0] + 'f', 'hint all window')

# navigate on page
config.bind('h', 'scroll-page -0.06 0')
config.bind('l', 'scroll-page 0.06 0')
config.bind('j', 'scroll-page 0 0.12')
config.bind('k', 'scroll-page 0 -0.12')

config.bind('<Ctrl-h>', 'scroll left')
config.bind('<Ctrl-l>', 'scroll right')
config.bind('<Ctrl-j>', 'run-with-count 3 scroll down')
config.bind('<Ctrl-k>', 'run-with-count 3 scroll up')

config.bind('s', 'scroll-page 0 0.12')
config.bind('w', 'scroll-page 0 -0.12')

config.bind('<Ctrl-B>', 'scroll-page 0 -1')
config.bind('<Ctrl-F>', 'scroll-page 0 1')

config.bind('u', 'scroll-page 0 -0.5')
config.bind('d', 'scroll-page 0 0.5')
config.bind('<Ctrl-n>', 'run-with-count 9 scroll down')
config.bind('<Ctrl-p>', 'run-with-count 9 scroll up')

config.bind('G', 'scroll-to-perc')
config.bind('gg', 'scroll-to-perc 0')

# into other modes
config.bind('I', 'enter-mode insert')
config.bind('i', 'enter-mode passthrough')
config.bind('<Ctrl-i>', 'enter-mode passthrough')
config.bind('v', 'enter-mode caret')

# like vim <Ctrl-o>
from string import ascii_letters, digits
for i in ascii_letters + digits:
    config.bind('<Ctrl-o>{}'.format(i), 'fake-key ' + i)
config.bind('<Alt-Return>', 'fake-key <Return>')
config.bind('<Alt-Backspace>', 'fake-key <Backspace>')
config.bind('<Alt-Escape>', 'fake-key <Escape>')

# main
clear_script = "jseval -q -f ~/.config/qutebrowser/my_scripts/clear.js"
config.bind('<Escape>',       'clear-keychain ;; search ;; fullscreen --leave ;; ' + clear_script)
config.bind("'",              'enter-mode jump_mark')
config.bind('m',              'enter-mode set_mark')
config.bind('+',              'zoom-in')
config.bind('-',              'zoom-out')
config.bind('=',              'zoom')
config.bind('.',              'set-cmd-text /')
config.bind(',',              'set-cmd-text ?')
config.bind('/',              'set-cmd-text /')
config.bind('?',              'set-cmd-text ?')
config.bind(':',              'set-cmd-text :')
config.bind('<Ctrl-Return>',  'follow-selected -t')
config.bind('<Return>',       'follow-selected')
config.bind('r',              'reload')
config.bind('R',              'reload -f')
config.bind('x',              'tab-close')
config.bind('X',              'undo')
config.bind('q',              'set-cmd-text -s :quickmark-load --tab'),
config.bind('Q',              'set-cmd-text -s :bookmark-load --tab'),
config.bind('<Ctrl-/>',       'search {primary}')
config.bind('<Ctrl-Shift-?>', 'search --reverse {primary}')
config.bind('n',              'search-next')
config.bind('N',              'search-prev')
config.bind('p',              'tab-pin')
config.bind('o',              'set-cmd-text -s :open')
config.bind('O',              'set-cmd-text -s :open -t')
config.bind('<Ctrl-Shift-n>', 'set-cmd-text -s :open -p')
config.bind('<Ctrl-s>',       'stop')
config.bind('<Ctrl-c>',       'yank selection')
config.bind('<Alt-r>',        'config-cycle --temp hints.chars {} {}'.format(both_hands_chars, left_hand_chars))

# Session
config.bind('Ss', 'set-cmd-text -s :session-save --only-active-window')
config.bind('Sl', 'set-cmd-text -s :session-load')
config.bind('Sn', 'set-cmd-text -s :session-load --clear')
config.bind('Sd', 'set-cmd-text -s :session-delete')

# other
config.bind('zb', 'set-cmd-text -s :bookmark-add {url}')
config.bind('zd', 'set-cmd-text -s :bookmark-del')
config.bind('zq', 'set-cmd-text -s :quickmark-add {url}')
config.bind('zD', 'set-cmd-text -s :quickmark-del')
config.bind('zm', 'tab-mute')
config.bind('zc', 'clear-messages')
config.bind('zr', 'config-source')
config.bind('ze', 'config-edit')
config.bind('zs', 'view-source')
config.bind('ZQ', 'quit')

config.bind('<Alt-j>', 'jseval -q document.querySelectorAll(\'video\') [0].currentTime -= 7;')
config.bind('<Alt-l>', 'jseval -q document.querySelectorAll(\'video\') [0].currentTime += 7;')
config.bind('<Alt-k>', 'jseval -q var video = document.querySelectorAll(\'video\') [0]; if (video.paused) { video.play();} else {video.pause();}')
config.bind('<Alt-i>', 'jseval -q document.querySelectorAll(\'video\') [0].playbackRate = 1;')
config.bind('<Alt-u>', 'jseval -q document.querySelectorAll(\'video\') [0].playbackRate -= 0.1;')
config.bind('<Alt-o>', 'jseval -q document.querySelectorAll(\'video\') [0].playbackRate += 0.1;')
config.bind('<Alt-a>', 'jseval -q document.querySelectorAll(\'video\') [0].playbackRate = 10;')
config.bind('<Alt-s>', 'jseval -q document.querySelectorAll(\'video\') [0].currentTime = 0;')
config.bind('<Alt-p>', 'jseval -q var video = document.querySelectorAll(\'video\') [0]; if (video.loop) { video.loop = 0;} else {video.loop = 1;}')


#  *****************************************************************************
## caret mode
config.bind('4',            'move-to-end-of-line',                 mode='caret')
config.bind('0',            'move-to-start-of-line',               mode='caret')
config.bind('<Ctrl-Space>', 'drop-selection',                      mode='caret')
config.bind('<Escape>',     'leave-mode',                          mode='caret')
config.bind('<Return>',     'yank selection',                      mode='caret')
config.bind('<Space>',      'toggle-selection',                    mode='caret')
config.bind('G',            'move-to-end-of-document',             mode='caret')
config.bind('H',            'scroll left',                         mode='caret')
config.bind('J',            'scroll down',                         mode='caret')
config.bind('K',            'scroll up',                           mode='caret')
config.bind('L',            'scroll right',                        mode='caret')
config.bind('Y',            'yank selection -s',                   mode='caret')
config.bind('[',            'move-to-start-of-prev-block',         mode='caret')
config.bind(']',            'move-to-start-of-next-block',         mode='caret')
config.bind('b',            'move-to-prev-word',                   mode='caret')
config.bind('c',            'enter-mode normal',                   mode='caret')
config.bind('e',            'move-to-end-of-word',                 mode='caret')
config.bind('gg',           'move-to-start-of-document',           mode='caret')
config.bind('h',            'move-to-prev-char',                   mode='caret')
config.bind('j',            'move-to-next-line',                   mode='caret')
config.bind('k',            'move-to-prev-line',                   mode='caret')
config.bind('l',            'move-to-next-char',                   mode='caret')
config.bind('v',            'toggle-selection',                    mode='caret')
config.bind('w',            'move-to-next-word',                   mode='caret')
config.bind('y',            'yank selection ;; yank selection -s', mode='caret')
config.bind('{',            'move-to-end-of-prev-block',           mode='caret')
config.bind('}',            'move-to-end-of-next-block',           mode='caret')

#  *****************************************************************************
## Bindings for command mode

config.bind('<Alt-F>',  'rl-forward-word',                             mode='command')
config.bind('<Alt-B>',  'rl-backward-word',                            mode='command')
config.bind('<Ctrl-A>', 'rl-beginning-of-line',                        mode='command')
config.bind('<Ctrl-4>', 'rl-end-of-line',                              mode='command')
config.bind('<Ctrl-F>', 'rl-forward-char',                             mode='command')
config.bind('<Ctrl-B>', 'rl-backward-char',                            mode='command')

config.bind('<Alt-D>',          'rl-kill-word',                        mode='command')
config.bind('<Alt-Backspace>',  'rl-backward-kill-word',               mode='command')
config.bind('<Ctrl-?>',         'rl-delete-char',                      mode='command')
config.bind('<Ctrl-H>',         'rl-backward-delete-char',             mode='command')
config.bind('<Ctrl-U>',         'rl-unix-line-discard',                mode='command')
config.bind('<Ctrl-W>',         'rl-unix-word-rubout',                 mode='command')

config.bind('<Shift-Delete>',   'completion-item-del',                 mode='command')
config.bind('<Ctrl-C>',         'completion-item-yank',                mode='command')
config.bind('<Ctrl-D>',         'completion-item-del',                 mode='command')
config.bind('<Ctrl-Shift-C>',   'completion-item-yank --sel',          mode='command')
config.bind('<Ctrl-Alt-N>',     'completion-item-focus next-category', mode='command')
config.bind('<Ctrl-Alt-P>',     'completion-item-focus prev-category', mode='command')
config.bind('<Ctrl-N>',         'completion-item-focus next',          mode='command')
config.bind('<Ctrl-P>',         'completion-item-focus prev',          mode='command')

config.bind('<Ctrl-J>', 'command-history-next',                        mode='command')
config.bind('<Ctrl-K>', 'command-history-prev',                        mode='command')
config.bind('<Ctrl-E>', 'edit-command',                                mode='command')
config.bind('<Ctrl-Y>', 'rl-yank',                                     mode='command')

config.bind('<Up>',          'completion-item-focus --history prev',   mode='command')
config.bind('<Down>',        'completion-item-focus --history next',   mode='command')
config.bind('<Escape>',      'leave-mode',                             mode='command')
config.bind('<Ctrl-Return>', 'command-accept --rapid',                 mode='command')
config.bind('<Return>',      'command-accept',                         mode='command')
config.bind('<Shift-Tab>',   'completion-item-focus prev',             mode='command')
config.bind('<Tab>',         'completion-item-focus next',             mode='command')
config.bind('<Ctrl-Shift-Tab>', 'completion-item-focus prev-category', mode='command')
config.bind('<Ctrl-Tab>',       'completion-item-focus next-category', mode='command')

#  *****************************************************************************
## Bindings for hint mode
config.bind('<Escape>', 'leave-mode', mode='hint')
config.bind('<Return>', 'follow-hint', mode='hint')

#  *****************************************************************************
## Bindings for insert mode
config.bind('<Ctrl-j>', 'scroll down', mode='insert')
config.bind('<Ctrl-k>', 'scroll up', mode='insert')
config.bind('<Ctrl-h>', 'scroll left', mode='insert')
config.bind('<Ctrl-l>', 'scroll right', mode='insert')
config.bind('<Ctrl-n>', 'jseval -q -f /usr/share/qutebrowser/scripts/cycle-inputs.js', mode='insert')
config.bind('<Ctrl-e>', 'open-editor', mode='insert')
config.bind('<Escape>', 'leave-mode', mode='insert')
config.bind('<Ctrl-t>', 'enter-mode passthrough', mode='insert')

for i in range(1, 10):
    config.bind('<Alt-{}>'.format(i), 'tab-focus {}'.format(i), mode='insert')
config.bind('<Alt-0>', 'tab-focus -1', mode='insert')

#  *****************************************************************************
## Bindings for passthrough mode
config.bind('<Ctrl-j>', 'scroll down', mode='passthrough')
config.bind('<Ctrl-k>', 'scroll up', mode='passthrough')
config.bind('<Ctrl-h>', 'scroll left', mode='passthrough')
config.bind('<Ctrl-l>', 'scroll right', mode='passthrough')
config.bind('<Ctrl-n>', 'jseval -q -f /usr/share/qutebrowser/scripts/cycle-inputs.js', mode='passthrough')
config.bind('<Alt-Escape>', 'fake-key <Escape>', mode='passthrough')
config.bind('<Escape>', 'leave-mode', mode='passthrough')
config.bind('<Ctrl-e>', 'open-editor', mode='passthrough')
config.bind('<Ctrl-t>', 'enter-mode insert', mode='passthrough')

for i in range(1, 10):
    config.bind('<Alt-{}>'.format(i), 'tab-focus {}'.format(i), mode='passthrough')
config.bind('<Alt-0>', 'tab-focus -1', mode='passthrough')

## Bindings for prompt mode
# config.bind('<Alt-B>', 'rl-backward-word', mode='prompt')
# config.bind('<Alt-Backspace>', 'rl-backward-kill-word', mode='prompt')
# config.bind('<Alt-D>', 'rl-kill-word', mode='prompt')
# config.bind('<Alt-F>', 'rl-forward-word', mode='prompt')
# config.bind('<Alt-Shift-Y>', 'prompt-yank --sel', mode='prompt')
# config.bind('<Alt-Y>', 'prompt-yank', mode='prompt')
# config.bind('<Ctrl-?>', 'rl-delete-char', mode='prompt')
# config.bind('<Ctrl-A>', 'rl-beginning-of-line', mode='prompt')
# config.bind('<Ctrl-B>', 'rl-backward-char', mode='prompt')
# config.bind('<Ctrl-E>', 'rl-end-of-line', mode='prompt')
# config.bind('<Ctrl-F>', 'rl-forward-char', mode='prompt')
# config.bind('<Ctrl-H>', 'rl-backward-delete-char', mode='prompt')
# config.bind('<Ctrl-K>', 'rl-kill-line', mode='prompt')
# config.bind('<Ctrl-P>', 'prompt-open-download --pdfjs', mode='prompt')
# config.bind('<Ctrl-U>', 'rl-unix-line-discard', mode='prompt')
# config.bind('<Ctrl-W>', 'rl-unix-word-rubout', mode='prompt')
# config.bind('<Ctrl-X>', 'prompt-open-download', mode='prompt')
# config.bind('<Ctrl-Y>', 'rl-yank', mode='prompt')
# config.bind('<Down>', 'prompt-item-focus next', mode='prompt')
# config.bind('<Escape>', 'leave-mode', mode='prompt')
# config.bind('<Return>', 'prompt-accept', mode='prompt')
# config.bind('<Shift-Tab>', 'prompt-item-focus prev', mode='prompt')
# config.bind('<Tab>', 'prompt-item-focus next', mode='prompt')
# config.bind('<Up>', 'prompt-item-focus prev', mode='prompt')

## Bindings for register mode
# config.bind('<Escape>', 'leave-mode', mode='register')

## Bindings for yesno mode
# config.bind('<Alt-Shift-Y>', 'prompt-yank --sel', mode='yesno')
# config.bind('<Alt-Y>', 'prompt-yank', mode='yesno')
# config.bind('<Escape>', 'leave-mode', mode='yesno')
# config.bind('<Return>', 'prompt-accept', mode='yesno')
# config.bind('n', 'prompt-accept no', mode='yesno')
# config.bind('y', 'prompt-accept yes', mode='yesno')
