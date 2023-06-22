#!/bin/bash

set -e

# Local Env
program=NodeJS

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

# Summary
display_usage(){
        cat << EOF

Usage: $0 [OPTIONS]

Template script for $(basename "$0" | cut -d. -f1)

    OPTIONs
        -a          Installing $program using apt
        -n          Installing $program using nix-env
        -h          Show this page

EOF
    
    exit 0
}

# OPTIONS
install_apt(){
    printf "\n$start_icon Installing $program using apt\n"
    
    sudo apt install nodejs npm
}

install_nix(){
    printf "\n$start_icon Installing $program using nix-env\n"
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    while getopts "anh" OPTION; do
        case $OPTION in
            a) install_apt      ;;
            n) install_nix      ;;
            h) display_usage    ;;
            ?) display_usage    ;;
        esac
    done
    shift $((OPTIND -1))
}

main $@
