#!/bin/bash

set -e

# Local Env
program=vscode

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
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
}

install_deb_alt(){
    printf "\n$start_icon Installing $program using deb\n"
    
    local etc=/etc/apt/
    local pkg=packages.microsoft.gpg
    local src=https://packages.microsoft.com
    
    local repo=$src/repos/code
    local keyrings=$etc/keyrings/$pkg
    local keys=$src/keys/microsoft.asc
    local sources=$etc/sources.list.d/vscode.list/
    local signed="[arch=amd64,arm64,armhf signed-by=$keyrings]"
    
    sudo apt install wget gpg
    wget -qO- $keys | gpg --dearmor > $pkg
    sudo install -D -o root -g root -m 644 $pkg $keyrings
    sudo sh -c "echo 'deb $signed $repo stable main' > $sources"
    rm -f $pkg
}

install_apt(){
    printf "\n$start_icon Installing $program using apt\n"
    
    sudo apt update
    sudo apt install apt-transport-https
    sudo apt install code
}

install_nix(){
    printf "\n$start_icon Installing $program using nix-env\n"
    
    nix-env -i vscode
}

install_winget(){
    printf "\n$start_icon Installing $program using winget\n"
    
    winget install -e --id  Microsoft.VisualStudioCode --override '/SILENT /mergetasks="!runcode,!desktopicon,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath"'
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
