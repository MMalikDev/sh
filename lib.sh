#!/bin/bash


# Function to create folders from list
create_directories() {
    local -n array="$1"
    arraylength=${#array[@]}
    
    for (( i=0; i<${arraylength}; i++ )); do
        dir=${array[$i]}
        mkdir -p $dir
        echo "Folder Added: $dir"
    done
}

# Function to apply template files
apply_template() {
    source_file="$1"
    destination_file="$2"
    
    if [ -e "$source_file" ]; then
        cat "$source_file" >> "$destination_file"
        echo "Initialized: $destination_file"
    else
        echo "Error: $source_file does not exist." 1>&2
        exit 1
    fi
}

# Function to loop through file mappings and apply template files
initialize_project() {
    local -n mappings="$1"
    
    for source_file in "${!mappings[@]}"; do
        destination_file="${mappings[$source_file]}"
        apply_template "$source_file" "$destination_file"
    done
}

# Function to add dependencies to a file
add_dependencies() {
    local -n array="$1"
    local file="$2"
    
    printf "\nAdding dependencies to $file\n\n"
    for dependency in "${array[@]}"; do
        echo "$dependency" >> "$file"
        echo "$dependency" >> "$file"
        echo "Dependency Added: $dependency"
    done
}

# Add snippet to begining op a file
prepend_snippets() {
    local content="$1"
    local file="$2"
    
    if [ -e "$file" ]; then
        sed -i "1s~^~$content~" "$file"
        echo "Added content to the beginning of $file"
    else
        echo "Error: $file does not exist." 1>&2
        exit 1
    fi
}

# Function to swap file snippets
swap_snippets() {
    local find="$1"
    local replace="$2"
    local file="$3"
    
    if [ -e "$file" ]; then
        sed -i "s@$find@$replace@I" "$file"
        echo "Modified the content of $file"
    else
        echo "Error: $file does not exist." 1>&2
        exit 1
    fi
}

# Function to swap file snippets from dictionary
multi_swap() {
    local -n mappings="$1"
    local file="$2"
    
    for default in "${!mappings[@]}"; do
        custom="${mappings[$default]}"
        swap_snippets "$default" "$custom" "$file"
    done
}

# Function to encode a terminal string
string_encode() {
    local string="${1}"
    local sub='_'
    
    echo -n "${string}" | sed "s/\s/$sub/g"
}

# Function to encode a URL
urlencode() {
    local string="${1}"
    local sub='+'
    
    echo -n "${string}" | sed "s/\s/$sub/g"
}

# Function to comment out line from file
comment_out() {
    local line="$1"
    local file="$2"
    
    if [ -e "$file" ]; then
        sed -i "/$line/ s/^/#/" $file
        printf "Commented out the follwing line from $file: \n$line"
    else
        echo "Error: $file does not exist." 1>&2
        exit 1
    fi
}

# Function to copy file in docker to local dist
cp_docker(){
    local container=$1
    local source=$2
    local target=$3
    
    local containerID=$(docker-compose ps -qa $container)
    docker cp $containerID:$source $target
}

# Function to log error message
log_error() {
    echo "$1" 2>&1 # >> $LOGFILE
    exit 1
}

# Function template to run script based on OS
handle_os() {
    local script="$@"
    local os=$(uname | tr '[A-Z]' '[a-z]')
    
    case ${os} in
        linux*)
            printf "\n$icon_start Using Linux binary locally\n"
            ${script}
        ;;
        mingw* | cygwin*)
            if ! command -v wsl &> /dev/null; then
                log_error "$icon_start Please Turn on WSL to use this binary"
            fi
            printf "\n$icon_start Using Linux binary with WSL\n"
            wsl -e ${script}
        ;;
        darwin*) log_error "$icon_start This program doesn't yet support macOS system" ;;
        *) log_error "$icon_start Unsupported operating system: $os" ;;
    esac
}

# Function to export all .env variables
load_env(){
    set -a
    source .env
}

# Function to get .env variables
get() {
    echo $(grep -i "$@" .env | cut -d "=" -f 2)
}

# Function to get .env variables as boolean
get_bool() {
    local variable=$(get_env "$@" | tr '[A-Z]' '[a-z]')
    if [[ $variable =~ (1|true) ]]; then
        echo true
    else
        echo false
    fi
}

# Function to get random 32byte number in base64
get_random() {
    head -c32 /dev/urandom | base64
}

# Function to run local script on remote machine with ssh
remote_run() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: $(basename "$0") username hostname [args...]" >&2
        return 1
    fi
    
    local user="$1"
    local host="$2"
    shift 2
    
    ssh "$user@$host" 'bash -s' -- < run.sh $@
}
