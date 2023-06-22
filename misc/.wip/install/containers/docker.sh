#!/bin/bash

set -e

# Local Env
program=Docker

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

# Prerequisites
remove_old(){
    printf "\n$start_icon remove old $program install\n"
    
    sudo apt remove docker-desktop
    sudo apt purge docker-desktop
    
    rm -r $HOME/.docker/desktop
    sudo rm /usr/local/bin/com.docker.cli
}

get_gnome(){
    printf "\n$start_icon Getting gnome dependencies\n"
    
    sudo apt install -y gnome-terminal
}

get_curl(){
    printf "\n$start_icon Getting curl dependencies\n"
    
    sudo apt install -y apt-transport-https ca-certificates curl gpg
}

# Setup options
setup_apt(){
    local url="https://download.docker.com/linux/debian"
    local keyrings="/etc/apt/keyrings/docker.gpg"
    local official="$url/gpg"
    
    local architecture=$(dpkg --print-architecture)
    local version=$(. /etc/os-release && echo "$VERSION_CODENAME")
    
    printf "\n$start_icon Setting up apt Repo for $program\n"
    
    # Add Docker's official GPG key:
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL $official| sudo gpg --dearmor -o $keyrings
    sudo chmod a+r $keyrings
    
    # Add the repository to APT sources:
    echo "deb [arch=$architecture signed-by=$keyrings] $url $version stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
}

# Install options
install_latest(){
    printf "\n$start_icon Installing $program using apt\n"
    
    sudo apt install -y docker-ce docker-ce-cli
    sudo apt install -y containerd.io docker-buildx-plugin docker-compose-plugin
}

install_version(){
    local VERSION_STRING=""
    printf "\n$start_icon Installing $program ($VERSION_STRING) using apt\n"
    
    sudo apt install -y docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING
    sudo apt install -y containerd.io docker-buildx-plugin docker-compose-plugin
}

list_versions(){
    printf "\n$start_icon Listing all available $program version\n"
    
    apt-cache madison docker-ce | awk '{ print $3 }'
}

add_user(){
    printf "\n$start_icon Add current user ($USER) to $program group\n"
    
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    # Update Repository
    sudo apt update && sudo apt upgrade -y
    
    ## Prequisites
    remove_old
    get_gnome
    get_curl
    
    # Install Docker
    setup_apt
    install_latest
    
    add_user
    
    # Validate Docker
    docker --version
    docker compose version
}

main
