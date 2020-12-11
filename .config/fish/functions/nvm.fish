function nvm
    bass source /usr/share/nvm/init-nvm.sh --no-use ';' nvm $argv
end

set -x NVM_DIR "$HOME/.nvm"
