import os
import theme.draw

theme.draw.set_colors(c)
theme.draw.set_style(c)

c.aliases = {'w': 'session-save', 'q': 'quit', 'wq': 'quit --save', 'x': 'quit --save'}
c.auto_save.interval = 15000
c.auto_save.session = False

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

both_hands_chars = 'wvspyaoeuizqjkxfgcrldhtnbm'
left_hand_chars = 'wvspyaoeuizqjkx'
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

clear_script = "jseval -q -f ~/.config/qutebrowser/my_scripts/clear.js"

# Navigation
config.bind('a', 'run-with-count 7 scroll left')
config.bind('o', 'run-with-count 7 scroll right')
config.bind('e', 'run-with-count 7 scroll down')
config.bind('u', 'run-with-count 7 scroll up')

config.bind('s', 'run-with-count 14 scroll down')
config.bind('p', 'run-with-count 14 scroll up')

config.bind('W', 'scroll-to-perc')
config.bind('w', 'scroll-to-perc 0')

# Main
config.bind('i', 'hint')
config.bind('E', 'back')
config.bind('U', 'forward')

config.bind('<Escape>', 'clear-keychain ;; search ;; fullscreen --leave ;; ' + clear_script)

# Tabs
for i in range(1, 10):
    config.bind('<Alt-{}>'.format(i), 'tab-focus {}'.format(i))
config.bind('<Alt-0>', 'tab-focus -1')

config.bind('vq', 'tab-close')
config.bind('vv', 'undo')

config.bind('ve', 'tab-prev')
config.bind('vu', 'tab-next')

config.bind('vs', 'tab-move -')
config.bind('vp', 'tab-move +')

config.bind('vy', 'reload')
config.bind('vY', 'reload -f')


# Other
config.bind('+',              'zoom-in')
config.bind('-',              'zoom-out')
config.bind('=',              'zoom')
config.bind('/',              'set-cmd-text /')
config.bind('?',              'set-cmd-text ?')
config.bind(':',              'set-cmd-text :')
config.bind('<Ctrl-Return>',  'follow-selected -t')
config.bind('<Return>',       'follow-selected')
config.bind('<Ctrl-/>',       'search {primary}')
config.bind('<Ctrl-Shift-?>', 'search --reverse {primary}')
config.bind(']',              'search-next')
config.bind('[',              'search-prev')
config.bind('<Ctrl-Shift-b>', 'set-cmd-text -s :open -p')
config.bind('<Alt-r>',        'config-cycle --temp hints.chars {} {}'.format(both_hands_chars, left_hand_chars))

config.bind('g', 'enter-mode insert')
config.bind('c', 'enter-mode passthrough')
config.bind('r', 'enter-mode caret')


# open in background/new/current tab or new window
commands_with_prefix = [
    # navigate related current page
    ('i', 'navigate increment {}'),
    ('d', 'navigate decrement {}'),
    ('p', 'navigate prev {}'),
    ('n', 'navigate next {}'),
    ('t', 'navigate up {}'),
    ('e', 'back {}'),
    ('u', 'forward {}'),

    #quickmarks/bockmarks
    ('b', 'set-cmd-text -s :bookmark-load {}'),
    ('B', 'open {} qute://bookmarks#bookmarks'),
    ('q', 'set-cmd-text -s :quickmark-load {}'),
    ('Q', 'open {} qute://bookmarks'),

    #other
    ('y', 'open {} {{clipboard}}'),
    ('Y', 'open {} {{primary}}'),
    ('c', 'edit-url {}'),
    ('o', 'set-cmd-text -s :open {}'),
    ('O', 'open {}'),
    ('m', 'messages {}'),
    ('h', 'open {} qute://history')
]
ways_to_open = [
    ('j', ''),
    ('k', '--tab'),
    ('q', '--bg'),
    ('z', '--window')
]
for way in ways_to_open:
    for command in commands_with_prefix:
        keychain = way[0] + command[0]
        cmd = command[1].format(way[1])
        config.bind(keychain, cmd)

config.bind(ways_to_open[0][0] + 'i', 'hint all current')
config.bind(ways_to_open[1][0] + 'i', 'hint all tab-fg')
config.bind(ways_to_open[2][0] + 'i', 'hint all tab-bg')
config.bind(ways_to_open[3][0] + 'i', 'hint all window')


