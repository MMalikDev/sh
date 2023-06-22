#!/bin/bash

set -e

# Local Env
program=QEMU

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

# Summary
display_usage(){
        cat << EOF

Usage: $0 [OPTIONS]

Download options for $(basename "$0" | cut -d. -f1)

    OPTIONs
        -e             Enable systemd on WSL
        -c             Check Current Machine specs
        -i             Install qemu
        -a             Add user required groups
        -s             Enable QEMU at startup
        -n             Start default network
        -w             WSL install and setup
        -h             Show this page

EOF
    
    exit 0
}


# Prerequisites
enable_systemd(){
    printf "\n$start_icon Enabling systemd For WSL\n"
    
    printf "[boot]\nsystemd=true\n" >> wsl.conf
    sudo mv wsl.conf /etc/wsl.conf
}
check_specs(){
    printf "\n$start_icon Current machine specs\n"
    
    egrep -c '(vmx|svm)' /proc/cpuinfo | xargs echo Cores:
    lscpu | grep Virtualization
}

# Install
install_qemu(){
    printf "\n$start_icon Installing $program Packages\n"
    
    sudo apt update
    sudo apt install -y virt-manager qemu-system
    # sudo apt install libvirt-clients libvirt-daemon-system libvirt-daemon
    # sudo apt install qemu-kvm qemu-utils virtinst bridge-utils
    # sudo apt install python3 python3-pip
}
install_qemu(){
    printf "\n$start_icon Installing $program Packages\n"
    
    sudo apt update
    sudo apt install -y virt-manager qemu-system
}

# Setup
add_user(){
    printf "\n$start_icon Adding current user to libvirt groups\n"
    
    groups
    sudo usermod -aG libvirt-qemu $USER
    sudo useradd -aG libvirt-kvm $USER
    sudo usermod -aG libvirt $USER
    sudo usermod -aG kvm $USER
    sudo usermod -aG input $USER
    sudo usermod -aG disk $USER
}
start_default_network(){
    sudo virsh net-start default
    sudo virsh net-autostart default
    sudo virsh net-list --all
}
enable_startup(){
    printf "\n$start_icon Enabling libvirtd.service at startup\n"
    
    sudo systemctl enable libvirtd.service
    sudo systemctl start libvirtd.service
    sudo systemctl status libvirtd.service
}

wsl_install_and_setup(){
    enable_systemd
    check_specs
    
    install_qemu
    
    add_user
    enable_startup
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    while getopts "heciasnw" OPTION; do
        case $OPTION in
            e) enable_systemd           ;;
            c) check_specs              ;;
            i) install_qemu             ;;
            a) add_user                 ;;
            s) enable_startup           ;;
            n) start_default_network    ;;
            w) wsl_install_and_setup    ;;
            h) display_usage            ;;
            ?) display_usage            ;;
        esac
    done
    shift $((OPTIND -1))
}

main
