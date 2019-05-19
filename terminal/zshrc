################################################################################
#CONFIG
#vi mode
bindkey -v
export KEYTIMEOUT=1

#history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history

#completion
#fpath+=/.zfunc
autoload -U compinit && compinit
zmodload -i zsh/complist

bindkey -M menuselect '^O' accept-and-infer-next-history

eval "$(dircolors)"
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*:default' select-scroll 0

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' format "%B--- %F{magenta}%d%f ---%b"
zstyle ':completion:*:options' list-colors "=(#b)*(-- [a-zA-Z0-9]*)=32=36"
zstyle ':completion:*:commands' list-colors "=(#b)*(-- [a-zA-Z0-9]*)=32=36"

#options
setopt correct
setopt auto_cd

#copy whole line
vi-yank-x-line () {
  print -rn -- $BUFFER | xsel -i -p;
  print -rn -- $BUFFER | xsel -i -b;
}
zle -N vi-yank-x-line
bindkey -M vicmd '^y' vi-yank-x-line
bindkey -v '^y' vi-yank-x-line


#key fixes
bindkey -M viins '^?' backward-delete-char

#ranger
bindkey -M vicmd -s '\em' '^[ddiranger\n'
bindkey -M viins -s '\em' '^[ddiranger\n'

################################################################################
#ENV VARIABLES
export EDITOR="nvim -u ~/.config/nvim/init_for_editing.vim"
PAGER="nvim -u ~/.config/nvim/init_for_editing.vim -R"
export MANPAGER="nvim -c 'set ft=man' -"

#pass store
PASSWORD_STORE_CLIP_TIME=15
PASSWORD_STORE_GENERATED_LENGTH=17

################################################################################
#PLUGINS CONFIG PRE
ENHANCD_COMMAND=h
ENHANCD_DOT_SHOW_FULLPATH=1

FZF_TMUX_HEIGHT=40%
FZF_DEFAULT_OPTS='-m --no-mouse --cycle --reverse --border --color=bg:233 --history=.fzf_history'
FZF_DEFAULT_COMMAND='fd --hidden --no-ignore --type file'
FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
FZF_ALT_C_COMMAND='fd --hidden --no-ignore --type directory'

zstyle ':filter-select' case-insensitive yes 


################################################################################
#PLUGINS
source /usr/share/zsh/share/antigen.zsh

antigen bundle zdharma/fast-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zaw

antigen bundle colored-man-pages
antigen bundle colorize
antigen bundle command-not-found
antigen bundle extract
antigen bundle rust
antigen bundle cargo
antigen bundle transfer

antigen bundle djui/alias-tips
antigen bundle Valiev/almostontop
antigen bundle b4b4r07/enhancd
#antigen bundle oldratlee/hacker-quotes
antigen bundle supercrabtree/k

antigen apply
#FZF
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

################################################################################
#PLUGINS CONFIG POST

#zaw
bindkey -M viins '\eu' zaw-bookmark-add-buffer
bindkey -M vicmd '\eu' zaw-bookmark-add-buffer

bindkey -M viins '\eb' zaw-bookmark
bindkey -M vicmd '\eb' zaw-bookmark

#autosuggest
bindkey -M viins '\el' autosuggest-accept
bindkey -M vicmd '\el' autosuggest-accept

#almost on top
almostontop off
bindkey -M vicmd '\ej' almostontop_prompt_with_toggle
bindkey -M viins '\ej' almostontop_prompt_with_toggle

#substring search
HISTORY_SUBSTRING_SEARCH_FUZZY=true
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true

bindkey -M vicmd '^P' history-substring-search-up
bindkey -M viins '^P' history-substring-search-up
bindkey -M vicmd '^N' history-substring-search-down
bindkey -M viins '^N' history-substring-search-down

################################################################################
#ALIASES
#color aliases
alias ls='ls --color'
alias less='less -R'
alias diff='diff --color=always'
alias watch='watch --color'
alias yaourt='yaourt --color'
alias pacman='pacman --color=always'
alias dmesg='dmesg --color=always'
alias grep='grep --color=always'
alias fgrep='fgrep --color=always'
alias egrep='egrep --color=always'
alias gcc='gcc -fdiagnostics-color=always'
alias tldr='tldr -c'

#hacks alias
alias sudo='sudo '
alias ranger='ranger --choosedir=/tmp/.rangerdir; LASTDIR=`cat /tmp/.rangerdir`; cd "$LASTDIR"'
alias n='nvim'
e() { eval "$EDITOR $*" }
alias p='python'
alias r='rustup'
alias c='cargo'
alias f='fd -IH'
alias g='glances -0 -1 --disable-bg --fs-free-space'
alias hd='howdoi'
sp() { eval "sudo pacman -$*" }

#my scripts aliases
t() { echo "$*" | ~/Scripts/i3/new_word.py }
ts() { trans :ru -b "$*" }
tse() { trans :en -b "$*" }
alias tsf='trans :ru'
alias se='~/Scripts/i3/spellchecker'
alias sr='~/Scripts/i3/spellchecker_ru'

#ls aliases
alias k='k -h'
alias l='ls '
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -lAh'

#confirm aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

#global aliases
alias -g .g='| grep'
alias -g .l='| less'
alias -g .p="| $PAGER"
alias -g .stn='| tr " " "\n"'

#other
alias cal='cal -m'

