#!/bin/bash

set -e

# Search settings
engine="google"
browser="www.$engine.com"

# Function to encode a URL
urlencode() {
    local string="${1}"
    local sub='+'
    
    echo -n "${string}" | sed "s/\s/$sub/g"
}

# Main
main() {
    # Check if there are no command-line arguments
    if [ $# -eq 0 ]; then
        echo "Usage: $0 '<search_query>'"
        echo No queries provide...
        
        exit 1
    fi
    
    query=$@
    encoded_query=$(urlencode "$query")
    link="https://$browser/search?q=$encoded_query"
    
    # Display information
    echo "Using $engine to look up: $query"
    echo "Opening: $link"
    
    # Open the link in the default web browser
    python3 -m webbrowser "$link"
    
    exit 0
}

main $@
