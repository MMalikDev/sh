#!/bin/bash

# set -e

# Local Env
program=Proxmox

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

# Prerequisites
update_packages(){
    printf "\n$start_icon Updating system packages\n"
    
    apt update
    apt upgrade -y
    apt autoremove
}

format_disk(){
    printf "\n$start_icon Formatting Disks\n"
    
    local disk=${@:-/dev/sda}
    fdisk $disk
}

customize_update(){
    printf "\n$start_icon Customizing update for $program\n"
    
    local version=${1:-version}
    local source=/etc/apt/sources.list.d
    local url=http://download.proxmox.com/debian/pve
    
    local line="deb $url $version pve-no-subscription"
    local file="$source/pve-no-enterprise.list"
    echo $line >> $file
    
    local line="pve-enterprise"
    local file="$source/pve-enterprise.list"
    sed -i "/$line/ s/^/#/" $file
    
    apt update
    apt dist-upgrade -Y
    reboot
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    update_packages
    customize_update
}

main