################################################################################
#INDICATORS
#command time
function _command_time_preexec { start_command_time=$SECONDS }
function _command_time_precmd { command_time=$(( SECONDS - start_command_time )) }
function prompt_command_time { 
  if (( command_time < 3 )); then
    return
  elif (( command_time > 3600 )); then
    echo "%F{red}"$(( command_time/3600 ))"h:"$(( command_time/60%60 ))"m%f"
    return
  elif (( command_time > 60 )); then
    echo "%F{yellow}"$(( command_time/60 ))"m:"$(( command_time%60 ))"s%f"
    return
  else
    echo "%F{cyan}${command_time}s%f"
  fi
}

precmd_functions+=(_command_time_precmd)
preexec_functions+=(_command_time_preexec)

#vi indicators
VI_NORMAL="%F{magenta}NORMAL%f"
VI_INSERT="%F{yellow}INSERT%f"
function prompt_vi_mode() {
	echo "${${KEYMAP/vicmd/$VI_NORMAL}/(main|viins)/$VI_INSERT}"
}

function zle-line-init zle-keymap-select {
	zle && zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

TRAPWINCH() {
	zle && zle reset-prompt
}

#top indicator
function prompt_almostontop {
  if [[ $ALMOSONTOP == true ]] then
    echo "%F{green}TOP%f"
  fi
}

function almostontop_prompt_with_toggle {
  almostontop_toggle 
	zle && zle reset-prompt
}
zle -N almostontop_prompt_with_toggle 

################################################################################
#MY PROMPT
autoload -U colors && colors
setopt PROMPT_SUBST

#placeholder
prompt_ph="-"
prompt_ph_color='blue'
prompt_ph_bold=true

#parentheses
prompt_pnt_left='%B%F{white}[%f%b'
prompt_pnt_right='%B%F{white}]%f%b'

#line1
prompt_line1a=('$(prompt_almostontop)' '%B$(prompt_vi_mode)%b' '%F{cyan}%~%f')
prompt_line1b=('$(prompt_command_time)' '%F{white}%n@%m%f')

#line2
prompt_line2a="%(?:%F{green}✔ :%F{red}✗ )%f%(!:%F{red}# :%F{cyan}$)%f:"
prompt_line2b=('%*')


function prompt_eliminate_zsh_escape_sequence {
  echo $1 | sed 's/%[KF1]{[a-zA-Z0-9]*}\|%[Bbkf]//g'
  #or try this
  #echo $1 | perl -pe "s/%\{[^}]+\}//g"
}

function prompt_eliminate_escape_sequence {
  #normal seq
  #echo $1 | sed 's/\x1b\[[0-9;]*m//g'
  
  #with kernel console seq
  echo $1 | sed 's/\x1b\[[0-9;]*m//g' | sed 's/\x0f//g'
}

function prompt_calculation_size {
  local size=0
  local i
  for i in $@; do
		i=${(S%%)i}
    i=$(prompt_eliminate_escape_sequence $i)
    size=$(( size + ${#i} ))
  done
  echo $size
}

function prompt_create_line {
	local one_ph_symbol="%F{$prompt_ph_color}$prompt_ph%f"
  if $prompt_ph_bold; then
    one_ph_symbol="%B$one_ph_symbol%b"
  fi
  local line
  local arr="$@"
  local i
  for i in $@; do
		local size=$(prompt_calculation_size $i)
		if [[ $size -ne 0 ]]
		then
			local element="${(S%%)i}"
			element="%$size{$element%}"
			element="$prompt_pnt_left$element$prompt_pnt_right"
			element="$one_ph_symbol$element$one_ph_symbol"
			line="$line$element"
		fi
  done
  echo $line
}

function prompt_create_placeholder {
  eval "local placeholder=\${(l:${1}::${prompt_ph}:)}"
  if $prompt_ph_bold; then
    placeholder="%B%F{$prompt_ph_color}$placeholder%f%b"
  else
    placeholder="%F{$prompt_ph_color}$placeholder%f"
  fi
  echo $placeholder
}

function prompt_ps1 {

  local newline='%1{\n\r%}'

  #create line1
  local line1a=$(prompt_create_line $prompt_line1a[@])
  local line1b=$(prompt_create_line $prompt_line1b[@])

  #create placeholder
  local line1a_width=$(prompt_calculation_size $line1a)
  local line1b_width=$(prompt_calculation_size $line1b)
  local placeholder_size=$(( COLUMNS - line1a_width - line1b_width ))
  
  if (( placeholder_size > 0 )); then
    local placeholder=$(prompt_create_placeholder $placeholder_size)
    local endline=$line1a$placeholder$line1b$newline$prompt_line2a
    echo $endline
    return
  fi

  placeholder_size=$(( COLUMNS - line1a_width ))
  if (( placeholder_size > 0 )); then
    local placeholder=$(prompt_create_placeholder $placeholder_size)
    local endline=$line1a$placeholder$newline$prompt_line2a
    echo $endline
    return
  fi

  placeholder_size=$COLUMNS
  local placeholder=$(prompt_create_placeholder $placeholder_size)
  local endline=$placeholder$newline$prompt_line2a
  echo $endline
}
function prompt_rps1 {
  local line2b=$(prompt_create_line $prompt_line2b[@])
  echo $line2b
}
PS1='$(prompt_ps1)'
RPS1='$(prompt_rps1)'
