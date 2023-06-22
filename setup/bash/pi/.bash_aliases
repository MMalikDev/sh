# Find Alias
alias ag="alias | grep"

# Login
alias hush="sudo nano /etc/motd"
alias hushc="sudo nano /etc/pam.d/sshd"                                         # Comment out motd=/run/motd.dynamic

# System
alias cls="clear"                                                               # Habit Accommodation
alias distro='lsb_release -d | tail -n 1'                                       # Show Distro (Alt)
alias os='grep ^ID= /etc/os-release | cut -d "=" -f 2'                          # Show Distribution
alias status="systemctl status"                                                 # Get Program Status
alias ports="ss -ltup"                                                          # Show Listeing UDP and TCP ports

alias edit="nano ~/.bash_history.bk"                                            # Edit History
alias ips='ip a | grep "inet " | awk "{print \$2}"'                             # Show All IpV4
alias k="history -a && cp ~/.bash_history.bk ~/.bash_history && exit 0"         # End Session

# Packages
alias lst="apt list"                                                            # Check if Packages is Install
alias show="apt show"                                                           # Packages Description
alias sim="apt install --simulate"                                              # Simulate Install

# Sudo
alias update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove"    # Update Packages
alias restart="sudo systemctl reboot"                                           # Restart Machine
alias get="sudo apt install"                                                    # Install Packages


# Temperature
alias temp="vcgencmd measure_temp"                                              # Get CPU Temperature

get_temp(){
    local temps=/sys/class/thermal/thermal_zone
    paste <(cat ${temps}*/type) <(cat ${temps}*/temp) \
    | column -s $'\t' -t | sed 's/\(.\)..$/.\1°C/'
}
