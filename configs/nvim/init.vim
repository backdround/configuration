" ============================================================================
" Load Plugins {{{

function! s:LoadPlugins()
  " --------------------------------------------------------------------------
  " INSTALL vim-plug
  if !filereadable(expand('~/.local/share/nvim/site/autoload/plug.vim'))
    echom 'Plugin manager: vim-plug has not been installed. Try to install...'
    exec 'silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs '.
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    echom 'Installing vim-plug complete.'

    let l:first_init = 1
  endif

  " --------------------------------------------------------------------------
  " SET PLUGINS

  call plug#begin('~/.local/share/nvim/plugged')

  " --------------------------------------------------------------------------
  " UI ENCHANTMENTS
  Plug 'rafi/awesome-vim-colorschemes' " COLORSCHEMES
  Plug 'backdround/melting'            " MY COLORSCHEME
  Plug 'sheerun/vim-polyglot'          " POLYGLOT
  Plug 'ryanoasis/vim-devicons'        " DEVICONS

  Plug 'vim-airline/vim-airline'       " AIRLINE

  " --------------------------------------------------------------------------
  " WINDOW-BASED FEATURES
  Plug 'voldikss/vim-floaterm'         " FLOATERM
  Plug 'mhinz/vim-startify'            " STARTIFY
  Plug 'majutsushi/tagbar'             " TAG BAR
  Plug 'mbbill/undotree'               " UNDOTREE

  Plug 'scrooloose/nerdtree'           " NERDTREE
  Plug 'Xuyuanp/nerdtree-git-plugin'

  " --------------------------------------------------------------------------
  " MOTIONS
  Plug 'romainl/vim-cool'              " COOL
  Plug 'easymotion/vim-easymotion'     " EASYMOTION
  Plug 'yuttie/comfortable-motion.vim' " COMFORTABLE-MOTION
  Plug 'chaoren/vim-wordmotion'        " WORDMOTION

  " --------------------------------------------------------------------------
  " EDITORS
  Plug 'scrooloose/nerdcommenter'      " NERDCOMMENTER
  Plug 'junegunn/vim-easy-align'       " EASY-ALIGN
  Plug 'tpope/vim-surround'            " SURROUND
  Plug 'jiangmiao/auto-pairs'          " AUTO-PAIRS
  Plug 'AndrewRadev/sideways.vim'      " SIDEWAYS
  Plug 'tommcdo/vim-exchange'          " EXCHANGE
  Plug 'kana/vim-niceblock'            " NICEBLOCK
  Plug 'matze/vim-move'                " MOVE
  Plug 'AndrewRadev/splitjoin.vim'     " SPLITJOIN

  " --------------------------------------------------------------------------
  " TEXT OBJECT
  Plug 'gcmt/wildfire.vim'             " WILDFIRE
  Plug 'wellle/targets.vim'            " TARGETS
  Plug 'kana/vim-textobj-user'         " TEXTOBJ USER
  Plug 'kana/vim-textobj-indent'       " TEXTOBJ INDENT

  " --------------------------------------------------------------------------
  " FEATURES
  if !exists("g:editor")
    Plug 'xolox/vim-misc'
                                          " MARKDOWN PREVIEW
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
    Plug 'backdround/ctrlsf.vim'          " CTRLSF
    Plug 'ludovicchabant/vim-gutentags'   " GUTENTAGS
    Plug 'xolox/vim-notes'                " NOTES
    Plug 'airblade/vim-rooter'            " ROOTER
    Plug 'markonm/traces.vim'             " TRACES
    Plug 'backdround/vim-repeat'          " REPEAT
    Plug 'junegunn/limelight.vim'         " LIMELIGHT
    Plug 'junegunn/goyo.vim'              " GOYO
    Plug 'tyru/open-browser.vim'          " OPEN BROWSER
    "Plug 'kshenoy/vim-signature'          " SIGNATURE

    Plug 'SirVer/ultisnips'               " SNIPPETS

    Plug 'backdround/DoxygenToolkit.vim'  " DOXYGEN

    Plug '/usr/share/vim/vimfiles'        " FZF (INSTALLED BY PACMAN)
    Plug 'junegunn/fzf.vim'

    Plug 'xolox/vim-session'              " SESSION

                                          " COMPLETE
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

                                          " LSP HIGHLIGHT
    Plug 'jackguo380/vim-lsp-cxx-highlight'

    "Plug 'mhinz/vim-signify'              " GIT
    Plug 'tpope/vim-fugitive'
  endif

  call plug#end()

  if exists("l:first_init")
    PlugInstall
  endif

endfunction
" }}}
" ============================================================================

" ============================================================================
" Basic Settings {{{

