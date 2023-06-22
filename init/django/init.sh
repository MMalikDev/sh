#!/bin/bash

set -e

# Local Env
project="django"
common='common'
workdir=server

lib="$HOME/lib"
scripts="$HOME/sh"
functions="$scripts/lib.sh"
requirements="$workdir/requirements/core.txt"

# Script
venv="$scripts/init/venv.sh"
app="$scripts/init/$project/app.sh"

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)
end_icon="\xF0\x9F\x91\x8D " # Thumbs Up Sign (U+1F44D)

# Messages
startup="\n$start_icon Applying custom template for $project\n\n"
success="\n$end_icon Script executed successfully.\n"

# ---------------------------------------------------------------------- #
# Import functions from custom lib
# ---------------------------------------------------------------------- #
source $functions

# ---------------------------------------------------------------------- #
# Define dependencies
# ---------------------------------------------------------------------- #
declare -a dependencies=(
    "django-environ"
    "Django"
)

# ---------------------------------------------------------------------- #
# Define necessary folders
# ---------------------------------------------------------------------- #
declare -a folders=(
    "$workdir"
    "$workdir/requirements/"
    
    "$workdir/staticfiles/"
    
    "$workdir/static/"
    "$workdir/static/assets/"
    "$workdir/static/css/"
    "$workdir/static/js/"
    
    "$workdir/apps/"
    "$workdir/templates/"
    "$workdir/templates/components"
    "$workdir/templates/components/icon"
)

# ---------------------------------------------------------------------- #
# Define source and target file mappings
# ---------------------------------------------------------------------- #
declare -A file_mappings=(
    ["$lib/docker/.dockerignore"]="$workdir/.dockerignore"
    ["$lib/$project/docker/Dockerfile"]="$workdir/Dockerfile"
    ["$lib/$project/docker/docker.sh"]="$workdir/docker.sh"
    ["$lib/$project/docker/compose.yaml"]="compose.yaml"
    
    ["$lib/$project/.env.example"]=".env.example"
    
    ["$lib/$project/templates/core.html"]="$workdir/templates/core.html"
    ["$lib/$project/templates/base.html"]="$workdir/templates/base.html"
    
    ["$lib/$project/templates/components/footer.html"]="$workdir/templates/components/footer.html"
    ["$lib/$project/templates/components/header.html"]="$workdir/templates/components/header.html"
    ["$lib/$project/templates/components/navigation.html"]="$workdir/templates/components/navigation.html"
    
    ["$lib/$project/templates/components/icon/logo.html"]="$workdir/templates/components/icon/logo.html"
    ["$lib/$project/templates/components/icon/menu.html"]="$workdir/templates/components/icon/menu.html"
    
    ["$lib/web/index.js"]="$workdir/static/js/index.js"
    ["$lib/web/styles/index.css"]="$workdir/static/css/index.css"
    ["$lib/web/styles/reset.css"]="$workdir/static/css/reset.css"
    ["$lib/web/styles/variables.css"]="$workdir/static/css/variables.css"
    ["$lib/web/styles/utilities.css"]="$workdir/static/css/utilities.css"
    ["$lib/web/styles/landmarks.css"]="$workdir/static/css/landmarks.css"
    
    ["$lib/web/assets/favicon.svg"]="$workdir/static/favicon.svg"
    ["$lib/web/assets/logo.svg"]="$workdir/static/assets/logo.svg"
    ["$lib/web/assets/menu.svg"]="$workdir/static/assets/menu.svg"
)

declare -A app_mappings=(
    ["$lib/$project/templates/index.html"]="$workdir/apps/$common/templates/$common/index.html"
)

# ---------------------------------------------------------------------- #
# Define snippet mappings
# ---------------------------------------------------------------------- #
declare -A settings=(
    # Imports
    ["from pathlib import Path"]="from pathlib import Path\nfrom environ import Env\n\nenv \= Env()\nEnv.read_env()"
    
    # Set Env Variables
    ["SECRET_KEY \="]="SECRET_KEY \= env('SECRET_KEY') \n#"
    ["DEBUG \="]="DEBUG \= env.bool('DEBUG') \n#"
    ["ALLOWED_HOSTS \="]="ALLOWED_HOSTS \= env.list('ALLOWED_HOSTS') \n#"
    
    # Apps Setup
    ["INSTALLED_APPS \= \["]="LOCAL_APPS = \[\]\n\nTHIRD_PARTY_APPS = \[\]\n\nDEFAULT_APPS \= \["
    ["MIDDLEWARE \= \["]="INSTALLED_APPS \= DEFAULT_APPS \+ THIRD_PARTY_APPS \+ LOCAL_APPS\n\nMIDDLEWARE \= \["
    
    
    # Template Setup
    ["TEMPLATES \= \["]="APP_URL \= BASE_DIR \/ 'apps'\nTEMPLATES_URL \= 'templates\/'\n\nTEMPLATES \= \["
    ["'DIRS'\: \["]="'DIRS'\: \[\n\t\t\tBASE_DIR \/ TEMPLATES_URL,\n\t\t"
    
    # Static Setup
    ["STATIC_URL \= 'static/'"]="STATIC_URL \= 'static/'\nSTATIC_ROOT \= BASE_DIR \/ 'staticfiles\/'\nSTATICFILES_DIRS \= [\n\tBASE_DIR \/ 'static',\n]"
)

declare -A urls=(
    # Imports
    ["from django.urls import path"]="from django.urls import path, include"
    
    # Default Root
    ["]"]="\tpath('', include('apps.$common.urls')),\n]"
)

declare -A root=(
    # Make Root the common index
    ["path('$common\/'"]="path(''"
)

# ---------------------------------------------------------------------- #
# Scoped function
# ---------------------------------------------------------------------- #
create_new_project () {
    printf "\n$start_icon Creating new Django Project...\n\n"
    
    # Create Virtual Environment to use django locally if necessary
    bash "$venv" "$workdir"
    source .venv/Scripts/activate
    
    # Start Django Project
    django-admin startproject config "$workdir"
    
    # Add Custom Snippets
    add_snippets
    
    printf "\n$end_icon New Django Project is ready.\n\n"
}

add_snippets() {
    printf "\n$start_icon Adding Custom Snippets...\n\n"
    
    # Alter settings.py
    file="$workdir/config/settings.py"
    multi_swap settings "$file"
    
    # Alter urls.py
    file="$workdir/config/urls.py"
    multi_swap urls "$file"
    
    printf "\n$end_icon Custom snippets added core config.\n\n"
}

add_common_app() {
    printf "\n$start_icon The $common app is being setup.\n\n"
    
    # Add the common app
    bash $app $common
    
    # Add default common files
    initialize_project app_mappings
    
    # Alter urls.py
    file="$workdir/config/urls.py"
    multi_swap root_urls "$file"
    
    printf "\n$end_icon The $common app is fully setup.\n\n"
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main() {
    printf "$startup"
    
    # Create project Folders
    create_directories folders
    
    # Add requirements for Django@latest
    add_dependencies dependencies "$requirements"
    
    # Initialize Project
    create_new_project
    initialize_project file_mappings
    
    # Update env file
    cp .env.example .env
    
    # Setup the common app
    add_common_app
    
    printf "$success"
}

main
