#!/bin/bash

set -e

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)


# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    if [[ $# -lt 2 ]]; then
        echo "Usage: $(basename "$0") username hostname" >&2
        return 1
    fi
    
    local user=$1
    local host=$2
    
    printf "\n$start_icon Setting bash configs for $host as $user\n\n"
    
    cd "$(dirname "$0")"
    scp .bash_aliases .bash_history.bk $user@$host:~/
}

main $@