function! s:BasicSettings()
  " --------------------------------------------------------------------------
  " options {{{

  "left column
  set number
  set relativenumber
  "search
  set incsearch
  set hlsearch
  set ignorecase
  set smartcase
  "folding
  set foldenable
  set foldlevel=100
  set foldmethod=marker
  "tab
  set tabstop=2
  set shiftwidth=2
  set smarttab
  set expandtab
  set smartindent
  "local language
  set keymap=custom_ru
  set iminsert=0
  set imsearch=0
  "misc
  set updatetime=50
  set scrolloff=10
  set showcmd
  set cmdheight=2
  set ch=1
  set mouse=a
  set mousehide
  set nowrap
  set showmatch
  set backspace=indent,eol,start
  set history=200
  set list
  set listchars=tab:\ \ ,trail:·
  set fillchars=fold:\ ,
  set fillchars=vert:\ ,
  set cursorline
  set nocompatible
  set backup
  set backupdir=~/.nvimbk
  set notimeout " for leader key etc
  set noequalalways
  set sessionoptions-=buffers
  set sessionoptions+=globals
  set completeopt+=preview
  let g:loaded_matchit = 1
  let g:no_plugin_maps = 1
	let g:loaded_netrw = 1
	let g:loaded_netrwPlugin = 1

  " view options
  set termguicolors
  set background=dark

  let g:airline_theme='melting'
  colorscheme melting

  if exists("g:editor")
    set nobackup
    set noswapfile
  endif
  " }}}

  " --------------------------------------------------------------------------
  " bindings {{{

  " insert word motions
  inoremap <C-w> <C-o>b
  inoremap <C-q> <Esc>gea
  inoremap <C-j> <C-o>w
  inoremap <C-p> <Esc>ea

  inoremap <C-a> <C-o>B
  inoremap <C-o> <Esc>gEa
  inoremap <C-e> <C-o>W
  inoremap <C-u> <Esc>Ea

  " insert editing
  inoremap <C-t> <Esc>cc
  inoremap <C-h> <C-w>
  inoremap <M-h> <Cmd>:call Ctrl_W()<Cr>

  " normal
  map d <nop>
  let g:mapleader = 'd'

  " word motions
  noremap w b
  noremap W B
  noremap q ge
  noremap Q gE
  noremap j w
  noremap J W
  noremap p e
  noremap P E

  " scroll
  noremap e <C-e>
  noremap E <C-d>
  noremap u <C-y>
  noremap U <C-u>

  " symbol find
  noremap k f
  noremap K t

  noremap z F
  noremap Z T

  noremap ) ;
  noremap ( ,

  " marks / jumps
  nnoremap y m
  nnoremap Y <C-o>
  nnoremap i `
  nnoremap I <C-i>

  " tab managment
  map v <Nop>
  nnoremap <silent> vo <Cmd>Startify<CR>
  nnoremap <silent> vi <Cmd>tabnew +Startify<CR>
  nnoremap <silent> vI <Cmd>buffer # \| tabnew +buffer #<CR>

  nnoremap <silent> vE <Cmd>tabfirst<CR>
  nnoremap <silent> vU <Cmd>tablast<CR>
  nnoremap <silent> ve <Cmd>tabprev<CR>
  nnoremap <silent> vu <Cmd>tabnext<CR>

  nnoremap <silent> vs <Cmd>-tabmove<CR>
  nnoremap <silent> vp <Cmd>+tabmove<CR>

  nnoremap <expr> <silent> vq tabpagenr('$') == 1 ? "<Cmd>quitall<CR>" : "<Cmd>tabclose<CR>"
  nnoremap <expr> <silent> vQ tabpagenr('$') == 1 ? "<Cmd>quitall!<CR>" : "<Cmd>tabclose!<CR>"
  nnoremap <silent> vz <Cmd>quitall<CR>
  nnoremap <silent> vZ <Cmd>quitall!<CR>
  nnoremap <silent> <M-z> <Cmd>xall<CR>

  " split managment
  map s <Nop>
  nnoremap <silent> s<M-i> <Cmd>tabnew<CR>
  nnoremap <silent> s<M-u> <Cmd>vsplit<CR>
  nnoremap <silent> s<M-e> <Cmd>split<CR>

  nnoremap <silent> sq <Cmd>quit<CR>
  nnoremap <silent> sQ <Cmd>quit!<CR>

  nnoremap so <C-w>h
  nnoremap se <C-w>j
  nnoremap su <C-w>k
  nnoremap si <C-w>l

  nnoremap sO <C-w>H
  nnoremap sE <C-w>J
  nnoremap sU <C-w>K
  nnoremap sI <C-w>L

  nnoremap ss <C-w>=
  nnoremap s+ <C-w>+
  nnoremap s- <C-w>-
  nnoremap s< <C-w><
  nnoremap s> <C-w>>
  nnoremap s\| <C-w>\|
  nnoremap s_ <C-w>_

  " misc movement
  map o <nop>
  noremap oh G
  noremap ot gg
  noremap og zH
  noremap oc zL

  noremap od ^ze
  noremap ob +ze
  noremap of -ze

  noremap on $
  noremap o. +$
  noremap or -$

  noremap + <Cmd>:call MoveThrough("[\"'`]")<Cr>
  noremap - <Cmd>:call MoveThrough("[\"'`]", v:true)<Cr>

  noremap ^ <Cmd>:call MoveThrough("[()]")<Cr>
  noremap @ <Cmd>:call MoveThrough("[()]", v:true)<Cr>

  " copy / paste
  noremap  f         "py
  nnoremap ff        "pyy
  nnoremap F         "py$
  noremap  <leader>f "+y
  noremap  <leader>F "*y
  noremap  bf        "sy

  noremap l         p
  noremap L         P
  noremap <M-l>     "pp
  noremap <M-L>     "pP
  inoremap <C-l> <C-o>p
  inoremap <M-l> <C-o>"pP
  noremap <leader>l "+p
  noremap <leader>L "*p
  noremap bl        "sp

  " find
  nnoremap ! <Cmd>let @/ = expand('<cword>') \| set hlsearch<Cr>
  nnoremap * g*
  nnoremap # g#
  nnoremap [ N
  nnoremap ] n

  " insert
  nnoremap g i
  nnoremap G I

  nnoremap c a
  nnoremap C A

  nnoremap r o
  nnoremap R O

  " basic changes
  noremap h c
  noremap H C

  noremap t d
  noremap T D

  noremap , r
  noremap ' x

  nnoremap m u
  nnoremap M <C-r>

  noremap " J

  " visual mode
  nnoremap n v
  nnoremap N V
  nnoremap <C-n> <C-v>

  vnoremap i gv
  vnoremap m gu
  vnoremap M gU

  noremap <Plug>(virtual-visual-a) a
  noremap <Plug>(virtual-visual-i) i

  vnoremap G I
  vnoremap C A

  vnoremap r o

  " substitute
  map b <nop>
  nnoremap bu :%s/<C-r>s//g<Left><Left>
  vnoremap bu :s/<C-r>s//g<Left><Left>
  nnoremap bU :%s/<C-r>s//gc<Left><Left><Left>
  vnoremap bU :s/<C-r>s//gc<Left><Left><Left>

  nnoremap be :%s/\<<C-r>s\>//g<Left><Left>
  vnoremap be :s/\<<C-r>s\>//g<Left><Left>
  nnoremap bE :%s/\<<C-r>s\>//gc<Left><Left><Left>
  vnoremap bE :s/\<<C-r>s\>//gc<Left><Left><Left>

  " other
  set pastetoggle=<F8>

  inoremap <M-c> <C-^>
  vnoremap / y/<C-R>"<CR>
  nnoremap _ <esc>:w<CR>
  nnoremap <silent> <leader>r <Cmd>source ~/.config/nvim/init.vim<CR>
  nmap <leader>c <Cmd>echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<Cr>

  map x <Nop>
  nnoremap <silent> xh <C-]>
  nnoremap <silent> xt :tab Man<CR>
  nnoremap <silent> xn gd
  " }}}

  " --------------------------------------------------------------------------
  " autocomands {{{

  "disabling autocommenting
  augroup DisablingAutocommenting
    autocmd!
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  augroup END

  "change indention to 4 spaces
  augroup IdentionInCppLanguage
    autocmd!
    autocmd FileType cpp,c,hpp,h setlocal shiftwidth=4
  augroup END

  "set engligsh language when leave insert mode
  augroup LeaveInsertLanguage
    autocmd!
    autocmd InsertLeave * set iminsert=0
  augroup END

  "set title to current directory
  set title
  augroup Title
    autocmd!
    autocmd DirChanged * let &titlestring = fnamemodify(getcwd(), ':t')
  augroup END
  let &titlestring = fnamemodify(getcwd(), ':t')

  "}}}

  " other
  command! FilePath echo(expand("%:p"))

