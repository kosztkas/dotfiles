#Default from mac home
PATH="/usr/local/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"

# Silence the Mac zsh warning
if [[ "$OSTYPE" =~ ^darwin ]]; then
    export BASH_SILENCE_DEPRECATION_WARNING=1
    export CLICOLOR=1
    export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
    export EDITOR=/usr/bin/vim
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Add bach completion for MacOS
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

### HISTORY ###

# Put timestamps in bash history
export HISTTIMEFORMAT='%F %T '
# Don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend
# Save multiline commands as one history entry
shopt -s cmdhist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

# Don't record these commands in the history; who cares about ls?
export HISTIGNORE='pwd:ls:ll:history:exit:bg:fg:clear'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${ORANGE}"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

#### ALIASES ####

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# Some useful aliases
alias fucking='sudo '
alias dance='cowsay -f tux no'
alias tmux='tmux -2'
alias python='python3'
alias tf='terraform'
alias tg='terragrunt'
alias k='kubectl'
alias cat='bat'
alias sc_all='find . -name \*.sh -print0 | xargs -0 shellcheck -x'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

NC='\e[0m' # No Color
WHITE='\e[1;37m'
BLACK='\e[0;30m'
BLUE='\e[0;34m'
LIGHT_BLUE='\e[1;34m'
GREEN='\e[0;32m'
LIGHT_GREEN='\e[1;32m'
CYAN='\e[0;36m'
LIGHT_CYAN='\e[1;36m'
RED='\e[0;31m'
LIGHT_RED='\e[1;31m'
PURPLE='\e[0;35m'
LIGHT_PURPLE='\e[1;35m'
BROWN='\e[0;33m'
YELLOW='\e[1;33m'
GRAY='\e[0;30m'
LIGHT_GRAY='\e[0;37m'

PS1='$(RET=$?; if [ $RET != 0 ]; then echo "\[\033[1;31m\]<$RET>"; else echo "\[\033[1;32m\][$RET]"; fi) \[\033[1;32m\]\u@\h:\[\033[0;36m\]\w\[\033[1;33m\]$(parse_git_branch) \[\033[0m\]\n↳\$ '

# Extract most know archives with one command
extract () {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1"    ;;
      *.tar.gz)  tar xzf "$1"    ;;
      *.bz2)     bunzip2 "$1"    ;;
      *.rar)     unrar e "$1"    ;;
      *.gz)      gunzip "$1"     ;;
      *.tar)     tar xf "$1"     ;;
      *.tbz2)    tar xjf "$1"    ;;
      *.tgz)     tar xzf "$1"    ;;
      *.zip)     unzip "$1"      ;;
      *.Z)       uncompress "$1" ;;
      *)         echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Show directory structure as a tree from `pwd`
lstree() {
  local -r shortpath="$(basename "$(pwd)")"
  local -r output="$(tree -C -d --noreport "$@")"

  (
    echo "${output}" | head -n 1 | sed -e "s/^\\.$/${shortpath}/"
    echo "${output}" | tail -n "$(($(echo "${output}" | wc -l)-1))"
  ) | less -EFRSX
}

#Make directory color not hurt my eyes TODO fix on Mac
force_color_prompt=yes

#export LS_COLORS=$LS_COLORS:'di=0;36:' ; export LS_COLORS

alias assume=". assume"

# Make terragrunt / terraform use less space
export TERRAGRUNT_DOWNLOAD=~/.terragrunt
export TF_PLUGIN_CACHE_DIR=~/.terraform
