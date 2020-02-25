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
  Plug 'sheerun/vim-polyglot'          " POLYGLOT
  Plug 'ryanoasis/vim-devicons'        " DEVICONS

  Plug 'vim-airline/vim-airline'       " AIRLINE
  Plug 'vim-airline/vim-airline-themes'

  " --------------------------------------------------------------------------
  " WINDOW-BASED FEATURES
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
  Plug 'terryma/vim-multiple-cursors'  " MULTIPLE-CURSORS
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
                                          " MARKDOWN PREVIEW
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
    Plug 'Chiel92/vim-autoformat'         " AUTOFORMAT
    Plug 'fasterbru/ctrlsf.vim'           " CTRLSF
    Plug 'ludovicchabant/vim-gutentags'   " GUTENTAGS
    Plug 'xolox/vim-notes'                " NOTES
    Plug 'airblade/vim-rooter'            " ROOTER
    Plug 'markonm/traces.vim'             " TRACES
    Plug 'tpope/vim-repeat'               " REPEAT
    Plug 'junegunn/limelight.vim'         " LIMELIGHT
    Plug 'junegunn/vim-peekaboo'          " PEEKABOO
    Plug 'troydm/zoomwintab.vim'          " ZOOM WIN TAB
    Plug 'tyru/open-browser.vim'          " OPEN BROWSER
    Plug 'kshenoy/vim-signature'          " SIGNATURE
    Plug 'Valloric/ListToggle'            " LIST TOGGLE

    Plug 'SirVer/ultisnips'               " SNIPPETS
    Plug 'honza/vim-snippets'

    Plug 'vim-scripts/DoxygenToolkit.vim' " DOXYGEN

    Plug '/usr/share/vim/vimfiles'        " FZF (INSTALLED BY PACMAN)
    Plug 'junegunn/fzf.vim'

    Plug 'xolox/vim-misc'                 " SESSION
    Plug 'xolox/vim-session'

                                          " COMPLETE
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    Plug 'mhinz/vim-signify'              " GIT
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
  set keymap=russian-jcukenwin
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

  if exists("g:editor")
    set nobackup
    set noswapfile
  endif
  " }}}

  " --------------------------------------------------------------------------
  " bindings {{{

  "leader space
  let g:mapleader = ' '
  map <space> <NOP>
  snoremap <c-space> <space>

  "movement in insert mode
  inoremap <m-h> <left>
  inoremap <m-l> <right>
  inoremap <m-j> <down>
  inoremap <m-k> <up>

  "vim
  nnoremap <leader>vs :Startify<CR>
  nnoremap <leader>vr :source ~/.config/nvim/init.vim<CR>

  "clipboard copy
  nmap <leader>y "+y
  xmap <leader>y "+y

  "primary copy
  nmap <leader>Y "*y
  xmap <leader>Y "*y

  "windows switching
  nnoremap <silent> <leader>h :call LoadWindow()<CR>

  "tab managment
  nnoremap <silent> <leader>te :tabnew<CR>
  nnoremap <silent> <leader>tn :tabnew +Startify<CR>
  nnoremap <silent> <leader>t6 :buffer # \| tabnew +buffer #<CR>
  nnoremap <silent> <leader>tq :tabclose<CR>
  nnoremap <silent> <leader>tf :tabfirst<CR>
  nnoremap <silent> <leader>tl :tablast<CR>
  nnoremap <silent> <leader>t, :-tabmove<CR>
  nnoremap <silent> <leader>t. :+tabmove<CR>

  "misc
  set pastetoggle=<F8>
  map s <NOP>
  nnoremap S <NOP>
  map m <NOP>
  map q <NOP>
  nnoremap <leader>2 q
  inoremap <M-i> <C-^>

  command! FilePath echo(expand("%:p"))

  "swap ' and `
  nnoremap ' `
  nnoremap ` '
  nnoremap * g*
  nnoremap g* *
  nnoremap # g#
  nnoremap g# #

  "useful binds
  vnoremap // y/<C-R>"<CR>
  nnoremap <leader>w <C-w>
  nnoremap Y y$
  nnoremap _ <esc>:w<CR>
  nnoremap <leader>k :tab Man<CR>

  if exists("g:editor")
    nnoremap z ZZ
  endif
  " }}}

  " --------------------------------------------------------------------------
  " autocomands {{{

  "clear highlight function autoloads
  augroup SetHighlightFunctionGroup
    autocmd!
  augroup END

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

  "remap q in Man page
  augroup ManPageQuit
    autocmd!
    autocmd FileType man nunmap <buffer> q
    autocmd FileType man map <buffer> q <Plug>(easymotion-lineanywhere)
    autocmd FileType man nnoremap <buffer> z :vnew \| bd # \| :q<CR>
  augroup END

  "set engligsh language when leave insert mode
  augroup LeaveInsertLanguage
    autocmd!
    autocmd InsertLeave * set iminsert=0
  augroup END

  " setup default toc (gO) height
  augroup SetupDefaultTocHeight
    autocmd!
    autocmd FileType qf :res 15<CR>
  augroup END


  "}}}

endfunction
" }}}
" ============================================================================

" ============================================================================
" Configure View {{{
function! s:ConfigureView()
  " --------------------------------------------------------------------------
  " view options
  set termguicolors
  set background=dark

  " --------------------------------------------------------------------------
  " favorite sets {{{

  let g:airline_theme='onedark'
  "let g:airline_theme='behelit'
  "let g:airline_theme='wombat'
  "let g:airline_theme='hybrid'
  "let g:airline_theme='ayu_mirage'

  colorscheme lucid
  "colorscheme one
  "colorscheme deus
  "colorscheme wombat256mod
  "colorscheme apprentice
  "colorscheme space-vim-dark
  "colorscheme minimalist
  "colorscheme molokai
  "colorscheme dracula

  " }}}

  " --------------------------------------------------------------------------
  " highlight colors {{{

  "Terminal colors
  let g:terminal_color_0  = "#17121e"
  let g:terminal_color_1  = "#ff2d5e"
  let g:terminal_color_2  = "#3fe097"
  let g:terminal_color_3  = "#fdf2a2"
  let g:terminal_color_4  = "#BD93F9"
  let g:terminal_color_5  = "#db0088"
  let g:terminal_color_6  = "#8BE9FD"
  let g:terminal_color_7  = "#e4e0ed"
  let g:terminal_color_8  = "#343439"
  let g:terminal_color_9  = "#FF6E67"
  let g:terminal_color_10 = "#00fa90"
  let g:terminal_color_11 = "#F4F99D"
  let g:terminal_color_12 = "#CAA9FA"
  let g:terminal_color_13 = "#FF92D0"
  let g:terminal_color_14 = "#61afef"
  let g:terminal_color_15 = "#ffffff"
  let g:terminal_color_16 = "#222222"
  let g:terminal_color_17 = "#777777"

  "CursorLine
  call s:SetHighlight("CursorLine",   { 'bg': '#232323'})
  call s:SetHighlight("CursorLineNr", { 'mode': 'bold', 'fg': '#7bc992', 'bg': '#191919'})

  "Msg
  call s:SetHighlight("ErrorMsg",     { 'mode': 'bold', 'bg': '#000000', 'fg': '#ff5555'})
  call s:SetHighlight("WarningMsg",   { 'mode': 'bold', 'bg': '#101010', 'fg': '#ff79c6'})

  "Pmenu
  call s:SetHighlight("Pmenu",        { 'bg': '#41495B', 'fg': '7bc992'})
  call s:SetHighlight("PmenuSel",     { 'bg': '#4B536C', 'fg': '#55ff88'})
  call s:SetHighlight("PmenuSbar",     { 'bg': 'black', 'fg': '#55ff88'})

  "Diffs
  call s:SetHighlight("DiffAdd",      { 'fg': '#55ff55'})
  call s:SetHighlight("DiffDelete",   { 'fg': '#ff5555'})
  call s:SetHighlight("DiffChange",   { 'fg': '#ff9955'})

  "Signs
  call s:SetHighlight('ErrorColor',       {'bg': '#101010', 'fg': '#f43753'})
  call s:SetHighlight('WarningColor',     {'bg': '#101010', 'fg': '#f4f453'})
  call s:SetHighlight('InfoColor', {'bg': '#101010', 'fg': '#67f473'})
  call s:SetHighlight('HintColor',        {'bg': '#101010', 'fg': '#f484f4'})

  "Folded
  call s:SetHighlight("Folded",       { 'bg': '#302737'})

  "Left column
  call s:SetHighlight("ColorColumn",       { 'bg': '#232323'})
  call s:SetHighlight("VertSplit",       { 'bg': '#3E4550'})

  "Coc highlight
  call s:SetHighlight("CocHighlightText", { 'bg': '#555555', 'fg': '#ffffff'})
  call s:SetHighlight("CocHighlightRead", { 'bg': '#555555', 'fg': '#60ff53'})
  call s:SetHighlight("CocHighlightWrite", { 'bg': '#555555', 'fg': '#f484f4'})

  hi! link CocErrorHighlight   ErrorColor
  hi! link CocWarningHighlight WarningColor
  hi! link CocInfoHighlight    InfoColor
  hi! link CocHintHighlight    HintColor

  hi! link CocErrorSign        ErrorColor
  hi! link CocWarningSign      WarningColor
  hi! link CocInfoSign         InfoColor
  hi! link CocHintSign         HintColor

  call s:SetHighlight("CocErrorLine", {'bg': '#151515'})
  call s:SetHighlight("CocWarningLine", {'bg': '#151515'})
  call s:SetHighlight("CocInfoLine", {'bg': '#151515'})
  call s:SetHighlight("CocHintLine", {'bg': '#151515'})
  call s:SetHighlight("CocCodeLens", {'fg': '#505050'})

  "doc string / doc msg / signature
  call s:SetHighlight("StatusLine", {'bg': '#383C49', 'fg': '#00fa90'})
  call s:SetHighlight("CocFloating", {'bg': '#383C49', 'fg': '#00fa90'})
  call s:SetHighlight("WildMenu", {'bg': '#E8E492', 'fg': '#383C49'})
  " }}}

endfunction
" }}}
" ============================================================================

" ============================================================================
" Common Plugins Configuration {{{

function! s:ConfigureCommonPlugins()

  " **************************************************************************
  " UI ENCHANTMENTS

  " --------------------------------------------------------------------------
  " devicons
  let g:WebDevIconsNerdTreeGitPluginForceVAlign = 0
  let g:WebDevIconsUnicodeDecorateFolderNodes = 1
  let g:DevIconsEnableFoldersOpenClose = 1
  let g:DevIconsEnableFolderExtensionPatternMatching = 1

  " --------------------------------------------------------------------------
  " airline
  let g:airline#extensions#disable_rtp_load = 1
  let g:airline_extensions = ['tabline', 'branch', 'quickfix', 'tagbar', 'gutentags', 'undotree', 'coc']
  if exists("g:editor")
    let g:airline_extensions = []
  endif

  let g:airline_highlighting_cache = 1
  let g:airline_inactive_collapse = 0
  let g:airline_powerline_fonts = 1

  let g:airline#extensions#ctrlp#color_template = 'visual'
  let g:airline#extensions#ctrlp#show_adjacent_modes = 0

  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#show_buffers = 0
  let g:airline#extensions#tabline#show_tabs = 1
  let g:airline#extensions#tabline#show_splits = 0
  let g:airline#extensions#tabline#show_close_button = 0
  let g:airline#extensions#tabline#tab_nr_type = 1
  let g:airline#extensions#tabline#fnamemod = ':t'
  "let g:airline#extensions#tabline#tab_min_count = 2

  function! AirlineInit()
    let g:airline_section_b = airline#section#create(['branch'])
    let g:airline_section_c = '%t%m'
    let g:airline_section_z = '%#__accent_bold#%p%% %l/%L%#__restore__#'
  endfunction
  augroup AAInit
    autocmd!
    autocmd User AirlineAfterInit call AirlineInit()
  augroup END


  " **************************************************************************
  " WINDOW-BASED FEATURES

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
        \ {'ct': '~/configuration/configs/terminal/termite'},
        \ {'cc': '~/configuration/configs/desktop/compton.conf'},
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

  " --------------------------------------------------------------------------
  " tagbar
  let g:tagbar_width = 30
  let g:tagbar_zoomwidth = 100
  let g:tagbar_hide_nonpublic = 1
  let g:tagbar_silent = 1
  let g:tagbar_map_showproto = "t" "remap showproto from <Space> to t
  let g:tagbar_autoshowtag = 1
  let g:tagbar_autofocus = 0
  nnoremap <silent> <F2> :TagbarToggle<CR>
  nnoremap <silent> <F14> :call SwitchWindowTo("__Tagbar__.*")<CR>

  " --------------------------------------------------------------------------
  " undotree
  nnoremap <silent> <F4> :UndotreeToggle<CR>
  nnoremap <silent> <F16> :call SwitchWindowTo("undotree_*")<CR>
  let g:undotree_CustomUndotreeCmd  = 'topleft vertical 30 new'
  let g:undotree_CustomDiffpanelCmd = 'botright 7 new'
  let g:undotree_RelativeTimestamp = 1
  let g:undotree_ShortIndicators = 1
  let g:undotree_HelpLine = 0

  " --------------------------------------------------------------------------
  " nerdtree
  let g:NERDTreeStatusline = 'Nerdtree'
  let g:NERDTreeMapOpenSplit = 's'
  let g:NERDTreeMapPreviewSplit = 'gs'
  let g:NERDTreeMapOpenVSplit = 'v'
  let g:NERDTreeMapPreviewVSplit = 'gv'
  let g:NERDTreeMapMenu = 'a'
  let g:NERDTreeWinSize = '29'

  nnoremap <silent> <F3> :call NerdtreeToggle()<CR>
  nnoremap <silent> <F15> :call SwitchWindowTo("NERD_tree_*")<CR>
  nnoremap <silent> <leader>no :call NerdtreeToggle()<CR>
  nnoremap <silent> <leader>nt :call SwitchWindowTo("NERD_tree_*")<CR>
  nnoremap <silent> <leader>nr :NERDTreeRefreshRoot<CR>
  nnoremap <silent> <leader>nf :NERDTreeFind<CR>
  nnoremap <silent> <leader>nw :NERDTreeCWD<CR>

  "my theme fix
  augroup SetHighlightFunctionGroup
    autocmd ColorScheme * highlight link NERDTreeDir Directory
  augroup END


  " **************************************************************************
  " MOTIONS

  " --------------------------------------------------------------------------
  " easymotion
  let g:EasyMotion_do_mapping = 0
  let g:EasyMotion_smartcase = 1
  let g:EasyMotion_use_smartsign_us = 1
  let g:EasyMotion_use_upper = 1
  let g:EasyMotion_keys = 'ASDGHKLQWERTYUIOPZXCVBNMFJ;'
  let g:EasyMotion_space_jump_first = 1

  map q <Plug>(easymotion-lineanywhere)

  nmap ss <Plug>(easymotion-overwin-f2)
  omap ss <Plug>(easymotion-s2)
  xmap ss <Plug>(easymotion-s2)
  map \ <Plug>(easymotion-sn)
  map sf <Plug>(easymotion-f)
  map sF <Plug>(easymotion-F)
  map st <Plug>(easymotion-t)
  map sT <Plug>(easymotion-T)
  map sw <Plug>(easymotion-w)
  map sW <Plug>(easymotion-W)
  map sb <Plug>(easymotion-b)
  map sB <Plug>(easymotion-B)
  map se <Plug>(easymotion-e)
  map sE <Plug>(easymotion-E)
  map sg <Plug>(easymotion-ge)
  map sG <Plug>(easymotion-gE)

  map sj <Plug>(easymotion-j)
  map sk <Plug>(easymotion-k)
  map sJ <Plug>(easymotion-eol-j)
  map sK <Plug>(easymotion-eol-k)
  nmap sl <Plug>(easymotion-overwin-line)
  omap sl <Plug>(easymotion-bd-jk)
  xmap sl <Plug>(easymotion-bd-jk)
  nmap so <Plug>(easymotion-overwin-w)
  omap so <Plug>(easymotion-bd-w)
  xmap so <Plug>(easymotion-bd-w)
  "nmap S <Plug>(easymotion-overwin-f)
  omap sO <Plug>(easymotion-bd-f)
  xmap sO <Plug>(easymotion-bd-f)
  map sn <Plug>(easymotion-next)
  map sp <Plug>(easymotion-prev)
  map s/ <Plug>(easymotion-bd-n)
  map sr <Plug>(easymotion-repeat)

  " --------------------------------------------------------------------------
  " comfortable-motion
  let g:comfortable_motion_no_default_key_mappings = 1
  let g:comfortable_motion_interval = 1000.0 / 60

  let g:comfortable_motion_friction = 80.0
  let g:comfortable_motion_air_drag = 6.5

  let g:cm_impulse = 4

  nnoremap <silent> <C-e> :call comfortable_motion#flick(g:cm_impulse * winheight(0) *  0.3 )<CR>
  nnoremap <silent> <C-y> :call comfortable_motion#flick(g:cm_impulse * winheight(0) * -0.3 )<CR>
  nnoremap <silent> <C-d> :call comfortable_motion#flick(g:cm_impulse * winheight(0) *    1 )<CR>
  nnoremap <silent> <C-u> :call comfortable_motion#flick(g:cm_impulse * winheight(0) *   -1 )<CR>
  nnoremap <silent> <C-f> :call comfortable_motion#flick(g:cm_impulse * winheight(0) *  1.8 )<CR>
  nnoremap <silent> <C-b> :call comfortable_motion#flick(g:cm_impulse * winheight(0) * -1.8 )<CR>

  " --------------------------------------------------------------------------
  " wordmotion
  let g:wordmotion_mappings = {
        \ 'w'         :'mw',
        \ 'b'         :'mb',
        \ 'e'         :'me',
        \ 'ge'        :'mge',
        \ 'aw'        :'amw',
        \ 'iw'        :'imw',
        \ '<C-R><C-W>':'<C-R><C-W>'
        \ }

  " **************************************************************************
  " EDITORS

  " --------------------------------------------------------------------------
  " nerdcommenter
  let g:NERDRemoveExtraSpaces = 1
  let g:NERDTrimTrailingWhitespace = 1
  let g:NERDCompactSexyComs = 1
  let g:NERDToggleCheckAllLines = 1

  " --------------------------------------------------------------------------
  " easy-align
  nmap ga <Plug>(EasyAlign)
  xmap ga <Plug>(EasyAlign)

  nmap gl <Plug>(LiveEasyAlign)
  xmap n <Plug>(LiveEasyAlign)

  " --------------------------------------------------------------------------
  " auto-pairs
  let g:AutoPairsShortcutJump = '<M-q>'

  " --------------------------------------------------------------------------
  " sideways
  let b:sideways_skip_syntax = []
  nnoremap <silent> <Leader>, :SidewaysLeft<cr>
  nnoremap <silent> <Leader>. :SidewaysRight<cr>

  omap aa <Plug>SidewaysArgumentTextobjA
  xmap aa <Plug>SidewaysArgumentTextobjA
  omap ia <Plug>SidewaysArgumentTextobjI
  xmap ia <Plug>SidewaysArgumentTextobjI

  " --------------------------------------------------------------------------
  " exchange
  let g:exchange_no_mappings = 1
  xmap x <Plug>(Exchange)
  nmap cx <Plug>(Exchange)
  nmap cxc <Plug>(ExchangeClear)
  nmap cxl <Plug>(ExchangeLine)

  " --------------------------------------------------------------------------
  " niceblock
  let g:niceblock_no_default_key_mappings = 1
  xmap gI <Plug>(niceblock-I)
  xmap gi <Plug>(niceblock-gI)
  xmap gA <Plug>(niceblock-A)

  " --------------------------------------------------------------------------
  " splitjoin
  let g:splitjoin_join_mapping = 'gj'
  let g:splitjoin_split_mapping = 'gk'


  " **************************************************************************
  "TEXT OBJECT

  " wildfire
  let g:wildfire_objects = ["i'", 'i"', "i)", "i]", "i}", "ip", "it", "i>"]

  " textobj indent
  let g:textobj_indent_no_default_key_mappings = 1
  xmap gn <Plug>(textobj-indent-i)
  xmap gN <Plug>(textobj-indent-a)
  xmap gc <Plug>(textobj-indent-same-i)
  xmap gC <Plug>(textobj-indent-same-a)

endfunction
" }}}
" ============================================================================

" ============================================================================
" Feature Plugins Configuration {{{

function! s:ConfigureFeaturePlugins()
  " --------------------------------------------------------------------------
  " markdown preview
  let g:mkdp_auto_close = 0

  " --------------------------------------------------------------------------
  " terminal

  tnoremap <silent> <C-o> <C-\><C-n>

  " toggle
  nnoremap <silent> <F1> :call TerminalToggle()<CR>
  tnoremap <silent> <F1> <C-\><C-n>:call TerminalToggle()<CR>
  nnoremap <silent> <F13> :call SwitchWindowTo("Terminal")<CR>
  tnoremap <silent> <F13> <C-\><C-n>:call SwitchWindowTo("Terminal")<CR>

  "insert mode in terminal by default
  augroup TerminalInsertMode
    autocmd!
    "autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
    autocmd BufWinEnter,WinEnter Terminal startinsert
    autocmd BufLeave Terminal stopinsert
  augroup END


  " --------------------------------------------------------------------------
  " autoformat
  noremap <Leader>j :Autoformat<CR>

  " --------------------------------------------------------------------------
  " ctrlsf
  let g:ctrlsf_auto_focus = {"at" : "start"}
  let g:ctrlsf_context = '-A 5 -B 2'
  "let g:ctrlsf_default_root = 'project+fw'
  "let g:ctrlsf_populate_qflist = 1
  let g:ctrlsf_default_view_mode = 'normal'
  let g:ctrlsf_position = 'bottom'
  "let g:ctrlsf_position = 'left'
  let g:ctrlsf_winsize = '70%'
  let g:ctrlsf_indent = 2
  let g:ctrlsf_mapping = {
        \ "split"   : "<C-s>",
        \ "vsplit"  : "<C-v>",
        \ }

  nmap <Leader>i <Plug>CtrlSFCCwordExec
  nmap <Leader>I <Plug>CtrlSFCwordExec
  vmap <Leader>i <Plug>CtrlSFVwordExec

  " --------------------------------------------------------------------------
  " gutentags
  let g:gutentags_add_default_project_roots = 0
  let g:gutentags_project_root              = ['.git', '.gutMark']
  let g:gutentags_cache_dir                 = '~/.local/share/nvim/tags'
  let g:gutentags_exclude_project_root      = ['/usr']
  let g:gutentags_file_list_command         = 'fd --type file'

  " --------------------------------------------------------------------------
  " notes
  let g:notes_directories = ['~/.local/share/nvim/notes']
  let g:notes_title_sync = 'rename_file'

  " --------------------------------------------------------------------------
  " rooter
  let g:rooter_silent_chdir = 1
  let g:rooter_resolve_links = 1
  let g:rooter_patterns = ['.git/', '.git', '_darcs/', '.hg/', '.bzr/', '.svn/']

  " --------------------------------------------------------------------------
  " limelight
  let g:limelight_conceal_guifg = '#446666'
  let g:limelight_paragraph_span = 2
  nnoremap <Leader>vl :Limelight!!<CR>

  " --------------------------------------------------------------------------
  " peekaboo
  let g:peekaboo_window = "vert bo 50new"

  " --------------------------------------------------------------------------
  " zoomwintab
  nnoremap <Leader>wo :ZoomWinTabToggle<CR>

  " --------------------------------------------------------------------------
  " open-browser
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)

  " --------------------------------------------------------------------------
  " signature
  call s:SetHighlight('MySignatureMarkText',   { 'fg': '#b895ff'})
  call s:SetHighlight('MySignatureMarkerText',   { 'fg': '#ff4a33'})
  let g:SignatureMarkTextHL = 'MySignatureMarkText'
  let g:SignatureMarkerTextHL = 'MySignatureMarkerText'
  let g:SignatureMap = {
        \ 'Leader'             :  "<Leader>m",
        \ 'DeleteMark'         :  "d<Leader>m",
        \ 'ListBufferMarks'    :  "<Leader>m/",
        \ 'ListBufferMarkers'  :  "<Leader>m?",
        \ 'GotoNextMarker'     :  "m>",
        \ 'GotoPrevMarker'     :  "m<",
        \ 'GotoNextMarkerAny'  :  "m]",
        \ 'GotoPrevMarkerAny'  :  "m["
        \ }

  " --------------------------------------------------------------------------
  " ultisnips
  let g:UltiSnipsUsePythonVersion = 3
  let g:UltiSnipsEditSplit = 'normal'
  let g:UltiSnipsSnippetDirectories = [expand("~/").'.local/share/nvim/UltiSnips']
  "let g:UltiSnipsSnippetDirectories = ['/home/vlad/.local/share/nvim/UltiSnips']
  let g:UltiSnipsEnableSnipMate = 0

  let g:UltiSnipsListSnippets = '<M-t>'
  let g:UltiSnipsExpandTrigger = '<c-j>'
  let g:UltiSnipsJumpForwardTrigger = '<c-j>'
  let g:UltiSnipsJumpBackwardTrigger = '<c-k>'

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
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-s': 'split',
        \ 'ctrl-v': 'vsplit' }
  let g:fzf_layout = { 'down': '30%' }
  let g:fzf_history_dir = '~/.local/share/fzf-history'
  let g:fzf_command_prefix='Fzf'

  "autoclose statusline
  augroup CustomFzfView
    autocmd!
    autocmd  FileType fzf set laststatus=0 noshowmode relativenumber!
    autocmd  FileType fzf autocmd BufLeave <buffer> set laststatus=2 showmode relativenumber
  augroup END
  " }}}

  " highlights {{{
  let g:fzf_colors =
        \ { 'fg'      : ['fg', 'FzfFg'      ] ,
        \ 'bg'      : ['fg', 'FzfBg'      ] ,
        \ 'hl'      : ['fg', 'FzfHl'      ] ,
        \ 'fg+'     : ['bg', 'FzfFg'      ] ,
        \ 'bg+'     : ['bg', 'FzfBg'      ] ,
        \ 'hl+'     : ['bg', 'FzfHl'      ] ,
        \ 'info'    : ['fg', 'FzfInfo'    ] ,
        \ 'border'  : ['fg', 'FzfBorder'  ] ,
        \ 'prompt'  : ['fg', 'FzfPrompt'  ] ,
        \ 'pointer' : ['fg', 'FzfPointer' ] ,
        \ 'marker'  : ['fg', 'FzfMarker'  ] ,
        \ 'spinner' : ['fg', 'FzfSpiner'  ] ,
        \ 'header'  : ['fg', 'FzfHeader'  ] }
  call s:SetHighlight('FzfFg', {'fg': '#3fc997', 'bg': '#00ffff'})
  call s:SetHighlight('FzfBg', {'fg': '#000000', 'bg': '#161616'})
  call s:SetHighlight('FzfHl', {'fg': '#db0088', 'bg': '#ff0000'})

  call s:SetHighlight('FzfInfo'   , {'fg': '#d0ffc3'})
  call s:SetHighlight('FzfBorder' , {'fg': '#ffffff'})
  call s:SetHighlight('FzfPrompt' , {'fg': '#b3e4eb'})
  call s:SetHighlight('FzfPointer', {'fg': '#00ffff'})
  call s:SetHighlight('FzfMarker' , {'fg': '#ff0000'})
  call s:SetHighlight('FzfSpiner' , {'fg': '#d0ffc3'})
  call s:SetHighlight('FzfHeader' , {'fg': '#ffffff'})
  " }}}

  " bindings {{{
  nmap <m-m> <plug>(fzf-maps-n)
  xmap <m-m> <plug>(fzf-maps-x)
  omap <m-m> <plug>(fzf-maps-o)
  imap <m-m> <plug>(fzf-maps-i)

  inoremap <expr> <c-f>p fzf#vim#complete#path("fd --no-ignore --hidden --type directory")
  inoremap <expr> <c-f>f fzf#vim#complete#path("fd --no-ignore --hidden --type file")
  imap <c-f>l <plug>(fzf-complete-line)
  imap <c-f>b <plug>(fzf-complete-buffer-line)

  "open file
  nnoremap <Leader>of :FzfFiles<CR>
  nnoremap <silent> <expr> <leader>od ":FzfFiles ".(expand('%:p:h'))."\<CR>"
  nnoremap <leader>ov :FzfFiles ~/.local/share/nvim<CR>
  nnoremap <leader>og :FzfGFiles<CR>
  nnoremap <leader>oG :FzfGFiles?<CR>| "changed
  nnoremap <leader>ob :FzfBuffers<CR>
  nnoremap <leader>ol :FzfLines<CR>
  nnoremap <leader>ot :FzfTags<CR>
  nnoremap <leader>oz :FzfMarks<CR>
  nnoremap <leader>ow :FzfWindows<CR>
  nnoremap <leader>om :FzfHistory<CR>| "mru
  nnoremap <leader>oc :FzfCommits<CR>
  nnoremap <leader>oC :FzfBCommits<CR>
  "buffer local select
  nnoremap <leader>bl :FzfBLines<CR>
  nnoremap <leader>bt :FzfBTags<CR>
  "select other
  nnoremap <leader>st :FzfColors<CR>| "theme
  nnoremap <leader>s: :FzfHistory:<CR>
  nnoremap <leader>s/ :FzfHistory/<CR>
  nnoremap <leader>ss :FzfSnippets<CR>
  nnoremap <leader>sc :FzfCommands<CR>
  nnoremap <leader>sh :FzfHelptags<CR>
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
  nnoremap <silent> <leader>vc :CocRestart<CR>
  nnoremap <silent> <leader>vC :CocDisable<CR>

  " trigger complete
  inoremap <silent><expr> <C-n>
        \ pumvisible() ? "\<C-n>" :
        \ coc#refresh()
  inoremap <silent><expr> <C-p>
        \ pumvisible() ? "\<C-p>" :
        \ coc#refresh()

  " confirm completion on ctrl-m
	inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

  " remap keys for go to
  nmap <silent> <leader>ft <Plug>(coc-type-definition)
  nmap <silent> <leader>fi <Plug>(coc-implementation)
  nmap <silent> <leader>fD <Plug>(coc-declaration)
  nmap <silent> <leader>fd <Plug>(coc-definition)
  nmap <silent> <leader>fr <Plug>(coc-references)
  nmap <silent> <leader>fn <Plug>(coc-diagnostic-next)
  nmap <silent> <leader>fp <Plug>(coc-diagnostic-prev)
  " doesn't work properly
  nmap <silent> <leader>fl <Plug>(coc-openlink)

  " do something
  nmap <silent> <leader>ff <Plug>(coc-fix-current)
  nmap <silent> <leader>fF <Plug>(coc-format)
  xmap <silent> <leader>ff <Plug>(coc-format-selected)
  xmap <silent> <leader>fg <Plug>(coc-codeaction-selected)
  nmap <silent> <leader>fg <Plug>(coc-codeaction)
  nmap <silent> <leader>fR <Plug>(coc-rename)

  " CocLists
  nnoremap <silent> <leader>fz :<C-u>CocList --normal diagnostics<cr>
  nnoremap <silent> <leader>fL :<C-u>CocList links<cr>
  nnoremap <silent> <leader>fs :<C-u>CocList -A outline<cr>
  nnoremap <silent> <leader>fS :<C-u>CocList symbols<cr>

  " get info
  nnoremap <silent> S :call CocAction('showSignatureHelp')<CR>
  nnoremap <silent> K :call <SID>show_documentation()<CR>
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
        \ "coc-json",
        \ "coc-ultisnips",
        \ "coc-html",
        \ "coc-css",
        \ "coc-yaml",
        \ "coc-python",
        \ "coc-highlight",
        \ "coc-git",
        \ "coc-yank",
        \ "coc-vimlsp"
        \ ]
  nnoremap <silent> <leader>fy :<C-u>CocList yank<cr>
  nnoremap <silent> <space>g  :<C-u>CocList --normal gstatus<CR>

  " --------------------------------------------------------------------------
  "signify
  let g:signify_vcs_list = ['git']
  let g:signify_sign_delete = '-'

  nmap mj <plug>(signify-next-hunk)
  nmap mk <plug>(signify-prev-hunk)

  augroup SignifyRefresh "update without saving
    autocmd!
    autocmd CursorHold * SignifyRefresh
    autocmd CursorHoldI * SignifyRefresh
    autocmd FocusGained * SignifyRefresh
  augroup END
endfunction

" }}}
" ============================================================================

" ============================================================================
" Util Functions {{{

" ----------------------------------------------------------------------------
" Highlight
function! s:SetHighlight(hlName, hl)
  let l:mode = get(a:hl, 'mode', 'none')
  let l:fg = get(a:hl, 'fg', 'none')
  let l:bg = get(a:hl, 'bg', 'none')
  execute "highlight ".a:hlName." gui=".l:mode." guifg=".l:fg." guibg=".l:bg
  augroup SetHighlightFunctionGroup
    execute "autocmd ColorScheme * highlight ".a:hlName." gui=".l:mode." guifg=".l:fg." guibg=".l:bg
  augroup END
endfunction

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
" Terminal toggle

function! TerminalToggle()
  let l:terminal_buffer = bufnr('Terminal')
  if terminal_buffer == -1
    " Save splits pos and size
    let t:terminal_winrestcmd = winrestcmd()
    " Create terminal buffer
    execute "bot 35new"
    terminal
    setlocal bufhidden=hide
    setlocal nobuflisted
    setlocal winfixwidth
    setlocal winfixheight
    setlocal filetype=terminal
    setlocal scrolloff=0
    file Terminal
    startinsert
    return
  endif

  let l:terminal_window = bufwinnr(terminal_buffer)
  if terminal_window == -1
    " Save splits pos and size
    let t:terminal_winrestcmd = winrestcmd()
    " Create terminal window
    execute "bot 35new +buffer".terminal_buffer
    setlocal winfixwidth
    setlocal winfixheight
  else
    " Restore focuse
    if bufwinnr('%') == l:terminal_window
      call LoadWindow()
    endif
    " Close window
    execute "close ".terminal_window
    " Restore splits pos and size
    if exists("t:terminal_winrestcmd")
      execute t:terminal_winrestcmd
    endif
  endif
endfunction

" ----------------------------------------------------------------------------
" nerdtree toggle

" NERDTreeToggle renumber windows
function! NerdtreeToggle()
  let l:buffer_number = winbufnr(t:saved_window)
  NERDTreeToggle
  let t:saved_window = bufwinnr(l:buffer_number)
  call LoadWindow()
endfunction
" }}}
" ============================================================================

call s:LoadPlugins()
call s:BasicSettings()
call s:ConfigureCommonPlugins()
if !exists("g:editor")
  call s:ConfigureFeaturePlugins()
endif
call s:ConfigureView()