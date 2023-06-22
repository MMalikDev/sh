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
        -d  Open browser to official ReduceDebian Docs
        -r  Reduce Debian Install to minimum
        -h  Show this page

EOF
    
    exit 0
}

# OPTIONS
reduce(){
    # Remove non-critical packages (don't remove busybox -> don't sure if this ist still a problem on debian 7)
    # ~i -> list all installed packages
    # !~M -> don't list automatic installed packages
    # !~prequired -> don't list packages with priority required
    # !~pimportant -> don't list packages with priority important
    # !~R~prequired -> don't list dependency packages of required packages
    # !~R~pimportant -> don't list dependency packages of important packages
    # !~R~R~prequired -> don't list dependency packages of dependency packages of required packages -.- (two levels should be enough. Have not found a recursive option)
    # !~R~R~pimportant -> ... required packages
    # !busybox -> don't list busybox
    # !grub -> don't list grub (we need a boot manager. If LILO or something else is used change this)
    # !initramfs-tools -> don't list initramfs-tools (else the kernel is gone)
    
    apt-get purge $(aptitude search '~i!~M!~prequired!~pimportant!~R~prequired!~R~R~prequired!~R~pimportant!~R~R~pimportant!busybox!grub!initramfs-tools' | awk '{print $2}')
    apt-get purge aptitude
    apt-get autoremove
    apt-get clean
}
doc(){
    local url=https://wiki.debian.org/ReduceDebian
    start $url
}
# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    while getopts "drh" OPTION; do
        case $OPTION in
            d) doc              ;;
            r) reduce           ;;
            h) display_usage    ;;
            ?) display_usage    ;;
        esac
    done
    shift $((OPTIND -1))
}

main $@
