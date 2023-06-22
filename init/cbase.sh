#!/bin/bash

set -e

# Local Env
project="cbase"
workdir=cbase

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
)

# Define source and target file mappings
declare -A file_mappings=(
    ["$lib/docker/.dockerignore"]="$workdir/.dockerignore"
    
    ["$lib/$project/Dockerfile"]="$workdir/Dockerfile"
    ["$lib/$project/compose.yaml"]="compose.yaml"
    
    ["$lib/$project/.env.example"]=".env.example"

    ["$lib/$project/main.c"]="$workdir/main.c"
)

main() {
    printf "$startup"
    
    # Call the function to add required folders
    create_directories folders
    
    # Call the function to initialize the project
    initialize_project file_mappings
    
    # Update env file
    cp .env.example .env
    
    printf "$success"
}

main
