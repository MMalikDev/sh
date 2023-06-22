#!/bin/bash

set -e

# Helpers Functions
zip(){
    gzip -r -k $1
}
unzip(){
    gzip -d $1
}

archvive(){
    tar -cf  $1
}
unarchvive(){
    tar -xf $1
}


compress(){
    zip $1
    archvive "$1.tar"
    # tar -czf "$1.tar.gz" $1
}
uncompress(){
    unzip $1
    unarchvive "$1.tar"
    # tar -xf "$1.tar.gz"
}


# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    local file="$1"
    
    if [ -e "$file" ]; then
        echo Compression Template
    else
        echo "Error: $file does not exist."
        exit 1
    fi
}

main $@
