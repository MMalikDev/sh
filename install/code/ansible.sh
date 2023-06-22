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
        -d      Install for Debian
        -u      Install for Ubuntu
        -x      Install with pipx
        -p      Install with pip
        -h      Show this page

EOF
    
    exit 0
}

# OPTIONS
install_debian(){
    local UBUNTU_CODENAME=jammy
    local sources=/etc/apt/sources.list.d/ansible.list
    local keyrings=/usr/share/keyrings/ansible-archive-keyring.gpg
    local packages=http://ppa.launchpad.net/ansible/ansible/ubuntu
    
    local hash="0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367"
    local repository="https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=$hash"
    
    wget -O- $repository | sudo gpg --dearmour -o $keyrings
    echo "deb [signed-by=$keyrings] $packages $UBUNTU_CODENAME main" | sudo tee $sources
    
    sudo apt update && sudo apt install ansible
}

install_ubuntu(){
    sudo apt update
    sudo apt install software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install ansible
}

install_pipx(){
    pipx install --include-deps ansible
    pipx install ansible-core
}

install_pip(){
    pip install ansible
}


# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    while getopts "hdup:" OPTION; do
        case $OPTION in
            d) install_debian   ;;
            u) install_ubuntu   ;;
            x) install_pipx     ;;
            p) install_pip     ;;
            h) display_usage    ;;
            ?) display_usage    ;;
        esac
    done
    shift $((OPTIND -1))
}

main $@
