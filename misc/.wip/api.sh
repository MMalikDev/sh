#!/bin/bash

# set -e

# Icons
icon_start="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)
icon_failed="\u274C " # Cross Mark (U+274C)
icon_success="\u2705 " # Check Mark (U+2705)

# Summary
display_usage(){
        cat << EOF

Usage: $0 [OPTIONS]

Template script for $(basename "$0" | cut -d. -f1)

    OPTIONs
        -f          Fetch data from API
        -c          Check expected metadata
        -h          Show this page

EOF
    
    exit 0
}

# OPTIONS
get_data(){
    printf "\n$icon_start Fetching data from API...\n\n" ; exit 0
    
    local API=https://localhost/api
    local limit=100000
    local delay=0s
    
    for i in {a..z}; do
        local URL="$API/$i?&limit=$limit"
        local file="data/$i.json"
        
        printf "\n$icon_start Getting data for : $i\n\n"
        curl -o $file $URL
        sleep $delay
    done
    
    exit 0
}

get_metadata(){
    printf "\n$icon_start Checking expected metadata..\n\n" ; exit 0
    
    local file="data.json"
    local entries=$(grep -c entry $file)
    local totalResults=$(grep totalResults $file | awk '{printf $4}')
    
    cd data
    printf "\n\nTotal word count: "
    ls | wc -l | xargs printf "%'d\n"
    
    exit 0
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    while getopts "fch" OPTION; do
        case $OPTION in
            f) get_data         ;;
            c) get_metadata     ;;
            h) display_usage    ;;
            ?) display_usage    ;;
        esac
    done
    shift $((OPTIND -1))
}

main $@
