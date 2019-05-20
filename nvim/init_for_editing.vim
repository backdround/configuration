" ============================================================================
" Load Plugins {{{

function! s:LoadPlugins()
  call plug#begin('~/.local/share/nvim/plugged')

  " --------------------------------------------------------------------------
  " UI ENCHANTMENTS
  Plug 'rafi/awesome-vim-colorschemes'   " COLORSCHEMES
  Plug 'vim-airline/vim-airline'         " AIRLINE
  Plug 'vim-airline/vim-airline-themes'

  " --------------------------------------------------------------------------
  " FEATURES
  Plug 'tpope/vim-repeat'               " REPEAT
  Plug 'machakann/vim-highlightedyank'  " HIGHLIGHTED YANK
  Plug 'tyru/open-browser.vim'          " OPEN BROWSER
  Plug 'mbbill/undotree'                " UNDOTREE

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
  Plug 'kana/vim-niceblock'           " NICEBLOCK
  Plug 'matze/vim-move'               " MOVE

  " --------------------------------------------------------------------------
  "TEXT OBJECT
  Plug 'gcmt/wildfire.vim'       " WILDFIRE
  Plug 'wellle/targets.vim'      " TARGETS

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
  set nobackup
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
  nnoremap <leader>vr :source ~/.config/nvim/init_for_editing.vim<CR>

  "clipboard copy
  nmap <leader>y "+y
  xmap <leader>y "+y

  "primary copy
  nmap <leader>Y "*y
  xmap <leader>Y "*y


  "misc
  nnoremap z :x<CR>
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

  let g:airline_theme='onedark'
  colorscheme lucid

  " --------------------------------------------------------------------------
  " highlight CursorLine
  call s:SetHighlight("CursorLine",   { 'bg': '#232323'})
  call s:SetHighlight("CursorLineNr", { 'mode': 'bold', 'fg': '#7bc992', 'bg': '#191919'})

endfunction
" }}}
" ============================================================================

" ============================================================================
" Configure Plugins {{{

function! s:ConfigurePlugins()

  " --------------------------------------------------------------------------
  " airline
  let g:airline#extensions#disable_rtp_load = 1
  let g:airline_extensions = ['tabline', 'undotree']

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

  function! AirlineInit()
    let g:airline_section_b = airline#section#create(['branch'])
    let g:airline_section_c = '%t%m'
    let g:airline_section_z = '%#__accent_bold#%p%% %l/%L%#__restore__#'
  endfunction
  augroup AAInit
    autocmd!
    autocmd User AirlineAfterInit call AirlineInit()
  augroup END


  " highlightedyank
  let g:highlightedyank_highlight_duration = 200

  " open-browser
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)

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
  nmap sO <Plug>(easymotion-overwin-f)
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

  " nerdcommenter
  let g:NERDRemoveExtraSpaces = 1
  let g:NERDTrimTrailingWhitespace = 1
  let g:NERDCompactSexyComs = 1
  let g:NERDToggleCheckAllLines = 1

  " easy-align
  nmap ga <Plug>(EasyAlign)
  xmap ga <Plug>(EasyAlign)

  nmap gl <Plug>(LiveEasyAlign)
  xmap n <Plug>(LiveEasyAlign)

  " auto-pairs
  let g:AutoPairsShortcutJump = '<M-q>'

  " niceblock
  let g:niceblock_no_default_key_mappings = 1
  xmap gI <Plug>(niceblock-I)
  xmap gi <Plug>(niceblock-gI)
  xmap gA <Plug>(niceblock-A)

  " wildfire
  let g:wildfire_objects = ["i'", 'i"', "i)", "i]", "i}", "ip", "it", "i>"]

  call plug#end()
endfunction
" }}}
" ============================================================================

" ============================================================================
" Util Functions {{{

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
" }}}
" ============================================================================

call s:LoadPlugins()
call s:BasicSettings()
call s:ConfigurePlugins()
call s:ConfigureView()