endfunction
" }}}
" ============================================================================

" ============================================================================
" Common Plugins Configuration {{{

function! s:ConfigureCommonPlugins()

  " **************************************************************************
  " UI ENCHANTMENTS

  " markdown polyglot
  let g:vim_markdown_no_default_key_mappings = 1

  " --------------------------------------------------------------------------
  " devicons
  let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
  let g:WebDevIconsUnicodeDecorateFolderNodes = 1
  let g:DevIconsEnableFoldersOpenClose = 1
  let g:DevIconsEnableFolderExtensionPatternMatching = 1

  " --------------------------------------------------------------------------
  " airline
  let g:airline#extensions#disable_rtp_load = 1
  let g:airline_extensions = ['tabline', 'quickfix', 'tagbar', 'gutentags', 'undotree', 'coc']
  if exists("g:editor")
    let g:airline_extensions = []
  endif

  let g:airline_highlighting_cache = 1
  let g:airline_inactive_collapse = 0
  let g:airline_powerline_fonts = 1

  let g:airline#extensions#default#section_truncate_width = {}

  let g:airline_section_b = ''
  let g:airline_section_y = ''
  let g:airline_section_x = '%y'
  let g:airline_section_c = '%t%m'
  let g:airline_section_z = '%#__accent_bold#%p%% %l/%L%#__restore__#'

  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = '╱'
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = '╱'

  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#show_close_button = 0
  let g:airline#extensions#tabline#tab_nr_type = 1
  let g:airline#extensions#tabline#fnamemod = ':t:m'

  let g:airline#extensions#tabline#show_buffers = 0
  let g:airline#extensions#tabline#show_splits = 1
  let g:airline#extensions#tabline#show_tab_count = 0

  " Fix mode truncation (truncated at 79 symbols).
  function! AirlineInit()
    function! airline#parts#mode()
      return airline#util#shorten(get(w:, 'airline_current_mode', ''), 50, 1)
    endfunction
  endfunction
  autocmd User AirlineAfterInit call AirlineInit()

  " **************************************************************************
  " WINDOW-BASED FEATURES

  " --------------------------------------------------------------------------
  " floaterm
  let g:floaterm_width = 0.9
  let g:floaterm_height = 0.9
  let g:floaterm_wintype = "floating"
  let g:floaterm_position = "center"
  let g:floaterm_title = ''
  let g:floaterm_autoinsert = v:true

  let g:floaterm_keymap_toggle = '<F1>'
  let g:floaterm_keymap_kill = '<F2>'
  tnoremap <F3> <C-\><C-n>
  nnoremap <F3> <Cmd>FloatermToggle<Cr><C-\><C-n>

  " --------------------------------------------------------------------------
  " startify
  let g:startify_change_to_dir = 0
  let g:startify_change_to_vcs_root = 0
  let g:startify_update_oldfiles = 1
  let g:startify_fortune_use_unicode = 1
  let g:startify_padding_left = 8
  let g:startify_files_number = 5

  let g:startify_bookmarks = [
        \ {'cv': '~/configuration/configs/nvim/init.vim'},
        \ {'cz': '~/configuration/configs/terminal/zshrc'},
        \ {'ci': '~/configuration/configs/desktop/i3_template'},
        \ {'cp': '~/configuration/configs/polybar/config'},
        \ {'cm': '~/configuration/configs/terminal/tmux'},
        \ {'ct': '~/configuration/configs/terminal/kitty'},
        \ {'cc': '~/configuration/configs/desktop/picom.conf'},
        \ {'cx': '~/configuration/configs/misc/xprofile'},
        \ {'cr': '~/configuration/configs/misc/Xresources'},
        \ {'cd': '~/configuration/configs/desktop/dunstrc'},
        \ {'di': '~/drop/it'},
        \ {'dw': '~/drop/work'},
        \ {'dn': '~/drop/investment'},
        \ {'dm': '~/drop/home'},
        \ {'dh': '~/drop/health'},
        \ ]

  let g:startify_lists = [
        \ { 'type':'sessions',  'header': ['Sessions']                                 },
        \ { 'type':'bookmarks', 'header': ['Bookmarks']                                },
        \ { 'type':'files',     'header': ['MRU'], 'indices': ['A', 'S', 'D', 'F','G'] },
        \ ]

  let g:startify_session_before_save = [
        \ 'silent! NERDTreeClose',
        \ 'silent! TagbarClose'
        \ ]

  let g:startify_session_dir = '~/.local/share/nvim/sessions/'
  let g:startify_session_persistence = 1
  let g:startify_session_sort = 1
  let g:startify_session_number = 9

  " --------------------------------------------------------------------------
  " tagbar
  let g:tagbar_width = 30
  let g:tagbar_zoomwidth = 100
  let g:tagbar_hide_nonpublic = 1
  let g:tagbar_silent = 1
  let g:tagbar_map_showproto = "t" "remap showproto from <Space> to t
  let g:tagbar_autoshowtag = 1
  let g:tagbar_autofocus = 0
  nnoremap <silent> vh :TagbarToggle<CR>
  nnoremap <silent> sh :call SwitchWindowTo("__Tagbar__.*")<CR>

  " --------------------------------------------------------------------------
  " undotree
  let g:undotree_CustomUndotreeCmd  = 'topleft vertical 30 new'
  let g:undotree_CustomDiffpanelCmd = 'botright 7 new'
  let g:undotree_RelativeTimestamp = 1
  let g:undotree_ShortIndicators = 1
  let g:undotree_HelpLine = 0
  nnoremap <silent> vn :UndotreeToggle<CR>
  nnoremap <silent> sn :call SwitchWindowTo("undotree_*")<CR>

  " --------------------------------------------------------------------------
  " nerdtree
  let g:NERDTreeStatusline = 'Nerdtree'
  let g:NERDTreeMapOpenInTab = '<C-i>'
  let g:NERDTreeMapOpenSplit = 'e'
  let g:NERDTreeMapOpenVSplit = 'u'
  let g:NERDTreeMapPreviewSplit = 'gs'
  let g:NERDTreeMapPreviewVSplit = 'gv'
  let g:NERDTreeMapMenu = 'a'
  let g:NERDTreeWinSize = '29'

  nnoremap <silent> vt :call NerdtreeToggle()<CR>
  nnoremap <silent> st :call SwitchWindowTo("NERD_tree_*")<CR>
  nnoremap <silent> <leader>,n :NERDTreeRefreshRoot<CR>
  nnoremap <silent> <leader>,t :NERDTreeFind<CR>
  nnoremap <silent> <leader>,h :NERDTreeCWD<CR>

  nnoremap <silent> s, :call LoadWindow()<CR>


  " **************************************************************************
  " MOTIONS

  " --------------------------------------------------------------------------
  " easymotion
  let g:EasyMotion_do_mapping = 0
  let g:EasyMotion_smartcase = 1
  let g:EasyMotion_use_smartsign_us = 1
  let g:EasyMotion_use_upper = 1
  let g:EasyMotion_keys = 'ASDGHKLQWERTYUIOPZXCVBNMFJ'
  let g:EasyMotion_space_jump_first = 1

  map a <Plug>(easymotion-lineanywhere)

  map o[ <Plug>(easymotion-vim-N)
  map o] <Plug>(easymotion-vim-n)

  map ok <Plug>(easymotion-bd-f)
  map oz <Plug>(easymotion-bd-t)

  map ow <Plug>(easymotion-b)
  map oq <Plug>(easymotion-ge)
  map oj <Plug>(easymotion-w)
  map op <Plug>(easymotion-e)

  map oa <Plug>(easymotion-B)
  map oo <Plug>(easymotion-gE)
  map oe <Plug>(easymotion-W)
  map ou <Plug>(easymotion-E)

  " --------------------------------------------------------------------------
  " comfortable-motion
  let g:comfortable_motion_no_default_key_mappings = 1
  let g:comfortable_motion_interval = 1000.0 / 60

  let g:comfortable_motion_friction = 320.0
  let g:comfortable_motion_air_drag = 6.2

  let g:cm_impulse = 8

  nnoremap <silent> E :call comfortable_motion#flick(g:cm_impulse * winheight(0) *  0.7  )<CR>
  nnoremap <silent> e :call comfortable_motion#flick(g:cm_impulse * winheight(0) *  0.35 )<CR>

  nnoremap <silent> U :call comfortable_motion#flick(g:cm_impulse * winheight(0) * -0.7  )<CR>
  nnoremap <silent> u :call comfortable_motion#flick(g:cm_impulse * winheight(0) * -0.35 )<CR>

  " --------------------------------------------------------------------------
  " wordmotion
  let g:wordmotion_spaces = '()\[\]<>{}' . ',./%@^!?;:$~`"\#_|-+=&*' . "'"
  let g:wordmotion_mappings = {
        \ 'w'         :'<M-j>',
        \ 'b'         :'<M-w>',
        \ 'e'         :'<M-p>',
        \ 'ge'        :'<M-q>',
        \ 'W'         :'<M-J>',
        \ 'B'         :'<M-W>',
        \ 'E'         :'<M-P>',
        \ 'gE'        :'<M-Q>',
        \ 'aw'        :'g<M-w>',
        \ 'iw'        :'c<M-w>',
        \ 'aW'        :'g<M-W>',
        \ 'iW'        :'c<M-W>',
        \ '<C-R><C-W>':'<C-R><C-M>'
  \ }

  " **************************************************************************
  " EDITORS

  " --------------------------------------------------------------------------
  " nerdcommenter
  let g:NERDCreateDefaultMappings = 0
  let g:NERDRemoveExtraSpaces = 1
  let g:NERDTrimTrailingWhitespace = 1
  let g:NERDCompactSexyComs = 1
  let g:NERDToggleCheckAllLines = 1

  map bb <Plug>NERDCommenterComment
  map bm <Plug>NERDCommenterUncomment
  map bB <Plug>NERDCommenterYank

  " --------------------------------------------------------------------------
  " easy-align
  map bD <Plug>(EasyAlign)
  map bd <Plug>(LiveEasyAlign)

  " --------------------------------------------------------------------------
  " surround
  let g:surround_no_mappings = 1

  nmap tn  <Plug>Dsurround
  nmap hn  <Plug>Csurround
  nmap hN  <Plug>CSurround
  nmap bn  <Plug>Ysurround
  nmap bN  <Plug>YSurround
  nmap bnn <Plug>Yssurround
  nmap bNn <Plug>YSsurround
  nmap bNN <Plug>YSsurround
  xmap n   <Plug>VSurround
  xmap N  <Plug>VgSurround

  " --------------------------------------------------------------------------
  " auto-pairs
  let g:AutoPairsShortcutToggle = '<M-a>'
  let g:AutoPairsShortcutJump = '<M-o>'
  let g:AutoPairsShortcutFastWrap = '<M-u>'
  let g:AutoPairsShortcutBackInsert = '<M-e>'

  let g:AutoPairsFlyMode = 1
  let g:AutoPairsMultilineClose = 1
  let g:AutoPairsMapCh = 0
  " --------------------------------------------------------------------------
  " sideways
  nmap <silent> b, <Cmd>SidewaysLeft<Cr>
  nmap <silent> b. <Cmd>SidewaysRight<Cr>
  nmap <silent> x, <Cmd>SidewaysJumpLeft<Cr>
  nmap <silent> x. <Cmd>SidewaysJumpRight<Cr>

  omap <Plug>(virtual-visual-a)a <Plug>SidewaysArgumentTextobjA
  xmap <Plug>(virtual-visual-a)a <Plug>SidewaysArgumentTextobjA
  omap <Plug>(virtual-visual-i)a <Plug>SidewaysArgumentTextobjI
  xmap <Plug>(virtual-visual-i)a <Plug>SidewaysArgumentTextobjI

  " --------------------------------------------------------------------------
  " exchange
  let g:exchange_no_mappings = 1
  map bc <Plug>(Exchange)
  nmap bC <Plug>(ExchangeClear)
  nmap br <Plug>(ExchangeLine)

  " --------------------------------------------------------------------------
  " niceblock
  let g:niceblock_no_default_key_mappings = 1
  xmap G <Plug>(niceblock-I)
  xmap C <Plug>(niceblock-A)

  " --------------------------------------------------------------------------
  " vim-move
  let g:move_map_keys = 0
  nmap <M-g> <Plug>MoveLineDown
  nmap <M-c> <Plug>MoveLineUp
  nmap <M-f> <Plug>MoveCharLeft
  nmap <M-r> <Plug>MoveCharRight

  vmap <M-g> <Plug>MoveBlockDown
  vmap <M-c> <Plug>MoveBlockUp
  vmap <M-f> <Plug>MoveBlockLeft
  vmap <M-r> <Plug>MoveBlockRight

  " --------------------------------------------------------------------------
  " splitjoin
  let g:splitjoin_split_mapping = 'bh'
  let g:splitjoin_join_mapping = 'bt'

  " **************************************************************************
  "TEXT OBJECT

  " wildfire
  let g:wildfire_objects = ["i'", 'i"', "i)", "i]", "i}", "ip", "it", "i>"]

  " targets

  let g:targets_aiAI        = 'gc  '
  let g:targets_mapped_aiAI = ['<Plug>(virtual-visual-i)', '<Plug>(virtual-visual-a)', '', '']
  let g:targets_nl = 'th'

  " textobj indent
  let g:textobj_indent_no_default_key_mappings = 1
  xmap <Plug>(virtual-visual-a)i <Plug>(textobj-indent-a)
  xmap <Plug>(virtual-visual-i)i <Plug>(textobj-indent-i)
  xmap <Plug>(virtual-visual-a)s <Plug>(textobj-indent-same-a)
  xmap <Plug>(virtual-visual-i)s <Plug>(textobj-indent-same-i)

