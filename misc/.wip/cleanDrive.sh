#!/bin/bash


helper_safe(){
    local selected_device="$1"
    
    # Ensure no errors during cleanup and formatting process
    if ! sudo parted -a optimal --script "/dev/${selected_device}" mklabel gpt || \
    ! sudo parted -a minimal --script "/dev/${selected_device}" mkpart primary fat32 0% 100%; then
        echo "Error occurred while cleaning up and formatting the device." >&2
        exit 1
    fi
    
    if ! sudo wipefs -af "/dev/${selected_device}" || \
    ! sudo mkfs.exfat -n MYVOLUME "/dev/${selected_device}1"; then
        echo "Error occurred while wiping the filesystem or creating the EXFAT filesystem." >&2
        exit 1
    fi
    
    if ! tune2fs -L MYVOLUME "/dev/${selected_device}1"; then
        echo "Error occurred while setting the volume label." >&2
        exit 1
    fi
}

helper(){
    local selected_device="$1"
    
    sudo parted -a optimal --script "/dev/$selected_device" mklabel gpt
    sudo parted -a minimal --script "/dev/$selected_device" mkpart primary fat32 0% 100%
    
    echo "Cleaning and formatting the partition as exFAT..."
    sudo wipefs -af "/dev/$selected_device" && sudo mkfs.exfat -n MYVOLUME "/dev/$selected_device"1
    
    echo "Assigning a file system label (MYVOLUME)..."
    tune2fs -L MYVOLUME "/dev/$selected_device"1
}

select_device(){
    echo "Available block devices:"
    lsblk -d -o name,size,type | sort -h
    
    prompt="Enter the number corresponding to the device you wish to operate on: "
    
    while true; do
        # Prompt user to choose a device
        read -rp $prompt dev_num
        
        # Check if input is valid
        if ! [[ "$dev_num" =~ ^[0-9]+$ ]]; then
            echo "Invalid input. Please try again."
            continue
        fi
        
        # Determine the selected device path
        selected_device=$(lsblk -d -n -o name | head -n "$dev_num")
        
        # Validate selection
        if [[ -z "$selected_device" ]]; then
            echo "Invalid selection. Please try again."
            continue
        else
            break
        fi
    done
    
    printf "Selected device: /dev/$selected_device\n"
    return ${selected_device}
}

perform_cleanup_and_formatting(){
    
    local selected_device="$1"
    
    helper_safe $selected_device
    printf "Done.\n"
    
}


main() {
    if [[ $(id -u) != 0 ]]; then
        echo "Please run this script as root or via 'sudo'." >&2
        exit 1
    fi
    
    selected_device=$(select_device)
    perform_cleanup_and_formatting "$selected_device"
}

main
