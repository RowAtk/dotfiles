#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
source /usr/share/nvm/init-nvm.sh
alias config='/usr/bin/git --git-dir=/home/rowan/.cfg/ --work-tree=/home/rowan'
