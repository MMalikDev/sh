#!/bin/bash

set -e


log_error() {
    echo "$1" 2>&1 # >> $LOGFILE
    exit 1
}

upgrade_pip(){
    if [ $# -eq 1 ]; then
        python3 -m pip install --upgrade pip
    fi
}

use_venv(){
    local os=$(uname | tr '[A-Z]' '[a-z]')

    case ${os} in
        linux* | darwin*) source .venv/bin/activate ;;
        mingw* | cygwin*) source .venv/Scripts/activate ;;
        *) log_error "$icon_start Unsupported operating system: $os" ;;
    esac
}

main() {
    # Remove Existing Virtual Environment
    rm -rf .venv
    
    # Create New Virtual Environment
    python3 -m venv .venv
    use_venv

    # (Optional) - Upgrade pip
    upgrade_pip $1
    
    # Download Dependencies
    pip install -r requirements/core.txt
    pip freeze -l > requirements/versions.txt
}

main $@
