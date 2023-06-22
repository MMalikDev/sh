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
        -o [SOMETHING]  Show something
        -h              Show this page

EOF
    
    exit 0
}

# OPTIONS
options(){
    echo "Something to show: $@"
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    while getopts "ho:" OPTION; do
        case $OPTION in
            o) options $OPTARG  ;;
            h) display_usage    ;;
            ?) display_usage    ;;
        esac
    done
    shift $((OPTIND -1))
    
    echo "Main ARGS: $@"
}

main $@
