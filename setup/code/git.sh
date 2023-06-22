#!/bin/bash

set -e

# Local Env
program=Git

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

# Helper Function
swap_snippets() {
    local find="$1"
    local replace="$2"
    local file="$3"
    
    if [ -e "$file" ]; then
        sed -i "s@$find@$replace@I" "$file"
        echo "Modified the content of $file"
    else
        echo "Error: $file does not exist."
        exit 1
    fi
}

comment_out() {
    local line="$1"
    local file="$2"
    
    if [ -e "$file" ]; then
        sed -i "/$line/ s/^/#/" $file
        printf "Commented out the follwing line from $file: \n$line"
    else
        echo "Error: $file does not exist."
        exit 1
    fi
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    local file=/etc/profile.d/git-prompt.sh
    
    local find="\[\033[33m\]'       # change to brownish yellow"
    local replace="\[\033[36m\]'       # change to cyan"
    swap_snippets  $find $replace $file
    
    comment_out "change to purple" $file
    comment_out "show MSYSTEM" $file
}

main