#  ******************
#  OTHER

# like vim <Ctrl-o>
from string import ascii_letters, digits
for i in ascii_letters + digits:
    config.bind('<Ctrl-o>{}'.format(i), 'fake-key ' + i)
config.bind('<Alt-Return>', 'fake-key <Return>')
config.bind('<Alt-Backspace>', 'fake-key <Backspace>')
config.bind('<Alt-Escape>', 'fake-key <Escape>')

# download
config.bind('dp', 'download --mhtml')
config.bind('ds', 'download-cancel')
config.bind('dc', 'download-clear')
config.bind('dd', 'download-delete')
config.bind('do', 'download-open')
config.bind('dr', 'download-retry')

# yanks
config.bind('fd', 'yank domain')
config.bind('fD', 'yank domain -s')
config.bind('fp', 'yank pretty-url')
config.bind('fP', 'yank pretty-url -s')
config.bind('ft', 'yank title')
config.bind('fT', 'yank title -s')
config.bind('fy', 'yank selection')
config.bind('fY', 'yank seleciion -s')
config.bind('fl', 'hint links yank')
config.bind('fL', 'hint links yank-primary')

# hints
config.bind('hh', 'hint all hover')
config.bind('hi', 'hint inputs --first')
config.bind('hI', 'hint inputs')
config.bind('hm', 'hint images')
config.bind('hM', 'hint images tab')
config.bind('hb', 'hint all tab-bg')
config.bind('hr', 'hint --rapid links tab-bg')
config.bind('hw', 'hint all window')
config.bind('hd', 'hint links download')

# tab managment
config.bind('to', 'tab-only')
config.bind('tc', 'tab-clone --bg')
config.bind('tC', 'tab-clone --window')
config.bind('tg', 'tab-give')
config.bind('tG', 'set-cmd-text -s :tab-give')
config.bind('tt', 'set-cmd-text -s :tab-take')
config.bind('tT', 'set-cmd-text -s :tab-take --keep')

# Session
config.bind('Ss', 'set-cmd-text -s :session-save --only-active-window')
config.bind('Sl', 'set-cmd-text -s :session-load')
config.bind('Sn', 'set-cmd-text -s :session-load --clear')
config.bind('Sd', 'set-cmd-text -s :session-delete')

# other
config.bind('tb', 'set-cmd-text -s :bookmark-add {url}')
config.bind('td', 'set-cmd-text -s :bookmark-del')
config.bind('tq', 'set-cmd-text -s :quickmark-add {url}')
config.bind('tD', 'set-cmd-text -s :quickmark-del')
config.bind('tm', 'tab-mute')
config.bind('tc', 'clear-messages')
config.bind('tr', 'config-source')
config.bind('te', 'config-edit')
config.bind('ts', 'view-source')
config.bind('tQ', 'quit')

config.bind('<Alt-h>', 'jseval -q document.querySelectorAll(\'video\') [0].currentTime -= 7;')
config.bind('<Alt-n>', 'jseval -q document.querySelectorAll(\'video\') [0].currentTime += 7;')
config.bind('<Alt-t>', 'jseval -q var video = document.querySelectorAll(\'video\') [0]; if (video.paused) { video.play();} else {video.pause();}')
config.bind('<Alt-c>', 'jseval -q document.querySelectorAll(\'video\') [0].playbackRate = 1;')
config.bind('<Alt-g>', 'jseval -q document.querySelectorAll(\'video\') [0].playbackRate -= 0.1;')
config.bind('<Alt-r>', 'jseval -q document.querySelectorAll(\'video\') [0].playbackRate += 0.1;')
config.bind('<Alt-a>', 'jseval -q document.querySelectorAll(\'video\') [0].playbackRate = 10;')
config.bind('<Alt-m>', 'jseval -q document.querySelectorAll(\'video\') [0].currentTime = 0;')
config.bind('<Alt-l>', 'jseval -q var video = document.querySelectorAll(\'video\') [0]; if (video.loop) { video.loop = 0;} else {video.loop = 1;}')


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
