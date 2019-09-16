#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set vi-mode on BASH
set -o vi

# Automate JVM bytecode compilation and execution
jav() {
  javac "$1".java
  java "$1"
  find . -name '*.class' -delete
}

export -f jav

alias ls='ls -p --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias monitor="$HOME/.config/xrandr/monitor_autoswitcher.sh"
alias kb="bluetoothctl connect 00:06:66:F3:CD:06"
alias music='~/.config/i3/ws/music.sh'
PS1="\n\$(if [[ \$? == 0 ]]; then echo \"\[\033[0;34m\]\"; else echo \"\[\033[0;31m\]\"; fi)\342\226\210\342\226\210 [ \u ] [ \w ]\n\[\033[0m\]\342\226\210\342\226\210 "


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

export GITHUB_TOKEN="595dc73a09c4570d053f4c4978ef001ecd24ca96"
source /usr/share/nvm/init-nvm.sh
