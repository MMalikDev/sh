#!/bin/bash

set -e

# Local Env
project="postcss"

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

# Set Variables
css=styles/index.css
content=html,js
development=src/
production=dist/

# Define source and target file mappings
declare -A file_mappings=(
    ["$lib/tailwind/postcss.config.js"]="postcss.config.js"
)

main(){
    # Install Tailwind CSS
    npm install -D tailwindcss postcss autoprefixer
    npx tailwindcss init
    
    # Add Tailwind to your PostCSS configuration
    initialize_project file_mappings
    
    # Configure your template paths
    file="tailwind.config.js"
    find="content: \[\],"
    replace="content: \[\"./$development**/*.{$content}\"\],"
    swap_snippets "$find" "$replace" "$file"
    
    ### Add the Tailwind directives to your CSS
    directives="@tailwind utilities;\n@tailwind components;\n@tailwind base;\n"
    prepend_snippets "$directives" "$development$css"
    
    # Start the Tailwind CLI build process
    npx tailwindcss -i ./$development$css -o ./$production$css
    
    cp ./$development*.{html,js} ./$production
}

main
