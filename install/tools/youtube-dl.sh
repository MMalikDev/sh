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

Download options for $(basename "$0" | cut -d. -f1)

    OPTIONs
        -b             Download to bin executables
        -f             Download file to Download folder
        -d [FILEPATH]  Download youtube-dl to given FILEPATH
        -h             Show this page

EOF
    
    exit 0
}

# OPTIONS
download_youtube_dl(){
    local file="$1"
    local URL="https://yt-dl.org/downloads/latest/youtube-dl"
    
    sudo curl -L $URL -o $file
    sudo chmod a+rx $file
}
download_file(){
    local file="$HOME/Downloads/youtube-dl"
    download_youtube_dl $file
    # pip install youtube-dl
}
download_bin(){
    local file="/usr/local/bin/youtube-dl"
    download_youtube_dl $file
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    while getopts "hbfd:" OPTION; do
        case $OPTION in
            d) download_youtube_dl $OPTARG  ;;
            f) download_file                ;;
            b) download_bin                 ;;
            h) display_usage                ;;
            ?) display_usage                ;;
        esac
    done
    shift $((OPTIND -1))
}

main $@
