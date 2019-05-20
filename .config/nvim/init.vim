function! Plugins()
	call plug#begin('~/.local/share/nvim/plugged')

	Plug 'Valloric/YouCompleteMe'
	Plug 'scrooloose/nerdtree'
	Plug 'jistr/vim-nerdtree-tabs'
	Plug 'gilligan/vim-lldb'
	Plug 'octol/vim-cpp-enhanced-highlight'
	Plug 'vim-airline/vim-airline'
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'jiangmiao/auto-pairs'

	Plug 'dracula/vim'
	Plug 'morhetz/gruvbox'
	Plug 'sickill/vim-monokai'
	Plug 'sjl/badwolf'
	Plug 'nanotech/jellybeans.vim'
	", { 'on': [] }
	call plug#end()


	let g:airline_section_b = '%t%m%#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
	let g:airline_section_c = '%='
	let g:airline_section_gutter = '%='
	let g:airline_section_x = ''
	let g:airline_section_y = '%{getcwd()}'
	let g:airline_section_z = '%#__accent_bold#%p%% %l/%L%#__restore__#'
	let g:airline_section_warning = ''
	let g:airline_section_error = ''

	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#show_buffers = 0
	let g:airline#extensions#tabline#show_tabs = 1
	let g:airline#extensions#tabline#show_splits = 0
	let g:airline#extensions#tabline#show_close_button = 0
	let g:airline#extensions#tabline#fnamemod = ':t'

	let g:airline_skip_empty_sections = 1
	"let g:airline#extensions#disable_rtp_load = 1
	"let g:airline_extensions = ['tabline']
	let g:airline_powerline_fonts = 1

	set completeopt-=preview
	let g:ycm_seed_identifiers_with_syntax = 1
	let g:ycm_global_ycm_extra_conf = '.local/share/nvim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
	let g:ycm_keep_logfiles = 1
	let g:ycm_log_level = 'debug'

	au FileType c,cpp nnoremap <buffer> <c-]> :YcmCompleter GoTo<CR>

	"let g:ctrlp_custom_ignore = {'dir':  '\v[\/](\.(git|hg|svn)|\_site)$', 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',}
	let g:ctrlp_root_markers = ['main.cpp']

	let g:AutoPairsMapBS = 0
	let g:AutoPairsMapCh = 0
	let g:AutoPairsShortcutToggle = ''
endfunc

function! LocalLang()
	let g:airline_detect_iminsert = 1

	set keymap=russian-jcukenwin
	set iminsert=0
	set imsearch=0
endfunc

function! TechnicalSettings()
    set nocompatible
	set nohidden

    set backup
    set backupdir=~/.nvimbk
	set t_Co=256

    "set clipboard=unnamedplus
endfunc

function! ConfigureView()
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
    " Размер табуляции по умолчанию
    set shiftwidth=4
    set softtabstop=4
    set tabstop=4
    set noexpandtab
    " Включаем "умные" отступы ( например, авто отступ после {)
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
    "nmap <C-\> :TagbarToggle<CR>
    "cnoremap @ <c-r>=expand("%:h")<cr>/
    "nmap <silent> <Leader>of :FSHere<cr>
    "nmap fd :Rgrep<cr>
    "nmap fb :GrepBuffer<cr>
    "nmap p4e :!p4 edit %<cr>
	nnoremap <space> za
	"inoremap <BS> <left>
	inoremap <m-h> <left>
	inoremap <m-j> <down>
	inoremap <m-k> <up>
	inoremap <m-l> <right>

	nmap <silent> <m-k> :wincmd k<CR>
	nmap <silent> <m-j> :wincmd j<CR>
	nmap <silent> <m-h> :wincmd h<CR>
	nmap <silent> <m-l> :wincmd l<CR>	

	nmap <silent> <m-K> :wincmd K<CR>
	nmap <silent> <m-J> :wincmd J<CR>
	nmap <silent> <m-H> :wincmd H<CR>
	nmap <silent> <m-L> :wincmd L<CR>	
endfunction


call TechnicalSettings()
call Plugins()
call ConfigureView()
call BindKeys()
call LocalLang()

