HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt HIST_IGNORE_DUPS
bindkey -e

autoload -Uz compinit promptinit
compinit
promptinit
prompt redhat

bindkey "^[Oc" forward-word
bindkey "^[Od" backward-word

alias eli="eli -c /tmp/CACHE"
