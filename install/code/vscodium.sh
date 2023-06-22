#!/bin/bash

set -e

# Local Env
program=vscodium

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

# Summary
display_usage(){
        cat << EOF

Usage: $0 [OPTIONS]

Template script for $(basename "$0" | cut -d. -f1)

    OPTIONs
        -l      Install with deb (alt)
        -w      Install with winget
        -d      Install with deb
        -a      Install with apt
        -n      Install with nix
        -h      Show this page

EOF
    exit 0
}

# OPTIONS
install_deb(){
    printf "\n$start_icon Installing $program using deb\n"
    
    sudo apt install wget gpg
    
    # Add the GPG key of the repository:
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
    
    # Add the repository:
    echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
    
    # Update then install vscodium
    sudo apt update && sudo apt install codium
}

install_deb_alt(){
    printf "\n$start_icon Installing $program using deb\n"
    
    local packages=https://download.vscodium.com/debs
    local sources=/etc/apt/sources.list.d/vscodium.list
    local keyrings=/usr/share/keyrings/vscodium-archive-keyring.gpg
    local repository=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
    
    sudo apt install wget gpg
    wget -qO - $repository | gpg --dearmor | sudo dd of=$keyrings
    echo "deb [ signed-by=$keyrings ] $packages vscodium main" | sudo tee $sources
    sudo apt update && sudo apt install codium
}

install_apt(){
    printf "\n$start_icon Installing $program using apt\n"
    
    sudo apt update
    sudo apt install codium
}

install_nix(){
    printf "\n$start_icon Installing $program using nix-env\n"
    
    nix-env -iA nixpkgs.vscodium
}

install_winget(){
    printf "\n$start_icon Installing $program using winget\n"
    
    winget install -e --id VSCodium.VSCodium
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    while getopts "lwdanh" OPTION; do
        case $OPTION in
            l) install_deb_alt  ;;
            w) install_winget   ;;
            d) install_deb      ;;
            a) install_apt      ;;
            n) install_nix      ;;
            h) display_usage    ;;
            ?) display_usage    ;;
        esac
    done
    shift $((OPTIND -1))
}

main $@
