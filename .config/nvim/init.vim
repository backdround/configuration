" ============================================================================
" Load Plugins {{{

function! s:LoadPlugins()
  call plug#begin('~/.local/share/nvim/plugged')

  " --------------------------------------------------------------------------
  " UI ENCHANTMENTS
  Plug 'rafi/awesome-vim-colorschemes'   " COLORSCHEMES
  Plug 'ap/vim-css-color'                " CSS HIGHLIGHTE
  Plug 'sheerun/vim-polyglot'            " POLYGLOT
  Plug 'ryanoasis/vim-devicons'          " DEVICONS

  Plug 'vim-airline/vim-airline'         " AIRLINE
  Plug 'vim-airline/vim-airline-themes'

  " --------------------------------------------------------------------------
  " FEATURES
  Plug 'dyng/ctrlsf.vim'                " CTRLSF
  Plug 'ludovicchabant/vim-gutentags'   " GUTENTAGS
  Plug 'xolox/vim-notes'                " NOTES
  Plug 'airblade/vim-rooter'            " ROOTER
  Plug 'markonm/traces.vim'             " TRACES
  Plug 'tpope/vim-repeat'               " REPEAT
  Plug 'junegunn/limelight.vim'         " LIMELIGHT
  Plug 'junegunn/vim-peekaboo'          " PEEKABOO
  Plug 'troydm/zoomwintab.vim'          " ZOOM WIN TAB
  Plug 'machakann/vim-highlightedyank'  " HIGHLIGHTED YANK
  Plug 'tyru/open-browser.vim'          " OPEN BROWSER
  Plug 'kshenoy/vim-signature'          " SIGNATURE
  Plug 'Valloric/ListToggle'            " LIST TOGGLE

  Plug 'SirVer/ultisnips'               " SNIPPETS
  Plug 'honza/vim-snippets'

  Plug '/usr/share/vim/vimfiles'        " FZF (INSTALLED BY PACMAN)
  Plug 'junegunn/fzf.vim'

  Plug 'xolox/vim-misc'                 " SESSION
  Plug 'xolox/vim-session'

  "Plug 'Valloric/YouCompleteMe'        " YCM
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }

  Plug 'mhinz/vim-signify'              " GIT
  Plug 'tpope/vim-fugitive'

  " --------------------------------------------------------------------------
  " WINDOW-BASED FEATURES
  Plug 'mhinz/vim-startify'          " STARTIFY
  Plug 'majutsushi/tagbar'           " TAG BAR
  Plug 'mbbill/undotree'             " UNDOTREE

  Plug 'scrooloose/nerdtree'         " NERDTREE
  Plug 'Xuyuanp/nerdtree-git-plugin'

  " --------------------------------------------------------------------------
  " MOTIONS
  Plug 'romainl/vim-cool'              " COOL
  Plug 'easymotion/vim-easymotion'     " EASYMOTION
  Plug 'yuttie/comfortable-motion.vim' " COMFORTABLE-MOTION
  Plug 'chaoren/vim-wordmotion'        " WORDMOTION

  " --------------------------------------------------------------------------
  " EDITORS
  Plug 'scrooloose/nerdcommenter'     " NERDCOMMENTER
  Plug 'junegunn/vim-easy-align'      " EASY-ALIGN
  Plug 'tpope/vim-surround'           " SURROUND
  Plug 'jiangmiao/auto-pairs'         " AUTO-PAIRS
  Plug 'terryma/vim-multiple-cursors' " MULTIPLE-CURSORS
  Plug 'AndrewRadev/sideways.vim'     " SIDEWAYS
  Plug 'tommcdo/vim-exchange'         " EXCHANGE
  Plug 'kana/vim-niceblock'           " NICEBLOCK
  Plug 'matze/vim-move'               " MOVE
  Plug 'AndrewRadev/splitjoin.vim'    " SPLITJOIN

  " --------------------------------------------------------------------------
  "TEXT OBJECT
  Plug 'gcmt/wildfire.vim'       " WILDFIRE
  Plug 'wellle/targets.vim'      " TARGETS
  Plug 'kana/vim-textobj-user'   " TEXTOBJ USER
  Plug 'kana/vim-textobj-indent' " TEXTOBJ INDENT

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
  set noequalalways
  set sessionoptions-=buffers
  set completeopt-=preview
  " }}}

  " --------------------------------------------------------------------------
  " bindings {{{

  "leader space
  let g:mapleader = ' '
  map <space> <NOP>

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

  "terminal toggle
  nnoremap <silent> <F1> :call TerminalToggle()<CR>
  tnoremap <silent> <F1> <C-\><C-n>:call TerminalToggle()<CR>
  nnoremap <silent> <F13> :call SwitchWindowTo("Terminal")<CR>
  tnoremap <silent> <F13> <C-\><C-n>:call SwitchWindowTo("Terminal")<CR>

  "misc
  set pastetoggle=<F8>
  map s <NOP>
  nnoremap S <NOP>
  map m <NOP>
  map q <NOP>
  nnoremap <leader>2 q

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
  nnoremap ß <esc>:w<CR>

  " }}}

  " --------------------------------------------------------------------------
  " autocomands {{{

  "nobackup for pass-store
  augroup PassStoreFile
    autocmd!
    autocmd BufRead,BufNewFile /dev/shm/* set nobackup
  augroup END

  "clear highlight function autoloads
  augroup SetHighlightFunctionGroup
    autocmd!
  augroup END

  "disabling autocommenting
  augroup DisablingAutocommenting
    autocmd!
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
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
  "CursorLine
  call s:SetHighlight("CursorLine",   { 'bg': '#232323'})
  call s:SetHighlight("CursorLineNr", { 'mode': 'bold', 'fg': '#7bc992', 'bg': '#191919'})

  "Msg
  call s:SetHighlight("ErrorMsg",     { 'mode': 'bold', 'bg': '#000000', 'fg': '#ff5555'})
  call s:SetHighlight("WarningMsg",   { 'mode': 'bold', 'bg': '#101010', 'fg': '#ff79c6'})

  "Pmenu
  call s:SetHighlight("Pmenu",        { 'bg': '#103030', 'fg': '7bc992'})
  call s:SetHighlight("PmenuSel",     { 'bg': 'black', 'fg': '#55ff88'})

  "Diffs
  call s:SetHighlight("DiffAdd",      { 'fg': '#55ff55'})
  call s:SetHighlight("DiffDelete",   { 'fg': '#ff5555'})
  call s:SetHighlight("DiffChange",   { 'fg': '#ff9955'})

  "Signs
  call s:SetHighlight('ErrorSign', {'mode': 'bold', 'bg': '#101010', 'fg': '#f43753'})
  call s:SetHighlight('WarningSing', {'mode': 'bold', 'bg': '#101010', 'fg': '#f4f453'})
  call s:SetHighlight('InformationSign', {'mode': 'bold', 'bg': '#101010', 'fg': '#67f473'})
  call s:SetHighlight('HintSing', {'mode': 'bold', 'bg': '#101010', 'fg': '#f484f4'})

  "Folded
  call s:SetHighlight("Folded",       { 'bg': '#302737'})

  "Directory
  "call s:SetHighlight("Directory",   { 'fg': '#7bc992'})
  " }}}

endfunction
" }}}
" ============================================================================

" ============================================================================
" Configure Plugins {{{

function! s:ConfigurePlugins()

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
  let g:airline_extensions = ['tabline', 'branch', 'ycm', 'quickfix', 'tagbar', 'gutentags', 'undotree']

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
  " FEATURES

  " --------------------------------------------------------------------------
  " ctrlsf
  let g:ctrlsf_auto_focus = {"at" : "start"}
  let g:ctrlsf_context = '-A 5 -B 2'
  let g:ctrlsf_default_root = 'project+fw'
  let g:ctrlsf_populate_qflist = 1
  let g:ctrlsf_default_view_mode = 'normal'
  let g:ctrlsf_position = 'left'
  let g:ctrlsf_winsize = '70'
  let g:ctrlsf_indent = 2
  let g:ctrlsf_mapping = {
        \ "split"   : "<C-s>",
        \ "vsplit"  : "<C-v>",
        \ }

  nmap <Leader>i <Plug>CtrlSFCwordExec
  nmap <Leader>e <Plug>CtrlSFCCwordExec
  vmap <Leader>i <Plug>CtrlSFVwordExec

  " --------------------------------------------------------------------------
  " gutentags
  let g:gutentags_exclude_project_root = ['/home/vlad']
  let g:gutentags_add_default_project_roots = 0
  let g:gutentags_project_root = ['.git', '.gutMark']
  let g:gutentags_cache_dir = '~/.local/share/nvim/tags'
  let g:gutentags_file_list_command = 'fd --hidden --no-ignore --type file'

  " --------------------------------------------------------------------------
  " notes
  let g:notes_directories = ['~/.local/share/nvim/notes']
  let g:notes_title_sync = 'rename_file'

  " --------------------------------------------------------------------------
  " rooter
  let g:rooter_silent_chdir = 1

  " --------------------------------------------------------------------------
  " limelight
  let g:limelight_conceal_guifg = '#446666'
  let g:limelight_paragraph_span = 2
  nnoremap <Leader>fl :Limelight!!<CR>

  " --------------------------------------------------------------------------
  " peekaboo
  let g:peekaboo_window = "vert bo 50new"

  " --------------------------------------------------------------------------
  " zoomwintab
  nnoremap <Leader>wo :ZoomWinTabToggle<CR>

  " --------------------------------------------------------------------------
  " highlightedyank
  let g:highlightedyank_highlight_duration = 200

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
  let g:UltiSnipsEditSplit = 'vertical'
  let g:UltiSnipsSnippetsDir ='/home/vlad/.local/share/nvim/pSnips'
  let g:UltiSnipsSnippetDirectories = ["UltiSnips", "/home/vlad/.local/share/nvim/pSnips"]

  let g:UltiSnipsListSnippets = '<c-=>'
  let g:UltiSnipsExpandTrigger = '<c-j>'
  let g:UltiSnipsJumpForwardTrigger = '<c-j>'
  let g:UltiSnipsJumpBackwardTrigger = '<c-k>'

  xnoremap  <c-j> :call UltiSnips#SaveLastVisualSelection()<CR>gvs

  " temporary workaround(LanguageClient - deoplete - UltiSnips)
  " check https://github.com/autozimu/LanguageClient-neovim/issues/379
  function! ExpandLspSnippet()
    call UltiSnips#ExpandSnippetOrJump()
    if !pumvisible() || empty(v:completed_item)
      return ''
    endif

    " only expand Lsp if UltiSnips#ExpandSnippetOrJump not effect.
    let l:value = v:completed_item['word']
    let l:matched = len(l:value)
    if l:matched <= 0
      return ''
    endif

    " remove inserted chars before expand snippet
    if col('.') == col('$')
      let l:matched -= 1
      exec 'normal! ' . l:matched . 'Xx'
    else
      exec 'normal! ' . l:matched . 'X'
    endif

    if col('.') == col('$') - 1
      " move to $ if at the end of line.
      call cursor(line('.'), col('$'))
    endif

    " expand snippet now.
    call UltiSnips#Anon(l:value)
    return ''
  endfunction
  imap <C-e> <C-R>=ExpandLspSnippet()<CR>

  " --------------------------------------------------------------------------
  " fzf
  " options {{{
  let $FZF_DEFAULT_OPTS = '--multi --no-mouse --inline-info'
  let $FZF_DEFAULT_COMMAND = 'fd --hidden --no-ignore-vcs --exclude .git/ --type file'

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
  " ycm
  "  options
  "let g:ycm_global_ycm_extra_conf = '~/.config/ycm/ycm_extra_conf.py'
  "let g:ycm_add_preview_to_completeopt = 0
  "let g:ycm_always_populate_location_list = 1
  ""let g:ycm_autoclose_preview_window_after_insertion = 1
  "let g:lt_height = 7

  ""  highlights
  "call s:SetHighlight('YcmErrorSign', {'mode': 'bold', 'bg': '#101010', 'fg': '#f43753'})
  "call s:SetHighlight('YcmErrorLine', {'bg': '#20202d'})
  "call s:SetHighlight('YcmErrorSection', {'mode': 'bold', 'bg': '#ff5555', 'fg': '#000000'})

  ""  bindings
  "nnoremap <leader>yc :YcmForceCompileAndDiagnostics<CR>
  "let g:ycm_key_invoke_completion = '<C-Space>'
  "let g:ycm_key_list_stop_completion = ['<C-y>']
  "let g:ycm_key_detailed_diagnostics = '<leader>yd'
  "nnoremap <leader>ff :YcmCompleter FixIt<CR>
  "let g:lt_location_list_toggle_map = '<leader>l'

  "nnoremap <buffer> <leader>yt :YcmCompleter GetType<CR>
  "nnoremap <buffer> <leader>yr :YcmCompleter ClearCompilationFlagCache<CR>

  "nnoremap <buffer> <leader>gg :YcmCompleter GoTo<CR>
  "nnoremap <buffer> <leader>gf :YcmCompleter GoToDefinition<CR>
  "nnoremap <buffer> <leader>gc :YcmCompleter GoToDeclaration<CR>
  "nnoremap <buffer> <leader>gi :YcmCompleter GoToInclude<CR>

  " --------------------------------------------------------------------------
  " lsp
  let g:LanguageClient_serverCommands = {
        \ 'cpp': ['cquery', '--log-file=/tmp/cq.log'],
        \ 'c': ['cquery', '--log-file=/tmp/cq.log'],
        \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
        \ }
  let g:LanguageClient_rootMarkers = {
        \ 'cpp': ['compile_commands.json']
        \ }
  let g:LanguageClient_diagnosticsDisplay = { 1: { }, 2: { }, 3: { }, 4: { }, }
  let g:LanguageClient_diagnosticsDisplay[1]['signTexthl'] = "ErrorSign"
  let g:LanguageClient_diagnosticsDisplay[2]['signTexthl'] = "WarningSing"
  let g:LanguageClient_diagnosticsDisplay[3]['signTexthl'] = "InformationSign"
  let g:LanguageClient_diagnosticsDisplay[4]['signTexthl'] = "HintSing"

  let g:LanguageClient_loadSettings = 1
  let g:LanguageClient_settingsPath = '~/.config/nvim/settings.json'
  let g:LanguageClient_loggingFile = "/tmp/LanguageClient.log"
  let g:LanguageClient_windowLogMessageLevel = "Error"
  set completefunc=LanguageClient#complete
  set formatexpr=LanguageClient_textDocument_rangeFormatting()

  function! SetLSPHotkeys()
    nnoremap <buffer> <silent> gh :call LanguageClient#textDocument_hover()<CR>
    nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> <silent> gr :call LanguageClient#textDocument_references()<CR>
    nnoremap <buffer> <silent> gs :call LanguageClient#textDocument_documentSymbol()<CR>
    nnoremap <buffer> <silent> gn :call LanguageClient#textDocument_rename()<CR>
    nnoremap <buffer> <silent> gm :call LanguageClient_contextMenu()<CR>
  endfunction

  augroup LSPHotkeysForFiles
    autocmd!
    autocmd FileType cpp,hpp,c,h,rust call SetLSPHotkeys()
  augroup END

  " --------------------------------------------------------------------------
  " deoplete
  let g:deoplete#enable_at_startup = 1
  call deoplete#custom#source('_', 'max_menu_width', 90)

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


  " **************************************************************************
  " WINDOW-BASED FEATURES

  " --------------------------------------------------------------------------
  " startify
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
        \ { 'type':'sessions',  'header': ['Sessions']       },
        \ { 'type':'bookmarks', 'header': ['Bookmarks']      },
        \ { 'type':'files',     'header': ['MRU']            },
        \ { 'type':'dir',       'header': ['MRU '. getcwd()] }
        \ ]

  let g:startify_session_before_save = [
        \ 'silent! NERDTreeClose',
        \ 'silent! TagbarClose'
        \ ]

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
  nnoremap <silent> <F3> :call NerdtreeToggle()<CR>
  nnoremap <silent> <F15> :call SwitchWindowTo("NERD_tree_*")<CR>
  nnoremap <silent> <leader>n :NERDTree<CR>

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
  nmap S <Plug>(easymotion-overwin-f)
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

  call plug#end()
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

  execute l:window_number . "wincmd w"
endfunction

" ----------------------------------------------------------------------------
" Terminal toggle

function! TerminalToggle()
  let l:terminal_buffer = bufnr('Terminal')
  if terminal_buffer == -1
    execute "bot 15new"
    terminal
    setlocal bufhidden=hide
    setlocal nobuflisted
    setlocal winfixwidth
    setlocal winfixheight
    setlocal filetype=terminal
    file Terminal
    return
  endif

  let l:terminal_window = bufwinnr(terminal_buffer)
  if terminal_window == -1
    execute "bot 15new +buffer".terminal_buffer
    setlocal winfixwidth
    setlocal winfixheight
  else
    if bufwinnr('%') == l:terminal_window
      call LoadWindow()
    endif
    execute "close ".terminal_window
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
call s:ConfigurePlugins()
call s:ConfigureView()

