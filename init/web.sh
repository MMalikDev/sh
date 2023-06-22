#!/bin/sh

set -e

# Local Env
project="webpage"

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
    dist
    src
    
    src/styles
    src/assets
    src/components
)

# Define source and target file mappings
declare -A file_mappings=(
    ["$lib/web/index.js"]='src/index.js'
    ["$lib/web/index.html"]='src/index.html'
    
    ["$lib/web/assets/logo.svg"]="src/assets/logo.svg"
    ["$lib/web/assets/menu.svg"]="src/assets/menu.svg"
    ["$lib/web/assets/favicon.svg"]='src/assets/favicon.svg'
    
    ["$lib/web/styles/index.css"]='src/styles/index.css'
    ["$lib/web/styles/reset.css"]='src/styles/reset.css'
    
    ["$lib/web/styles/variables.css"]='src/styles/variables.css'
    ["$lib/web/styles/utilities.css"]='src/styles/utilities.css'
    ["$lib/web/styles/landmarks.css"]='src/styles/landmarks.css'
)

main() {
    printf "$startup"
    
    # Add Markdown
    touch README.md
    
    # Call the function to add required folders
    create_directories folders
    
    # Call the function to initialize the project
    initialize_project file_mappings
    
    printf "$success"
}

main
