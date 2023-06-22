#!/bin/bash

set -e

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)


# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    printf "\n $start_icon Adding profile and history to Powershell...\n\n"
    
    lib="$HOME/sh/windows"
    
    profile_dir=$HOME/Documents/WindowsPowerShell
    profile_file=Microsoft.PowerShell_profile.ps1

    history_dir=$HOME/AppData/Roaming/Microsoft/Windows/PowerShell/PSReadLine/
    history_file=ConsoleHost_history.bk

    cp $lib/$profile_file $profile_dir/$profile_file
    cp $lib/$history_file $history_dir/$history_file
}

main
