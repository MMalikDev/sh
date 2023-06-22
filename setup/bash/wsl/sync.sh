#!/bin/bash

set -e

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)


# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    printf "\n $start_icon Adding aliases and history to WSL...\n\n"
    
    cd "$(dirname "$0")"
    cp .bash_aliases $HOME
    cp .bash_history $HOME
    cp .bash_history $HOME/.bash_history.bk
}

main
