
#!/bin/bash

set -e

# Local Env
program=VSCode

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

display_usage(){
        cat << EOF

Usage: $0 [OPTIONS]

Setup script for $(basename "$0" | cut -d. -f1)

    OPTIONs
        -g Generate extensions install script
        -w Install extensions for window
        -l Install extensions for linux
        -e Show installed extensions
        -h Show this page

EOF
    
    exit 0
}

# OPTIONS
get_extensions_window(){
    printf "\n$start_icon Getting $program extensions on window\n"
    
    code --list-extensions > vscode-extensions.list
}

install_extensions_linux(){
    printf "\n$start_icon Getting $program extensions on linux\n"
    
    cat vscode-extensions.list | xargs -L 1 code --install-extension
}

install_extensions_window(){
    printf "\n$start_icon Installing $program extensions on window\n"
    
    Get-Content vscode-extensions.list | ForEach-Object { code --install-extension $_ }
}

generate_extensions_install_script() {
    local file=extensions.sh
    local install="code --install-extension "
    printf "\n$start_icon Generating Installation script for $program extensions\n"
    
    code --list-extensions | xargs -L 1 echo $install > $file
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    while getopts "gwleh" OPTION; do
        case $OPTION in
            g) generate_extensions_install_script   ;;
            w) install_extensions_window            ;;
            l) install_extensions_linux             ;;
            e) get_extensions                       ;;
            h) display_usage                        ;;
            ?) display_usage                        ;;
        esac
    done
    shift $((OPTIND -1))
}

main $@
