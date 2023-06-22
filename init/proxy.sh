#!/bin/bash

set -e

# Local Env
project="proxy"
workdir=proxy

lib="$HOME/lib"
functions="$HOME/sh/lib.sh"

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)
end_icon="\xF0\x9F\x91\x8D " # Thumbs Up Sign (U+1F44D)

# Messages
startup="\n$start_icon Applying custom template for $project\n\n"
success="\n$end_icon Script executed successfully.\n"

# Import functions from custom lib
source $functions

# Define necessary folders
declare -a folders=(
    "$workdir"
    "$workdir/config"
    "$workdir/config/traefik"
)

# Define source and target file mappings
declare -A file_mappings=(
    ["$lib/$project/labels.yaml"]="$project/labels.yaml"
    ["$lib/$project/compose.yaml"]="$project/compose.yaml"

    ["$lib/$project/config/provider.yaml"]="$project/config/provider.yaml"
    ["$lib/$project/config/traefik/traefik.yaml"]="$project/config/traefik/traefik.yaml"
)

main() {
    printf "$startup"
    
    # Call the function to add required folders
    create_directories folders
    
    # Call the function to initialize the project
    initialize_project file_mappings
    
    printf "$success"
}

main
