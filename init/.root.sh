#!/bin/bash

set -e

# Local Env
project="project root"

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
    scripts
    .devcontainer
)

# Define source and target file mappings
declare -A file_mappings=(
    ["$lib/.gitignore"]=".gitignore"
    
    ["$lib/scripts/run.sh"]="run.sh"
    ["$lib/scripts/reset.sh"]="reset.sh"
    ["$lib/scripts/lib/run.sh"]="scripts/run.sh"
    ["$lib/scripts/lib/reset.sh"]="scripts/reset.sh"
    
    ["$lib/docker/.env.example"]=".env.example"
    ["$lib/docker/compose.yaml"]="compose.yaml"
    
    ["$lib/.devcontainer/Dockerfile"]=".devcontainer/Dockerfile"
    ["$lib/.devcontainer/compose.yaml"]=".devcontainer/compose.yaml"
    ["$lib/.devcontainer/devcontainer.json"]=".devcontainer/devcontainer.json"
)

main() {
    printf "$startup"
    
    # Call the function to add required folders
    create_directories folders
    
    # Call the function to initialize the project
    initialize_project file_mappings
    
    # Setup env and git
    cp .env.example .env
    git init
    
    printf "$success"
}

main
