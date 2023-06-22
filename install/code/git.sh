#!/bin/bash

set -e

# Local Env
program=Template

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

# Summary
display_usage(){
        cat << EOF

Usage: $0 [OPTIONS]

Template script for $(basename "$0" | cut -d. -f1)

    OPTIONs
        -a  Show something
        -w  Show something
        -h  Show this page

EOF
    
    exit 0
}

# OPTIONS
install_apt(){
    apt-get install git
}
install_winget(){
    winget install --id Git.Git -e --source winget
}


# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    while getopts "awh" OPTION; do
        case $OPTION in
            a) install_apt      ;;
            w) install_winget   ;;
            h) display_usage    ;;
            ?) display_usage    ;;
        esac
    done
    shift $((OPTIND -1))
}

main $@
