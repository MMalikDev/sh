#!/bin/bash

set -e
# Local Env
program=Minikubes
API=https://storage.googleapis.com/minikube/releases/latest

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

# Install options (ARM64)
install_binary_arm64(){
    printf "\n$start_icon Installing $program using binary for arm64\n"
    
    curl -LO $API/minikube-linux-arm64
    sudo install minikube-linux-arm64 /usr/local/bin/minikube
}

install_deb_arm64(){
    printf "\n$start_icon Installing $program using deb for arm64\n"
    
    curl -LO $API/minikube_latest_arm64.deb
    sudo dpkg -i minikube_latest_arm64.deb
}

# Install options (x86-64)
install_binary(){
    printf "\n$start_icon Installing $program using binary\n"
    
    curl -LO $API/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
}

install_deb(){
    printf "\n$start_icon Installing $program using deb\n"
    
    curl -LO $API/minikube_latest_amd64.deb
    sudo dpkg -i minikube_latest_amd64.deb
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    sudo apt update
    install_binary
}

main
