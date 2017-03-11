function! LocalLang()
    set keymap=russian-jcukenwin
    set iminsert=0
    set imsearch=0
endfunc

function! TechnicalSettings()
    set backup		" keep a backup file (restore to previous version)
    set backupdir=~/.vimbk
    "set clipboard=unnamedplus
endfunc

function! ConfigureView()
    set number
    " Включить подсветку синтаксиса
    syntax on
    " Поиск по набору текста (очень полезная функция)
    set incsearch
    " Подсвечивание поиска
    set hlsearch
    " умная зависимость от регистра %)
    set ignorecase
    set smartcase
    " Кодировка текста по умолчанию
    set termencoding=utf8
    " Включаем несовместимость настроек с Vi (ибо Vi нам и не понадобится).
    set nocompatible
    " Показывать положение курсора всё время.
    set ruler
    " Показывать незавершённые команды в статусбаре
    set showcmd
    " Фолдинг по отсупам
    set foldenable
    set foldlevel=100
    set foldmethod=indent
    " Выключаем надоедливый "звонок"
    set noerrorbells visualbell t_vb=
    autocmd GUIEnter * set visualbell t_vb=
    " Поддержка мыши
    set mouse=a
    set mousemodel=popup
    " Не выгружать буфер, когда переключаемся на другой
    " Это позволяет редактировать несколько файлов в один и тот же момент без необходимости сохранения каждый раз
    " когда переключаешься между ними
    set hidden
    " Скрыть панель в gui версии ибо она не нужна
    set guioptions-=T
    " Сделать строку команд высотой в одну строку
    set ch=1
    " Скрывать указатель мыши, когда печатаем
    set mousehide
    " Включить автоотступы
    set autoindent
    "Не переносить строки
    set nowrap
    " Размер табуляции по умолчанию
    set shiftwidth=4
    set softtabstop=0
    set tabstop=4
    set noexpandtab
    " Формат строки состояния
    set statusline=%<%f\ %P
    set laststatus=2
    " Включаем "умные" отступы ( например, авто отступ после {)
    set smartindent
    " Отображение парных символов
    set showmatch
    " Навигация с учетом русских символов
    set iskeyword=@,48-57,_,192-255
    " Удаление символов бэкспэйсом в Windows
    set backspace=indent,eol,start
    set cursorline
    "highlight CursorLine guibg=lightblue ctermbg=lightgray
    "highlight CursorLine term=none cterm=none
    set history=200
    set wildmenu
    set list listchars=tab:→\ ,trail:·
    filetype plugin on
endfunc

function! InitExternalPlugins()
    let g:UltiSnipsExpandTrigger = "<c-j>"
    let g:tagbar_left = 1
    let g:tagbar_type_rust = {
        \ 'ctagstype' : 'rust',
        \ 'kinds'     : [
            \ 'f:function',
            \ 'm:macros',
            \ 'T:types',
            \ 'm:types1',
            \ 'm:modules',
            \ 'm:consts',
            \ 'm:traits',
        \ ],
    \ }
endfunction

function! BindKeys()
    " просмотр списка буферов
    nmap <C-b> <Esc>:BufExplorer<cr>
    vmap <C-b> <esc>:BufExplorer<cr>
    imap <C-b> <esc><esc>:BufExplorer<cr>
    nmap <C-\> :TagbarToggle<CR>
    cnoremap @ <c-r>=expand("%:h")<cr>/
    nmap <silent> <Leader>of :FSHere<cr>
    nmap fd :Rgrep<cr>
    nmap fb :GrepBuffer<cr>
    nmap p4e :!p4 edit %<cr>
endfunction


function! ConfigureCompletitions()
    " Слова откуда будем завершать
    set complete=""
    " Из текущего буфера
    set complete+=.
    " Из словаря
    set complete+=k
    " Из других открытых буферов
    set complete+=b
    " из тегов
    set complete+=t

    set completeopt-=preview
    set completeopt=menuone,menu,longest,preview

    " automatically open and close the popup menu / preview window
    au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    set mps-=[:]
endfunction

function! LocalConf()
    if filereadable(".vim_config")
        source .vim_config
    endif
endfunc

call LocalConf()
call ConfigureView()
call BindKeys()
call LocalLang()
call TechnicalSettings()
call ConfigureCompletitions()
"call InitExternalPlugins()