endfunction
" }}}
" ============================================================================

" ============================================================================
" Feature Plugins Configuration {{{

function! s:ConfigureFeaturePlugins()
  " --------------------------------------------------------------------------
  " markdown preview
  let g:mkdp_command_for_global = 1
  let g:mkdp_auto_close = 0
  nmap <silent> <leader>m <Cmd>MarkdownPreview<Cr>

  " --------------------------------------------------------------------------
  " ctrlsf
  let g:ctrlsf_auto_focus = {"at" : "start"}
  let g:ctrlsf_context = '-A 5 -B 2'
  let g:ctrlsf_default_root = 'project+wf'
  let g:ctrlsf_default_view_mode = 'normal'
  let g:ctrlsf_position = 'bottom'
  let g:ctrlsf_winsize = '70%'
  let g:ctrlsf_indent = 2
  let g:ctrlsf_mapping = {
        \ "split"  : "<C-e>",
        \ "vsplit" : "<C-u>",
        \ "tab"    : "<C-i>",
        \ }

  nmap <Leader>g <Plug>CtrlSFCCwordExec
  nmap <Leader>G <Plug>CtrlSFCwordExec
  vmap <Leader>g <Plug>CtrlSFVwordExec

  " --------------------------------------------------------------------------
  " gutentags
  let g:gutentags_add_default_project_roots = 0
  let g:gutentags_project_root              = ['.git', '.gutMark']
  let g:gutentags_cache_dir                 = '~/.local/share/nvim/tags'
  let g:gutentags_exclude_project_root      = ['/usr']
  let g:gutentags_file_list_command         = 'fd --type file'

  " --------------------------------------------------------------------------
  " notes
  let g:notes_directories = ['~/drop']
  let g:notes_title_sync = 'rename_file'

  " --------------------------------------------------------------------------
  " rooter
  let g:rooter_silent_chdir = 1
  let g:rooter_resolve_links = 1
  let g:rooter_patterns = ['.git/']

  " --------------------------------------------------------------------------
  " repeat
  let g:repeat_no_default_key_mappings = 1
  nmap . <Plug>(RepeatDot)
  nmap m <Plug>(RepeatUndo)
  nmap M <Plug>(RepeatRedo)

  " --------------------------------------------------------------------------
  " limelight
  let g:limelight_conceal_guifg = '#446666'
  let g:limelight_paragraph_span = 2

  " --------------------------------------------------------------------------
  " Goyo
  let g:goyo_width = '170'
  nnoremap <Leader>. <Cmd>Goyo<CR>

  augroup GoyoMode
    autocmd!
    autocmd User GoyoEnter Limelight
    autocmd User GoyoLeave Limelight!
  augroup END

  " --------------------------------------------------------------------------
  " open-browser
  nmap <leader>/ <Plug>(openbrowser-smart-search)
  vmap <leader>/ <Plug>(openbrowser-smart-search)

  " --------------------------------------------------------------------------
  " signature
  "let g:SignatureMap = {
        "\ 'Leader'             :  "<Leader>y",
        "\ 'DeleteMark'         :  "t<Leader>y",
        "\ 'ListBufferMarks'    :  "<Leader>y/",
        "\ 'ListBufferMarkers'  :  "<Leader>y?",
        "\ 'GotoNextMarker'     :  "<Leader>y>",
        "\ 'GotoPrevMarker'     :  "<Leader>y<",
        "\ 'GotoNextMarkerAny'  :  "<Leader>y]",
        "\ 'GotoPrevMarkerAny'  :  "<Leader>y["
        "\ }

  " --------------------------------------------------------------------------
  " ultisnips
  let g:UltiSnipsUsePythonVersion = 3
  let g:UltiSnipsEditSplit = 'normal'
  let g:UltiSnipsSnippetDirectories = [expand("~/").'.local/share/nvim/UltiSnips']
  let g:UltiSnipsEnableSnipMate = 0

  nnoremap <silent> <leader>jo <Cmd>edit   +UltiSnipsEdit<Cr>
  nnoremap <silent> <leader>je <Cmd>split  +UltiSnipsEdit<Cr>
  nnoremap <silent> <leader>ju <Cmd>vsplit +UltiSnipsEdit<Cr>
  nnoremap <silent> <leader>ji <Cmd>tabe   +UltiSnipsEdit %<Cr>

  let g:UltiSnipsExpandTrigger = '<M-k>'
  let g:UltiSnipsJumpForwardTrigger = '<M-k>'
  let g:UltiSnipsJumpBackwardTrigger = '<M-j>'

  augroup ReloadSnippetsOnSave
    autocmd!
    autocmd BufWritePost *.snippets call UltiSnips#RefreshSnippets()
  augroup END

  " --------------------------------------------------------------------------
  " Doxygen Toolkit
  let g:DoxygenToolkit_briefTag_pre = "\\brief "
  let g:DoxygenToolkit_templateParamTag_pre = "\\tparam "
  let g:DoxygenToolkit_paramTag_pre = "\\param "
  let g:DoxygenToolkit_returnTag = "\\return "
  let g:DoxygenToolkit_blockTag = "\\name "
  let g:DoxygenToolkit_classTag = "\\class "
  let g:DoxygenToolkit_interCommentTag = ""
  let g:DoxygenToolkit_interCommentBlock = ""

  " --------------------------------------------------------------------------
  " fzf
  " options {{{
  let $FZF_DEFAULT_OPTS = '--multi --no-mouse --inline-info'
  let $FZF_DEFAULT_COMMAND = 'fd --hidden  --type file
        \ --exclude .git/ --exclude .ccls.cache/ --exclude build/'

  let g:fzf_action = {
        \ 'ctrl-e': 'split',
        \ 'ctrl-u': 'vsplit',
        \ 'ctrl-i': 'tab split' }
  let g:fzf_layout = { 'down': '30%' }
  let g:fzf_history_dir = '~/.local/share/fzf-history'
  let g:fzf_command_prefix='Fzf'

  " autoclose statusline
  augroup CustomFzfView
    autocmd!
    autocmd  FileType fzf set laststatus=0 noshowmode relativenumber!
    autocmd  FileType fzf autocmd BufLeave <buffer> set laststatus=2 showmode relativenumber
  augroup END
  " }}}

  " bindings {{{
  nmap <m-m> <plug>(fzf-maps-n)
  xmap <m-m> <plug>(fzf-maps-x)
  omap <m-m> <plug>(fzf-maps-o)
  imap <m-m> <plug>(fzf-maps-i)

  inoremap <expr> <c-f>g fzf#vim#complete#path("fd --no-ignore --hidden --type directory")
  inoremap <expr> <c-f>c fzf#vim#complete#path("fd --no-ignore --hidden --type file")
  imap <c-f>r <plug>(fzf-complete-line)
  imap <c-f>l <plug>(fzf-complete-buffer-line)

  " open file
  nnoremap <silent> <leader>d :FzfHelptags<CR>
  nnoremap <silent> <leader>h :FzfGFiles<CR>
  nnoremap <silent> <leader>H :FzfGFiles?<CR>| "changed
  nnoremap <silent> <expr> <leader>t ":FzfFiles ".(expand('%:p:h'))."\<CR>"
  nnoremap <silent> <leader>T :FzfFiles<CR>

  " useful
  nnoremap <silent> <leader>n :FzfBTags<CR>
  nnoremap <silent> <leader>N :FzfTags<CR>
  nnoremap <silent> <leader>R :FzfHistory<CR>| "mru
  nnoremap <leader>v :FzfWindows<CR>
  nnoremap <leader>k :FzfSnippets<CR>

  " useless
  nnoremap <leader>Dv :FzfFiles ~/.local/share/nvim<CR>
  nnoremap <leader>Db :FzfBuffers<CR>
  nnoremap <leader>Df :FzfLines<CR>
  nnoremap <leader>Dz :FzfMarks<CR>
  nnoremap <leader>Dg :FzfCommits<CR>
  nnoremap <leader>DG :FzfBCommits<CR>

  nnoremap <leader>Dl :FzfBLines<CR>

  nnoremap <leader>Dt :FzfColors<CR>| "theme
  nnoremap <leader>D: :FzfHistory:<CR>
  nnoremap <leader>D/ :FzfHistory/<CR>
  nnoremap <leader>Dc :FzfCommands<CR>
  " }}}


  " --------------------------------------------------------------------------
  " session
  let g:session_directory = '~/.local/share/nvim/sessions/'
  let g:session_default_overwrite = 1
  let g:session_autoload = 'no'
  let g:session_autosave = 'yes'
  let g:session_autosave_periodic = 5
  let g:session_autosave_silent = 1
  let g:session_persist_font = 0
  let g:session_persist_colors = 0
  let g:session_command_aliases = 1

  " --------------------------------------------------------------------------
  " coc
  let g:coc_snippet_next = '<M-k>'
  let g:coc_snippet_prev = '<M-j>'

  nnoremap <silent> <leader>z :CocRestart<CR>
  nnoremap <silent> <leader>Z :CocDisable<CR>

  " trigger complete
  inoremap <silent> <expr> <M-s> coc#refresh()

  " confirm completion
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

  " remap keys for go to
  nmap <silent> <leader>uo <Cmd>call CocAction('jumpDefinition', 'edit')<Cr>
  nmap <silent> <leader>ue <Cmd>call CocAction('jumpDefinition', 'split')<Cr>
  nmap <silent> <leader>uu <Cmd>call CocAction('jumpDefinition', 'vsplit')<Cr>
  nmap <silent> <leader>ui <Cmd>call CocAction('jumpDefinition', 'tab drop')<Cr>
  nmap <silent> <leader>e <Plug>(coc-references)
  "nmap <silent> <leader>ut <Plug>(coc-type-definition)
  "nmap <silent> <leader>ui <Plug>(coc-implementation)
  "nmap <silent> <leader>uD <Plug>(coc-declaration)
  "nmap <silent> <leader>un <Plug>(coc-diagnostic-next)
  "nmap <silent> <leader>up <Plug>(coc-diagnostic-prev)
  "" doesn't work properlu
  "nmap <silent> <leader>ul <Plug>(coc-openlink)

  "" do something
  map  <silent> <Leader>b <Plug>(coc-format-selected)
  nmap <silent> <Leader>B <Plug>(coc-format)

  "nmap <silent> <leader>uf <Plug>(coc-fix-current)
  "xmap <silent> <leader>ug <Plug>(coc-codeaction-selected)
  "nmap <silent> <leader>ug <Plug>(coc-codeaction)
  "nmap <silent> <leader>uR <Plug>(coc-rename)

  "" CocLists
  "nnoremap <silent> <leader>uz :<C-u>CocList --normal diagnostics<cr>
  "nnoremap <silent> <leader>uL :<C-u>CocList links<cr>
  "nnoremap <silent> <leader>us :<C-u>CocList -A outline<cr>
  "nnoremap <silent> <leader>uS :<C-u>CocList symbols<cr>

  " get info
  nnoremap <silent> B :call CocAction('showSignatureHelp')<CR>
  nnoremap <silent> D :call <SID>show_documentation()<CR>
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " lsp group
  augroup LSPGroup
    autocmd!
    autocmd CursorHold * silent call CocActionAsync('highlight')
    autocmd User CocJumpPlaceholder call
          \ CocActionAsync('showSignatureHelp')
    autocmd FileType json syntax match Comment +\/\/.\+$+
  augroup END

  " plugins
  let g:coc_global_extensions = [
        \ "coc-prettier",
        \ "coc-json",
        \ "coc-html",
        \ "coc-css",
        \ "coc-yaml",
        \ "coc-python",
        \ "coc-highlight",
        \ "coc-git",
        \ "coc-yank",
        \ "coc-vimlsp"
        \ ]
  "nnoremap <silent> <leader>uy :<C-u>CocList yank<cr>
  "nnoremap <silent> <leader>us  :<C-u>CocList --normal gstatus<CR>

  " --------------------------------------------------------------------------
  "signify
  let g:signify_vcs_list = ['git']
  let g:signify_sign_delete = '-'

  "nmap mj <plug>(signify-next-hunk)
  "nmap mk <plug>(signify-prev-hunk)

  "augroup SignifyRefresh "update without saving
    "autocmd!
    "autocmd CursorHold * SignifyRefresh
    "autocmd CursorHoldI * SignifyRefresh
    "autocmd FocusGained * SignifyRefresh
  "augroup END
endfunction

" }}}
" ============================================================================

" ============================================================================
" Util Functions {{{

" ----------------------------------------------------------------------------
" Save/Load window
function! s:CheckNormalWindow(window_number)
  let l:buf = winbufnr(a:window_number)
  if l:buf == -1 | return 0 | endif
  if buflisted(l:buf) == 0 | return 0 | endif
  if empty(getbufvar(l:buf, "&buftype")) != 1 | return 0 | endif
  return 1
endfunction

function! s:GetNormalWindow()
  let l:i = 1
  while(l:i <= winnr('$'))
    if s:CheckNormalWindow(l:i)
      return l:i
    endif
    let l:i = l:i + 1
  endwhile
  return -1
endfun

let t:saved_window = '-1'
function! s:SaveWindow()
  let l:current_window = bufwinnr('%')
  if s:CheckNormalWindow(l:current_window)
    let t:saved_window = l:current_window
  endif
endfunction


function! s:EnableAutoSaveWindow()
  augroup PreviousNormalWindow
    autocmd!
    autocmd WinEnter * call s:SaveWindow()
  augroup END
endfunction
call s:EnableAutoSaveWindow()

function! s:DisableAutoSaveWindow()
  augroup PreviousNormalWindow
    autocmd!
  augroup END
endfunction


function! LoadWindow()
  if t:saved_window != -1
    if s:CheckNormalWindow(t:saved_window)
      execute t:saved_window . "wincmd w"
      return
    endif
  endif

  let l:window_number = s:GetNormalWindow()
  if l:window_number != -1
    exec l:window_number . 'wincmd w'
  else
    wincmd w
  endif
endfunction

" ----------------------------------------------------------------------------
" Windows swithing
function! SwitchWindowTo(bufexpr)
  let l:window_number = bufwinnr(a:bufexpr)
  if l:window_number == -1 | return | endif

  let l:current_window = bufwinnr('%')
  if l:current_window == l:window_number
    call LoadWindow()
    return
  endif

  execute l:window_number . "wincmd w"
endfunction

" ----------------------------------------------------------------------------
" nerdtree toggle
function! NerdtreeToggle()
  let l:buffer_number = winbufnr(t:saved_window)
  NERDTreeToggleVCS
  let t:saved_window = bufwinnr(l:buffer_number)
  call LoadWindow()
endfunction

" ----------------------------------------------------------------------------
" Movements
function! MoveThrough(pattern, ...) " (pattern, isReverse)
  " Get reverse
  let l:reverse = v:false
  if a:0 > 0
    if a:1
      let l:reverse = v:true
    endif
  endif

  if l:reverse
    let l:flag = "b"
    normal! l
  else
    let l:flag = ""
    normal! h
  endif

  call search(a:pattern, l:flag, line("."))

  if l:reverse
    normal! h
  else
    normal! l
  endif
endfunction

" ----------------------------------------------------------------------------
" Insert editing
function! RemoveCharsInLine(from, to)
  let l:line = getline('.')
  let l:chars = str2list(l:line)

  call remove(l:chars, a:from - 1, a:to - 1)

  let l:line = list2str(l:chars)
  call setbufline(bufnr('%'), line('.'), l:line)
endfunction

function! Ctrl_W()
  " Remove previous word
  let l:right_position = virtcol('.')
  call search('\( \|^\)\S', 'be', line('.'))
  let l:left_position  = virtcol('.')

  if l:right_position - l:left_position > 0
    call RemoveCharsInLine(l:left_position, l:right_position - 1)
    return
  endif

  " Or inherit c-w behavior.
  call feedkeys("\<C-w>", 'n')
endfunction
" }}}
" ============================================================================

call s:LoadPlugins()
call s:BasicSettings()
call s:ConfigureCommonPlugins()
if !exists("g:editor")
  call s:ConfigureFeaturePlugins()
endif
