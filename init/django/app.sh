#!/bin/bash

set -e

# Local Env
project="Django App"
workdir=server

lib="$HOME/lib"
scripts="$HOME/sh"
functions="$scripts/lib.sh"

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
# Define source and target file mappings
# ---------------------------------------------------------------------- #
declare -A file_mappings=(
    ["$lib/django/common/views.py"]="views.py"
    ["$lib/django/common/urls.py"]="urls.py"
)

# ---------------------------------------------------------------------- #
# Scoped function
# ---------------------------------------------------------------------- #
create_app() {
    printf "\n$start_icon Creating the $1 app...\n\n"
    
    # Create app in apps folder and cd into it
    cd apps/
    django-admin startapp $1
    cd $1/
    
    # Add required folders
    declare -a folders=(
        "static/"
        "static/$1"
        "templates/"
        "templates/$1"
    )
    create_directories folders
    
    # Initialize the app base on template
    initialize_project file_mappings
    
    # Adding App name to file
    add_app_name $1
    
    # Retrun to root
    cd ../../
    
    printf "\n$end__icon The $1 app is now started.\n"
}

add_app_name(){
    printf "\n$start_icon Matching the $1 app name in file...\n\n"
    
    # Alter urls.py
    file="urls.py"
    declare -A url_name=(
        # Create a app_name to refer to this app
        ["app_name = <placeholder>"]="app_name = '$1'"
    )
    multi_swap url_name "$file"
    
    # Alter apps.py
    file="apps.py"
    declare -A app_name=(
        # Adjsit the name to account for the custom folder structure
        ["name = '$1'"]="name = 'apps.$1'"
    )
    multi_swap app_name "$file"
    
    printf "\n$end__icon The $1 app is now named properly.\n"
}

add_to_config() {
    printf "\n$start_icon Adding the $1 app to core settings.\n\n"
    
    # Alter settings.py
    file="config/settings.py"
    declare -A setting=(
        # Add to Local Apps
        ["LOCAL_APPS = \["]="LOCAL_APPS = \[\n\t'apps.$1',"
        
        # Add to templates
        ["BASE_DIR / TEMPLATES_URL,"]="BASE_DIR / TEMPLATES_URL,\n\t\t\tAPP_URL / '$1' / TEMPLATES_URL,"
    )
    multi_swap setting "$file"
    
    # Alter urls.py
    file="config/urls.py"
    declare -A urls=(
        # Add to urls path
        ["]"]="\tpath('$1\/', include('apps.$1.urls')),\n]"
    )
    multi_swap urls "$file"
    
    printf "\n$end__icon The $1 app is now ready.\n"
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main() {
    printf "$startup"
    
    # Put all input into string
    input=$@
    
    # Make app name terminal friendly
    name=$(string_encode "$input")
    
    # Makes sure you are in Venv
    source .venv/Scripts/activate
    
    # Create new App
    cd $workdir
    create_app $name
    add_to_config $name
    cd ..
    
    printf "$success"
}

main $@
