#!/bin/bash

set -e

# Local Env
program="Tails OS"
version=tails-amd64-5.21

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

verify_signing_key(){
    printf "\n$start_icon Verify $program signing key\n"
    
    # Import the Tails signing key in your GnuPG keyring:
    wget https://tails.net/tails-signing.key
    gpg --import < tails-signing.key
    
    # Install the Debian keyring. It contains the OpenPGP keys of all Debian developers:
    sudo apt update && sudo apt install debian-keyring
    
    # Import the OpenPGP key of Chris Lamb, a former Debian Project Leader, from the Debian keyring into your keyring:
    gpg --keyring=/usr/share/keyrings/debian-keyring.gpg --export chris@chris-lamb.co.uk | gpg --import
    
    # Verify the certifications made on the Tails signing key:
    gpg --keyid-format 0xlong --check-sigs A490D0F4D311A4153E2BB7CADBB802B258ACD84F
    
    # In the output of this command, look for the following line:
    # sig!2 0x1E953E27D4311E58 2020-03-19  Chris Lamb <chris@chris-lamb.co.uk>
    # Here, sig!2 means that Chris Lamb verified and certified the Tails signing key wit
    
    # Certify the Tails signing key with your own key:
    gpg --lsign-key A490D0F4D311A4153E2BB7CADBB802B258ACD84F
    
}

download_tails(){
    printf "\n$start_icon Downloading $program image\n"
    
    wget --continue https://download.tails.net/tails/stable/$version/$version.img
}

verify_download(){
    printf "\n$start_icon Verifying $program image\n"
    
    # Download the signature of the USB image:
    wget https://tails.net/torrents/files/$version.img.sig
    
    # Verify that the USB image is signed by the Tails signing key:
    TZ=UTC gpg --no-options --keyid-format long --verify $version.img.sig $version.img
    
    # Verify in this output that:
    # - The date of the signature is the same.
    # - The signature is marked as Good signature
    #   since you certified the Tails signing key with your own key.
    
}

install_tails(){
    local image=~/$version.img
    local device=/dev/sdb
    
    printf "\n$start_icon Installing $program image on $device\n"
    
    sudo dd if=$image of=$device bs=16M oflag=direct status=progress
}

list_usbs(){
    printf "\n$start_icon Listing currently connected storage devices\n"
    
    ls -1 /dev/sd?
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    list_usbs
    
    # verify_signing_key
    
    download_tails
    verify_download
    install_tails
}

main
