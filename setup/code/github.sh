#!/bin/bash

set -e

# Local Env
program=VSCode

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

# Helper Function
create_key() {
    local email="$@"
    ssh-keygen -t ed25519 -C "$email"
}

copy_key() {
    clip < ~/.ssh/id_ed25519.pub
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    if [ $# -eq 0 ]; then
        echo "Usage: $0 '<email>'"
        echo No email was provided...
        exit 1
    fi
    
    create_key $@
    copy_key
}

main $@
