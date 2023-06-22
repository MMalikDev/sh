#!/bin/bash

set -e

# Local Env
project="svelte"
workdir=web

functions="$HOME/sh/lib.sh"
lib="$HOME/lib"

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
declare -a template_folders=(
    static
    static/styles
    static/assets
    static/placeholder
    
    src
    src/routes
    src/routes/common
    
    src/lib
    src/lib/data
    src/lib/utils
    src/lib/components
    src/lib/components/icons
    src/lib/components/buttons
)

# Define source and target file mappings
declare -A file_mappings=(
    ["$lib/docker/.dockerignore"]="$workdir/.dockerignore"
    
    ["$lib/$project/docker/Dockerfile"]="$workdir/Dockerfile"
    ["$lib/$project/docker/compose.yaml"]="compose.yaml"
    
    ["$lib/$project/.env.example"]=".env.example"
)
declare -A template_mappings=(
    ["$lib/$project/.npmrc"]=".npmrc"
    
    ["$lib/$project/src/app.html"]="src/app.html"
    ["$lib/$project/src/routes/+page.svelte"]="src/routes/+page.svelte"
    ["$lib/$project/src/routes/+error.svelte"]="src/routes/+error.svelte"
    ["$lib/$project/src/routes/+layout.svelte"]="src/routes/+layout.svelte"
    
    ["$lib/$project/src/routes/common/+page.svelte"]="src/routes/common/+page.svelte"
    
    ["$lib/$project/lib/data/index.js"]="src/lib/data/index.js"
    ["$lib/$project/lib/utils/useViewport.js"]="src/lib/utils/useViewport.js"
    
    ["$lib/$project/lib/index.js"]="src/lib/index.js"
    ["$lib/$project/lib/components/Footer.svelte"]="src/lib/components/Footer.svelte"
    ["$lib/$project/lib/components/Header.svelte"]="src/lib/components/Header.svelte"
    ["$lib/$project/lib/components/Navigation.svelte"]="src/lib/components/Navigation.svelte"
    
    ["$lib/$project/lib/components/icons/Logo.svelte"]="src/lib/components/icons/Logo.svelte"
    ["$lib/$project/lib/components/buttons/Menu.svelte"]="src/lib/components/buttons/Menu.svelte"
    ["$lib/$project/lib/components/buttons/SkipNav.svelte"]="src/lib/components/buttons/SkipNav.svelte"
    
    ["$lib/$project/styles/index.css"]="static/styles/index.css"
    
    ["$lib/web/styles/variables.css"]="static/styles/variables.css"
    ["$lib/web/styles/reset.css"]="static/styles/reset.css"
    
    ["$lib/web/assets/favicon.svg"]="static/favicon.svg"
    ["$lib/web/assets/logo.svg"]="static/assets/logo.svg"
    ["$lib/web/assets/menu.svg"]="static/assets/menu.svg"
)

# ---------------------------------------------------------------------- #
# Define snippet mappings
# ---------------------------------------------------------------------- #
declare -A packages=(
    # Scripts
    ['"scripts": {']='"scripts": {\n\t\t"start": "vite --host --port ${WEB_PORT:-80}",'
)


main() {
    printf "$startup"
    
    # Call the function to add required folders and files
    create_directories folders
    initialize_project file_mappings
    
    # Update env file
    cp .env.example .env
    
    # Initialize svelte project
    cd $workdir
    npm create svelte@latest .
    
    # Reset Template
    rm -rf src static
    
    # Apply custom version
    multi_swap packages package.json
    create_directories template_folders
    initialize_project template_mappings
    
    # Install packages locally
    npm install
    
    printf "$success"
}

main
