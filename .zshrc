HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt HIST_IGNORE_DUPS
bindkey -e

autoload -Uz compinit promptinit
compinit
promptinit
prompt redhat

alias eli="eli -c /tmp/CACHE"
