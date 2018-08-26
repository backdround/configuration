" ============================================================================
" Load Plugins {{{

function! s:LoadPlugins()
  call plug#begin('~/.local/share/nvim/plugged')

  "HIGHLIGHTS
  Plug 'rafi/awesome-vim-colorschemes'
  Plug 'PotatoesMaster/i3-vim-syntax'
  Plug 'tmux-plugins/vim-tmux'
  Plug 'octol/vim-cpp-enhanced-highlight'
  "Plug 'ap/vim-css-color'

  "YCM
  Plug 'Valloric/YouCompleteMe'
  Plug 'Valloric/ListToggle'

  "STATUSLINE
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  "GIT
  Plug 'mhinz/vim-signify'
  Plug 'tpope/vim-fugitive'

  "NERDTREE
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  "Plug 'jistr/vim-nerdtree-tabs'

  "FZF
  Plug '/usr/share/vim/vimfiles' "fzf installed by pacman
  Plug 'junegunn/fzf.vim'

  "TAGS
  Plug 'majutsushi/tagbar'
  Plug 'ludovicchabant/vim-gutentags'

  "SNIPPETS
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'

  "SOME UI ENCHANTMENTS
  Plug 'ryanoasis/vim-devicons'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'blueyed/vim-diminactive'
  Plug 'mhinz/vim-startify'

  "EDITORS
  Plug 'scrooloose/nerdcommenter'
  Plug 'junegunn/vim-easy-align'
  Plug 'tpope/vim-surround'
  Plug 'jiangmiao/auto-pairs'
  Plug 'haya14busa/incsearch.vim'
  Plug 'haya14busa/incsearch-fuzzy.vim'
  Plug 'haya14busa/incsearch-easymotion.vim'
  Plug 'easymotion/vim-easymotion'
  Plug 'tpope/vim-repeat'
  Plug 'terryma/vim-multiple-cursors'

  "FUN
  Plug 'junegunn/limelight.vim'
  Plug 'junegunn/vim-peekaboo'

  call plug#end()
endfunction
" }}}
" ============================================================================

" ============================================================================
" Basic Settings {{{

