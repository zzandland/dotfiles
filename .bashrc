#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Use Ripgrep in fzf
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

# Set vi-mode on BASH
set -o vi

alias ls='ls -p'
alias ..='cd ..'
alias ...='cd ../..'
PS1="\n\$(if [[ \$? == 0 ]]; then echo \"\[\033[0;34m\]\"; else echo \"\[\033[0;31m\]\"; fi)\342\226\210\342\226\210 [ \u ] [ \w ]\n\[\033[0m\]\342\226\210\342\226\210 "

export PATH="/usr/local/opt/python/libexec/bin:$PATH"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

PATH=$PATH:/usr/local/sbin
