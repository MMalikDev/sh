#!/bin/bash

set -e

# Local Env
venv="$HOME/sh/venv.sh"


# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)
end_icon="\xF0\x9F\x91\x8D " # Thumbs Up Sign (U+1F44D)

# Messages
reset="$start_icon Resetting python venv..."
update="\n$start_icon Updating requirement versions to latest...\n\n"
complete="\n$end_icon New virtual environment ready\n"

# Functions
get_target(){
    if [ $# -eq 0 ]; then
        target=src
    else
        target="$@"
    fi
    echo $target
}

update_version(){
    printf "$update"
    cp requirements/versions.txt "$1/requirements/versions.txt"
}

main() {
    printf "$reset"
    
    # Get requirement file location
    target=$(get_target $@)
    
    # Move requirement to root
    cp -r "$target/requirements" requirements
    
    # Reset Venv
    bash $venv # --upgrade
    
    # Updating package versions
    update_version $target
    
    # Remove root requirements folder
    rm -rf requirements
    
    printf "$complete"
}

main $@
