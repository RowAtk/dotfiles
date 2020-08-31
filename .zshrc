# Lines configured by zsh-newuser-install
setopt autocd beep extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/rowan/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
fpath=($fpath "/home/rowan/.zfunctions")

# from .bashrc
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias lua=/usr/bin/lua5.3

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="${PATH}:/home/rowan/.local/bin"
eval $(luarocks path --bin)	


# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship

# spaceship config
export SPACESHIP_USER_SHOW=always
