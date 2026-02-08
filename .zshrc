# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep notify
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/rowana/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

export EDITOR='nvim'
export VISUAL='nvim'

export PATH="$PATH:$HOME/bin:$(go env GOBIN):$(go env GOPATH)/bin"

# NVM
source /usr/share/nvm/init-nvm.sh

# aliases
source ~/.aliases
