HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt HIST_IGNORE_DUPS
bindkey -e

autoload -Uz compinit promptinit select-word-style
compinit
promptinit
prompt redhat
select-word-style bash

bindkey "^[Oc"	forward-word
bindkey "^[Od"	backward-word
bindkey "^H"	backward-kill-word
bindkey "^[[3^"	kill-word
bindkey "^[[3~" delete-char

alias eli="eli -c /tmp/CACHE"
alias ls="ls --color=auto"
eval $(dircolors -b)
alias grep="grep --color=auto"

#PATH=$HOME/scheme/egg-repo/bin:$PATH
PATH=$HOME/.shelly/bin:$PATH
PATH=$(ruby -rubygems -e "puts Gem.user_dir")/bin:$PATH
PATH=$HOME/.bin:$PATH
export PATH

#export CHICKEN_REPOSITORY=~/scheme/egg-repo/lib/chicken/7
#export CHICKEN_DOC_REPOSITORY=~/scheme/chicken-doc-repo/

export EXT_LLVM_DIR=/home/chfin/dateien/src/llvm-3.4.1.src/build