function! s:BasicSettings()
  " --------------------------------------------------------------------------
  " options {{{

  "left colomn
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
  set scrolloff=10
  set termencoding=utf8
  set showcmd
  set ch=1
  set mouse=a
  set mousehide
  set nowrap
  set showmatch
  set backspace=indent,eol,start
  set history=200
  set list
  set listchars=tab:\ \ ,trail:·
  set fillchars=fold:\ 
  set cursorline
  set nocompatible
  set backup
  set backupdir=~/.nvimbk
  set notimeout " for leader key etc
  " }}}

  " --------------------------------------------------------------------------
  " bindings {{{

  "leader space
  let g:mapleader = ' '
  nnoremap <space> <NOP>

  "movement in insert mode
  inoremap <m-h> <left>
  inoremap <m-j> <down>
  inoremap <m-k> <up>
  inoremap <m-l> <right>

  "separating sting
  nnoremap <leader>/- :call AppendCommentLine('-')<CR>
  nnoremap <leader>/= :call AppendCommentLine('=')<CR>
  nnoremap <leader>/* :call AppendCommentLine('*')<CR>

  "vim
  nnoremap <leader>vs :e ~/.config/nvim/init.vim<CR>
  nnoremap <leader>vr :source ~/.config/nvim/init.vim<CR>

  "clipboard copy
  nmap <leader>vc "+y
  xmap <leader>vc "+y

  "primary copy
  nmap <leader>vy "*y
  xmap <leader>vy "*y

  "windows switching
  nnoremap <silent> <leader>tn :call SwitchWindowTo("NERD_tree_*")<CR>
  nnoremap <silent> <leader>tt :call SwitchWindowTo("__Tagbar__.*")<CR>
  nnoremap <silent> <leader>th :call LoadWindow()<CR>

  "terminal toggle
  "nnoremap <silent> <leader>z :call TerminalToggle()<CR>
  nnoremap <silent> <leader>z :call TerminalToggle()<CR>

  "work directory
  nnoremap <leader>dc :cd %:p:h<CR>:pwd<CR>

  "misc
  set pastetoggle=<F8>
  nnoremap <silent> <leader>n :noh<CR>
  nnoremap <leader>w <C-w>

  noremap s <NOP>
  noremap S <NOP>
  nnoremap <leader>m m
  noremap m <NOP>

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

  ""auto save/loading folds {{{
  "function! ValidFolds()
  "  if &l:diff | return 0 | endif
  "  if &buftype != '' | return 0 | endif
  "  if expand('%') =~ '\[.*\]' | return 0 | endif
  "  if empty(glob(expand('%:p'))) | return 0 | endif
  "  if &modifiable == 0 | return 0 | endif
  "  if len($TEMP) && expand('%:p:h') == $TEMP | return 0 | endif
  "  if len($TMP) && expand('%:p:h') == $TMP | return 0 | endif
  "  if expand('%:p:t') == '' | return 0 | endif

  "  return 1
  "endfunction

  "augroup RememberFolds
  "  autocmd!
  "  autocmd BufWritePre,BufWinLeave ?* if ValidFolds() | silent! mkview | endif
  "  autocmd BufWinEnter ?* if ValidFolds() | silent! loadview | endif
  "augroup END
  "" so many fucking errors. may be later}}}
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
  colorscheme lucid
  "colorscheme one
  "colorscheme lucius
  "colorscheme atom

  "let g:airline_theme='hybrid'
  "colorscheme lucius
  "colorscheme deus

  "let g:airline_theme='wombat'
  "colorscheme wombat256mod
  "colorscheme apprentice

  "let g:airline_theme='behelit'
  "colorscheme space-vim-dark
  "colorscheme minimalist

  "let g:airline_theme='ayu_mirage'
  "colorscheme one
  "colorscheme molokai
  "colorscheme dracula

  "unusable but good
  "let g:airline_theme='base16_shell'
  " }}}

  " --------------------------------------------------------------------------
  " highlight colors {{{
  "CursorLine
  call s:SetHighlight("CursorLine",   { 'bg': '#232323'})
  call s:SetHighlight("CursorLineNr", { 'mode': 'bold', 'fg': '#7bc992', 'bg': '#191919'})

  "Msg
  call s:SetHighlight("ErrorMsg",     { 'mode': 'bold', 'bg': '#000000', 'fg': '#ff5555'})
  call s:SetHighlight("WarningMsg",   { 'mode': 'bold', 'bg': '#101010', 'fg': '#ff79c6'})

  "Pmenu
  call s:SetHighlight("Pmenu",        { 'bg': '#101010', 'fg': '7bc992'})
  call s:SetHighlight("PmenuSel",     { 'bg': '#ff99ff', 'fg': 'black'})

  "Diffs
  call s:SetHighlight("DiffAdd",      { 'fg': '#55ff55'})
  call s:SetHighlight("DiffDelete",   { 'fg': '#ff5555'})
  call s:SetHighlight("DiffChange",   { 'fg': '#ff9955'})

  "Folded
  call s:SetHighlight("Folded",       { 'bg': '#302737'})

  "ColorColumn
  call s:SetHighlight("ColorColumn",  { 'bg': '#16121d', 'fg': '#d4eddd'})

  "Directory
  "call s:SetHighlight("Directory",   { 'fg': '#7bc992'})
  " }}}

endfunction
" }}}
" ============================================================================

" ============================================================================
" Configure Plugins {{{

function! s:ConfigureFZF() " {{{
  " --------------------------------------------------------------------------
  " options {{{
  let $FZF_DEFAULT_OPTS = '--multi --no-mouse --inline-info'
  let $FZF_DEFAULT_COMMAND = 'fd --hidden --no-ignore --type file'

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
  " --------------------------------------------------------------------------
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
  " --------------------------------------------------------------------------
  " bindings {{{
  nmap <m-l> <plug>(fzf-maps-n)
  xmap <m-l> <plug>(fzf-maps-x)
  omap <m-l> <plug>(fzf-maps-o)
  imap <m-l> <plug>(fzf-maps-i)

  inoremap <expr> <c-f>p fzf#vim#complete#path("fd --no-ignore --hidden --type directory")
  inoremap <expr> <c-f>f fzf#vim#complete#path("fd --no-ignore --hidden --type file")
  imap <c-f>l <plug>(fzf-complete-line)
  imap <c-f>b <plug>(fzf-complete-buffer-line)

  "open file
  nnoremap <expr> <Leader>of (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":FzfFiles\<CR>"
  nnoremap <silent> <expr> <leader>od ":FzfFiles ".(expand('%:p:h'))."\<CR>"
  nnoremap <leader>ov :FzfFiles ~/.local/share/nvim<CR>
  nnoremap <leader>og :FzfGFiles<CR>
  nnoremap <leader>oc :FzfGFiles?<CR>| "changed
  nnoremap <leader>ob :FzfBuffers<CR>
  nnoremap <leader>ol :FzfLines<CR>
  nnoremap <leader>ot :FzfTags<CR>
  nnoremap <leader>oz :FzfMarks<CR>
  nnoremap <leader>ow :FzfWindows<CR>
  nnoremap <leader>om :FzfHistory<CR>| "mru
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
  "later
  "nnoremap <leader>oc :FzfCommits<CR>
  "nnoremap <leader>oC :FzfBCommits<CR>
  " }}}
endfunction " }}}

function! s:ConfigureYCM() " {{{
  " --------------------------------------------------------------------------
  " options
  let g:ycm_global_ycm_extra_conf = '~/.config/ycm/ycm_extra_conf.py'
  set completeopt-=preview
  let g:ycm_add_preview_to_completeopt = 0
  let g:ycm_always_populate_location_list = 1
  "let g:ycm_autoclose_preview_window_after_insertion = 1
  let g:lt_height = 7

  " --------------------------------------------------------------------------
  " highlights
  call s:SetHighlight('YcmErrorSign', {'mode': 'bold', 'bg': '#101010', 'fg': '#f43753'})
  call s:SetHighlight('YcmErrorLine', {'bg': '#20202d'})
  call s:SetHighlight('YcmErrorSection', {'mode': 'bold', 'bg': '#ff5555', 'fg': '#000000'})

  " --------------------------------------------------------------------------
  " bindings
  nnoremap <leader>yc :YcmForceCompileAndDiagnostics<CR>
  let g:ycm_key_invoke_completion = '<C-Space>'
  let g:ycm_key_list_stop_completion = ['<C-y>']
  let g:ycm_key_detailed_diagnostics = '<leader>yd'
  nnoremap <leader>ff :YcmCompleter FixIt<CR>
  let g:lt_location_list_toggle_map = '<leader>l'

  nnoremap <buffer> <leader>yt :YcmCompleter GetType<CR>
  nnoremap <buffer> <leader>yr :YcmCompleter ClearCompilationFlagCache<CR>

  nnoremap <buffer> <leader>gg :YcmCompleter GoTo<CR>
  nnoremap <buffer> <leader>gf :YcmCompleter GoToDefinition<CR>
  nnoremap <buffer> <leader>gc :YcmCompleter GoToDeclaration<CR>
  nnoremap <buffer> <leader>gi :YcmCompleter GoToInclude<CR>
endfunction
" }}}

function! s:ConfigureAirline() " {{{
  " --------------------------------------------------------------------------
  " options
  let g:airline#extensions#disable_rtp_load = 1
  let g:airline_extensions = ['tabline', 'branch', 'ycm', 'quickfix', 'tagbar', 'gutentags']

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

  " --------------------------------------------------------------------------
  " custom sections
  function! AirlineInit()
    let g:airline_section_b = airline#section#create(['branch'])
    let g:airline_section_c = '%t%m'
    let g:airline_section_z = '%#__accent_bold#%p%% %l/%L%#__restore__#'
  endfunction
  augroup AAInit
    autocmd!
    autocmd User AirlineAfterInit call AirlineInit()
  augroup END

endfunction
" }}}

function! s:ConfigureUltiSnips() " {{{
  let g:UltiSnipsUsePythonVersion = 3
  let g:UltiSnipsEditSplit = 'vertical'
  let g:UltiSnipsSnippetsDir ='/home/vlad/.local/share/nvim/pSnips'
  let g:UltiSnipsSnippetDirectories = ["UltiSnips", "/home/vlad/.local/share/nvim/pSnips"]

  let g:UltiSnipsListSnippets = '<nop>'
  "let g:UltiSnipsExpandTrigger = '<nop>'
  "let g:UltiSnipsJumpForwardTrigger = '<nop>'
  "let g:UltiSnipsJumpBackwardTrigger = '<nop>'
  let g:UltiSnipsExpandTrigger = '<c-j>'
  let g:UltiSnipsJumpForwardTrigger = '<c-j>'
  let g:UltiSnipsJumpBackwardTrigger = '<c-k>'


  "inoremap <c-j> <c-r>=UltiSnips#ExpandSnippetOrJump()<CR>
  "inoremap <c-j> <c-r>=UltiSnips#ExpandSnippetOrJump()<CR>
  inoremap <c-]> <c-r>=UltiSnips#ListSnippets()<CR>

  xnoremap  <c-j> :call UltiSnips#SaveLastVisualSelection()<CR>gvs
  snoremap  <c-j> <Esc>:call UltiSnips#ExpandSnippetOrJump()<CR>

endf
" }}}

function! s:ConfigureOtherPlugins() " {{{
  " --------------------------------------------------------------------------
  " nerd tree

  "NERDTREE TABS
  "let g:nerdtree_tabs_synchronize_view = 0
  "let g:nerdtree_tabs_synchronize_focus = 0
  "let g:nerdtree_tabs_focus_on_files = 1

  "NERDTREE
  let g:NERDTreeStatusline = 'NERD'
  let g:NERDTreeAutoDeleteBuffer = 1

  "nnoremap <silent> <F3> :NERDTreeMirrorToggle<CR>
  nnoremap <silent> <F3> :NERDTreeToggle<CR>

  "my theme fix
  augroup SetHighlightFunctionGroup
    autocmd ColorScheme * highlight link NERDTreeDir Directory
  augroup END

  " --------------------------------------------------------------------------
  " git

  "SIGNIFY
  let g:signify_vcs_list = ['git']
  let g:signify_sign_delete = '-'

  nmap <leader>j <plug>(signify-next-hunk)
  nmap <leader>k <plug>(signify-prev-hunk)

  "update without saving
  augroup SignifyRefresh
    autocmd!
    autocmd CursorHold * SignifyRefresh
    autocmd CursorHoldI * SignifyRefresh
    autocmd FocusGained * SignifyRefresh
  augroup END

  " --------------------------------------------------------------------------
  " tags

  " tagbar
  let g:tagbar_width = 38
  let g:tagbar_zoomwidth = 100
  let g:tagbar_hide_nonpublic = 1
  let g:tagbar_silent = 1
  let g:tagbar_map_showproto = "t"
  let g:tagbar_autoshowtag = 1
  nnoremap <silent> <F2> :TagbarToggle<CR>

  "gutentags
  let g:gutentags_exclude_project_root = ['/home/vlad']
  let g:gutentags_add_default_project_roots = 0
  let g:gutentags_project_root = ['.git', '.gutMark']
  let g:gutentags_cache_dir = '~/.local/share/nvim/tags'
  let g:gutentags_file_list_command = 'fd --hidden --no-ignore --type file'

  " --------------------------------------------------------------------------
  " ui enchantments

  "devicons
  let g:WebDevIconsNerdTreeGitPluginForceVAlign = 0
  let g:WebDevIconsUnicodeDecorateFolderNodes = 1
  let g:DevIconsEnableFoldersOpenClose = 1
  let g:DevIconsEnableFolderExtensionPatternMatching = 1

  "nerdtree highlights
  let g:NERDTreeFileExtensionHighlightFullName = 1
  let g:NERDTreeExactMatchHighlightFullName = 1
  let g:NERDTreePatternMatchHighlightFullName = 1
  let g:NERDTreeHighlightFolders = 1
  let g:NERDTreeHighlightFoldersFullName = 1

  "diminactive
  let g:diminactive_buftype_blacklist = ['nofile', 'nowrite', 'acwrite', 'quickfix']
  let g:diminactive_filetype_blacklist = []

  "startify
  let g:startify_change_to_vcs_root = 1
  let g:startify_update_oldfiles = 1
  let g:startify_fortune_use_unicode = 1
  let g:startify_padding_left = 8
  let g:startify_session_dir = '~/.local/share/nvim/sessions/'
  let g:startify_session_persistence = 1
  let g:startify_session_sort = 1

  let g:startify_bookmarks = [
        \ {'c': '~/.config/nvim/init.vim'   },
        \ {'z': '~/.zshrc'                  },
        \ {'i': '~/.config/i3/config'       },
        \ {'b': '~/.config/i3blocks/config' }
        \ ]

  let g:startify_lists = [
        \ { 'type':'files',     'header': ['MRU']            },
        \ { 'type':'dir',       'header': ['MRU '. getcwd()] },
        \ { 'type':'sessions',  'header': ['Sessions']       },
        \ { 'type':'bookmarks', 'header': ['Bookmarks']      }
        \ ]

  let g:startify_session_before_save = [
        \ 'silent! NERDTreeClose',
        \ 'silent! TagbarClose'
        \ ]

  " --------------------------------------------------------------------------
  " editors

  "nerdcommenter
  let g:NERDRemoveExtraSpaces = 1
  let g:NERDTrimTrailingWhitespace = 1
  let g:NERDCompactSexyComs = 1
  let g:NERDToggleCheckAllLines = 1

  "easy-aligm
  nmap ga <Plug>(EasyAlign)
  xmap ga <Plug>(EasyAlign)

  nmap gl <Plug>(LiveEasyAlign))
  xmap gl <Plug>(LiveEasyAlign))

  "auto-pairs
  let g:AutoPairsFlyMode = 1

  "incsearch
  set hlsearch
  let g:incsearch#auto_nohlsearch = 1

  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  map n  <Plug>(incsearch-nohl-n)
  map N  <Plug>(incsearch-nohl-N)
  map *  <Plug>(incsearch-nohl-*)
  map #  <Plug>(incsearch-nohl-#)
  map g* <Plug>(incsearch-nohl-g*)
  map g# <Plug>(incsearch-nohl-g#)

  "incsearch fuzzy
  map z/ <Plug>(incsearch-fuzzy-/)
  map z? <Plug>(incsearch-fuzzy-?)
  map zg/ <Plug>(incsearch-fuzzy-stay)

  function! s:config_easyfuzzymotion(...) abort
    return extend(copy({
          \   'converters': [incsearch#config#fuzzy#converter()],
          \   'modules': [incsearch#config#easymotion#module()],
          \   'keymap': {"\<CR>": '<Over>(easymotion)'},
          \   'is_expr': 0,
          \   'is_stay': 1
          \ }), get(a:, 1, {}))
  endfunction
  noremap <silent><expr> <Leader>/ incsearch#go(<SID>config_easyfuzzymotion())

  "easymotion
  let g:EasyMotion_do_mapping = 0
  let g:EasyMotion_smartcase = 1
  let g:EasyMotion_use_smartsign_us = 1
  let g:EasyMotion_use_upper = 1
  let g:EasyMotion_keys = 'ASDGHKLQWERTYUIOPZXCVBNMFJ;'
  let g:EasyMotion_space_jump_first = 1

  map m <Plug>(easymotion-lineanywhere)

  nmap ss <Plug>(easymotion-overwin-f2)
  omap ss <Plug>(easymotion-s2)
  xmap ss <Plug>(easymotion-s2)
  map sS <Plug>(easymotion-sn)
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
  nmap sO <Plug>(easymotion-overwin-f)
  omap sO <Plug>(easymotion-bd-f)
  xmap sO <Plug>(easymotion-bd-f)
  map sn <Plug>(easymotion-next)
  map sp <Plug>(easymotion-prev)
  map s/ <Plug>(easymotion-bd-n)
  map sr <Plug>(easymotion-repeat)


  " --------------------------------------------------------------------------
  " other

  "cpp enhanced highlight
  let g:cpp_class_scope_highlight = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_class_decl_highlight = 1
  let g:cpp_experimental_template_highlight = 1
  let g:cpp_concepts_highlight = 1

  "limelight
  let g:limelight_conceal_guifg = '#446666'
  let g:limelight_paragraph_span = 2
  nnoremap <Leader>fl :Limelight!!<CR>

  "peekaboo
  let g:peekaboo_window = "vert bo 50new"

endfunction
" }}}

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
" Comment line
function! AppendCommentLine(placeholder)
  "line width
  let l:text_width = &textwidth> 0? &textwidth : 80

  "widths
  let l:indent_width = indent(line('.'))
  let l:comment_string_width = len(substitute(&commentstring, '%s', '', '',))
  let l:placeholder_width = l:text_width - l:indent_width - l:comment_string_width - len(' ')

  "parts
  let l:indent_part = repeat(' ', l:indent_width)
  let l:placeholder_part = repeat(a:placeholder, l:placeholder_width)

  "line
  let l:line = l:indent_part . substitute(&commentstring, '%s', ' ' . l:placeholder_part, '')
  call append(line('.'), l:line)
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
function! SaveWindow()
  let l:current_window = bufwinnr('%')
  if s:CheckNormalWindow(l:current_window)
    let t:saved_window = l:current_window
  endif
endfunction

function! LoadWindow()
  if s:CheckNormalWindow(t:saved_window)
    execute t:saved_window . "wincmd w"
    return
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

  call SaveWindow()
  execute l:window_number . "wincmd w"
endfunction

" ----------------------------------------------------------------------------
" Terminal toggle

function! TerminalToggle()
  let l:terminal_buffer = bufnr('Terminal')
  if terminal_buffer == -1
    call SaveWindow()
    execute "bot 20new"
    terminal
    setlocal bufhidden=hide
    setlocal nobuflisted
    file Terminal
    return
  endif

  let l:terminal_window = bufwinnr(terminal_buffer)
  if terminal_window == -1
    call SaveWindow()
    execute "bot 20new +buffer".terminal_buffer
  else
    call LoadWindow()
    execute "close ".terminal_window
  endif
endfunction

" }}}
" ============================================================================

call s:LoadPlugins()
call s:BasicSettings()
call s:ConfigureFZF()
call s:ConfigureYCM()
call s:ConfigureAirline()
call s:ConfigureUltiSnips()
call s:ConfigureOtherPlugins()
call s:ConfigureView()

