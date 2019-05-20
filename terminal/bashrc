[[ $- != *i* ]] && return

#bash
export HISTCONTROL=ignoredups
export NO_AT_BRIDGE=1
export BC_ENV_ARGS='/home/vlad/.bc'

# alias
alias sudo='sudo '

alias diff='diff --color=always'
alias watch='watch --color'
alias nano='nano -w'
alias yaourt='yaourt --color'
alias ls='ls --color=auto'
alias less='less -R'
alias dmesg='dmesg --color=always'
alias grep='grep --color=always'
alias fgrep='fgrep --color=always'
alias egrep='egrep --color=always'
alias gcc='gcc -fdiagnostics-color=always'
alias ts='trans :ru -b'
alias tsf='trans :ru'
alias scr='~/Scripts/i3/spellchecker_ru'
alias sce='~/Scripts/i3/spellchecker_en'

#less man
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
	LESS_TERMCAP_so=$'\E[30;43m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

#PS1
#PS1="\[\e[0;32m\]\u@\[\e[1;30m\]\h\[\e[1;32m\]:\w$\[\e[0m\]"
PS1="\[\e[0;32m\]\u@\[\e[0;35m\]\h\[\e[1;32m\]:\w$\[\e[0m\]"
