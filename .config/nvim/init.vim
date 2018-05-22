function! Plugins()
  call plug#begin('~/.local/share/nvim/plugged')

  "HIGHLIGHTS
  Plug 'rafi/awesome-vim-colorschemes'
  Plug 'PotatoesMaster/i3-vim-syntax'
  Plug 'tmux-plugins/vim-tmux'
  Plug 'tiamat18/vim-qmake'

  "Plug 'scrooloose/syntastic'

  "TMUX MOVE
  "may be later
  "have no time
  "Plug 'christoomey/vim-tmux-navigator'


  "COMPLETION
  Plug 'Valloric/YouCompleteMe'


  Plug 'scrooloose/nerdtree'
  Plug 'jistr/vim-nerdtree-tabs'
  Plug 'gilligan/vim-lldb'
  Plug 'octol/vim-cpp-enhanced-highlight'
  "Plug 'vim-airline/vim-airline'
  "Plug 'ctrlpvim/ctrlp.vim'
  Plug 'itchyny/lightline.vim'
  Plug 'thaerkh/vim-workspace'
  Plug 'jiangmiao/auto-pairs'

  ", { 'on': [] }
  call plug#end()

  let g:lightline = {
      \ 'colorscheme': 'Dracula',
      \ }
  "let g:airline_section_b = '%t%m%#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
  "let g:airline_section_c = '%='
  "let g:airline_section_gutter = '%='
  "let g:airline_section_x = ''
  "let g:airline_section_y = '%{getcwd()}'
  "let g:airline_section_z = '%#__accent_bold#%p%% %l/%L%#__restore__#'
  "let g:airline_section_warning = ''
  "let g:airline_section_error = ''


  "let g:airline#extensions#keymap#enabled = 0
  "let g:airline#extensions#tabline#enabled = 1
  "let g:airline#extensions#tabline#show_buffers = 0
  "let g:airline#extensions#tabline#show_tabs = 1
  "let g:airline#extensions#tabline#show_splits = 0
  "let g:airline#extensions#tabline#show_close_button = 0
  "let g:airline#extensions#tabline#fnamemod = ':t'


  "let g:airline_skip_empty_sections = 1
  "let g:airline_powerline_fonts = 1


  "YCM
  "set completeopt-=preview
  "let g:ycm_server_python_interpreter = 'python3'
  "let g:ycm_seed_identifiers_with_syntax = 1
  let g:ycm_global_ycm_extra_conf = '~/.local/share/nvim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
  "let g:ycm_keep_logfiles = 1
  "let g:ycm_log_level = 'debug'

  au FileType c,cpp nnoremap <buffer> <c-]> :YcmCompleter GoTo<CR>

  "let g:ctrlp_custom_ignore = {'dir':  '\v[\/](\.(git|hg|svn)|\_site)$', 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',}
  let g:ctrlp_root_markers = ['main.cpp', 'Main.cpp']

  let g:workspace_session_name = '.session.vim'
  let g:workspace_persist_undo_history = 0
  let g:workspace_autosave_always = 0
  let g:workspace_autosave = 0

  let g:AutoPairsMapBS = 0
  let g:AutoPairsMapCh = 0
  let g:AutoPairsShortcutToggle = ''
endfunc

function! LocalLang()
  "let g:airline_detect_iminsert = 1

  set keymap=russian-jcukenwin
  set iminsert=0
  set imsearch=0
  highlight lCursor guifg=NONE guibg=Cyan
endfunc

function! TechnicalSettings()
  set nocompatible
  set nohidden
  set mouse=a

  set backup
  set backupdir=~/.nvimbk
  "leader key etc
  set notimeout

endfunc

function! ConfigureView()
  set  termguicolors
  "set guifont=*\29
  let a:scolor = "0"

  if a:scolor == 0
    colorscheme dracula
  elseif a:scolor == 1
    let g:gruvbox_contrast_dark="hard"
    let g:gruvbox_termcolors="256"
    let g:gruvbox_italic="1"
    let g:gruvbox_bold="1"
    set background=dark
    colorscheme gruvbox
  elseif a:scolor == 2
    colorscheme monokai
  elseif a:scolor == 3
    let g:badwolf_tabline = 3
    colorscheme badwolf
  elseif a:scolor == 4
    colorscheme goodwolf
  elseif a:scolor == 5
    colorscheme jellybeans
  endif

  set number
  set relativenumber
  " Включить подсветку синтаксиса
  "syntax on
  " Поиск по набору текста (очень полезная функция)
  set incsearch
  " Подсвечивание поиска
  set hlsearch
  " умная зависимость от регистра %)
  set ignorecase
  set smartcase
  " Кодировка текста по умолчанию
  set termencoding=utf8
  " Показывать положение курсора всё время.
  set ruler
  " Показывать незавершённые команды в статусбаре
  set showcmd
  " Фолдинг по отсупам
  set foldenable
  set foldlevel=100
  set foldmethod=indent
  " Сделать строку команд высотой в одну строку
  set ch=1
  " Скрывать указатель мыши, когда печатаем
  set mousehide
  " Включить автоотступы
  "set autoindent
  "Не переносить строки
  set nowrap
  "
  " Размер табуляции по умолчанию
  set tabstop=2
  set shiftwidth=2
  set smarttab
  set expandtab
  set smartindent

  " Отображение парных символов
  set showmatch
  " Удаление символов бэкспэйсом в Windows
  set backspace=indent,eol,start

  set cursorline
  hi cursorline cterm=underline

  set history=200
  set wildmenu

  set list
  "set listchars=tab:→\ ,trail:·
  set listchars=tab:\ \ ,trail:·
  highlight SpecialKey ctermbg=none
endfunc

function! BindKeys()
  inoremap <m-h> <left>
  inoremap <m-j> <down>
  inoremap <m-k> <up>
  inoremap <m-l> <right>

  let g:mapleader = ' '

  "windows
  nnoremap <space> <NOP>
  nnoremap <leader>w <C-w>

  "
  nnoremap <leader>n :noh<CR>

  "ycm
  nnoremap <leader>cw :YcmDiags<CR>
  nnoremap <leader>f :YcmCompleter FixIt<CR>

  "vim
  nnoremap <leader>vs :e ~/.config/nvim/init.vim<CR>
  nnoremap <leader>vr :source ~/.config/nvim/init.vim<CR>

  "X11 copy-paste
  vnoremap <leader>yc "+y
  vnoremap <leader>yp "*y

  nnoremap <leader>pc "+p
  nnoremap <leader>pp "*p

  nnoremap <leader>pC "+P
  nnoremap <leader>pP "*P

  "words
  nnoremap <leader>di :% s/-/<tab>-/g<CR>:noh<CR>

endfunction


call TechnicalSettings()
call Plugins()
call BindKeys()
call ConfigureView()
call LocalLang()

