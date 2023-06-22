#!/bin/bash

set -e

# Local Env
project="docker"

lib="$HOME/lib/docker"
functions="$HOME/sh/lib.sh"

# Import functions from custom lib
source $functions

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)
end_icon="\xF0\x9F\x91\x8D " # Thumbs Up Sign (U+1F44D)

# Messages
startup="\n$start_icon Applying custom template for $project\n\n"
success="\n$end_icon Script executed successfully.\n"

# Define source and target file mappings
declare -A file_mappings=(
    ["$lib/templates/compose.yaml"]="compose.yaml"
    ["$lib/.dockerignore"]=".dockerignore"
    ["$lib/Dockerfile"]="Dockerfile"
)

main() {
    printf "$startup"
    initialize_project file_mappings
    printf "$success"
}

main
