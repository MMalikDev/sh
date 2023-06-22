#!/bin/bash

set -e

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    printf "\n$start_icon Setting bash configs for Home DNS\n\n"
    
    local user=pi
    local host=dns.home
    
    cd "$(dirname "$0")"
    scp .bash_aliases .bash_history.bk $user@$host:~/
}

main $@
