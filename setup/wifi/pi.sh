#!/bin/bash

set -e

# Local Env
program=Template

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

# Summary
display_usage(){
        cat << EOF

Usage: $0 [OPTIONS]

Template script for $(basename "$0" | cut -d. -f1)

    OPTIONs
        -l                          List Wifi Networks
        -a                          List Wifi Networks (Without nmcli)
        -c [network] [password]     Connect to Wifi Network
        -p [network]                Connect to Wifi Network (Prompt Password)
        -d [network]                Disconnect to Wifi Network
        -r [network]                Reconnect to Saved Wifi Network
        -s [network] [priority]     Set a Network's Priority
        -n                          Show all Network Priorities
        -i                          Show Active IP Interfaces
        -h                          Show this page

EOF
    
    exit 0
}


# OPTIONS
list_wifi_networks_alt(){
    printf "\n$start_icon Available Networks\n\n"
    sudo iwlist wlan0 scan | grep SSID

    printf "\n$start_icon Known Network Connections\n\n"
    ls /etc/NetworkManager/system-connections
}
list_wifi_networks(){
    printf "\n$start_icon Available Networks\n\n"
    nmcli dev wifi list

    printf "\n$start_icon Known Network Connections\n\n"
    nmcli con show
}

connect_wifi_prompt(){
    if [[ $# -eq 0 ]]; then
        echo "Usage: $(basename "$0") -p network" >&2
        return 1
    fi

    local network="$@"

    printf "\n$start_icon Connecting to the following wifi: $network\n\n"
    sudo nmcli --ask dev wifi connect "$network"
}
connect_wifi(){
    if [[ $# -lt 2 ]]; then
        echo "Usage: $(basename "$0") -c network password" >&2
        return 1
    fi

    local network="$1"
    local password="$2"

    printf "\n$start_icon Connecting to the following wifi: $network\n\n"
    sudo nmcli dev wifi connect "$network" password "$password"
}

diconnect_wifi(){
    if [[ $# -eq 0 ]]; then
        echo "Usage: $(basename "$0") -d <SSID or UUID>" >&2
        return 1
    fi

    local network="$@"

    printf "\n$start_icon Disonnecting to the following wifi: $network\n\n"	
    nmcli con down "$network"
}
reconnect_wifi(){
    if [[ $# -eq 0 ]]; then
        echo "Usage: $(basename "$0") -r <SSID or UUID>" >&2
        return 1
    fi

    local network="$@"

    printf "\n$start_icon Reconnecting to the following wifi: $network\n\n"
    nmcli con up "$network"
}


set_network_priority(){
    if [[ $# -eq 0 ]]; then
        echo "Usage: $(basename "$0") -s network priority" >&2
        return 1
    fi

    local network="$1"
    local priority=$2

    printf "\n$start_icon Setting Network Priority of '$network' to $priority\n\n"	
    sudo nmcli c mod "$network" conn.autoconnect-p $priority
}
show_network_priorities(){
    printf "\n$start_icon Network Priorities\n\n"	
    nmcli -f UUID,NAME,AUTOCONNECT-PRIORITY,TYPE,AUTOCONNECT c
}

check_ips(){
    printf "\n$start_icon Current IPv4 Address: $network\n\n"
    ip a | grep "inet " | awk "{print \$2}"
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    while getopts "lac:p:d:r:s:nih" OPTION; do
        case $OPTION in
            l) list_wifi_networks               ;;
            a) list_wifi_networks_alt           ;;
            c) connect_wifi $OPTARG             ;;
            p) connect_wifi_prompt $OPTARG      ;;
            d) diconnect_wifi $OPTARG           ;;
            r) reconnect_wifi $OPTARG           ;;
            s) set_network_priority $OPTARG     ;;
            n) show_network_priorities          ;;
            i) check_ips                        ;;
            h) display_usage                    ;;
            ?) display_usage                    ;;
        esac
    done
    shift $((OPTIND -1))
}

main $@
