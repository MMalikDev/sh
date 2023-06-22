#!/bin/bash

set -e

# Local Env
program=VSCode

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

# Summary
display_usage(){
        cat << EOF

Usage: $0 [OPTIONS]

Template script for $(basename "$0" | cut -d. -f1)

    OPTIONS
        -i Install WSL
        -l List distros
        -g Get Debian
        -d Delete Debian
        -c Close WSL
        -h Show this page

EOF
    
    exit 0
}

# OPTIONS
install_wsl(){
    wsl --install
}
list_distro(){
    wsl --list --online
}
get_debian(){
    wsl --install Debian
    wsl -s Debian
}
delete_debian(){
    wsl --unregister Debian
}
close_wsl(){
    wsl --shutdown
    wsl  -l -v
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    while getopts "ilgdch" OPTION; do
        case $OPTION in
            i) install_wsl      ;;
            l) list_distro      ;;
            g) get_debian       ;;
            d) delete_debian    ;;
            c) close_wsl        ;;
            h) display_usage    ;;
            ?) display_usage    ;;
        esac
    done
    shift $((OPTIND -1))
}

main $@
