#!/bin/bash

set -e

# Local Env
project="python"
workdir=src

lib="$HOME/lib"
scripts="$HOME/sh"
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
    
    "$workdir/lib"
    "$workdir/logs"
)

# Define source and target file mappings
declare -A file_mappings=(
    ["$lib/docker/.dockerignore"]="$workdir/.dockerignore"
    
    ["$lib/$project/docker/Dockerfile"]="$workdir/Dockerfile"
    ["$lib/$project/docker/compose.yaml"]="compose.yaml"
    
    ["$lib/$project/.env.example"]=".env.example"
    
    ["$lib/$project/lib/utilities.py"]="$workdir/lib/utilities.py"
    ["$lib/$project/main.py"]="$workdir/main.py"
)

# Create Virtual Environment for development convenience
initialize_venv () {
    printf "\n$start_icon Creating Local Python Venv...\n\n"
    
    mkdir requirements
    
    apply_template "$lib/$project/requirements/core.txt" requirements/core.txt
    bash "$scripts/venv.sh"
    
    mv requirements "$workdir/requirements"
    
    printf "\n$end_icon Venv ready to go.\n\n"
}

main() {
    printf "$startup"
    
    # Call the function to add required folders
    create_directories folders
    
    # Call the function to setup dev venv
    initialize_venv
    
    # Call the function to initialize the project
    initialize_project file_mappings
    
    # Update env file
    cp .env.example .env
    
    printf "$success"
}

main
