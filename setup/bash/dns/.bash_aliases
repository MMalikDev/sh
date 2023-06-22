# Find Alias
alias bh="cp ~/.bash_history.bk ~/.bash_history"
alias ag="alias | grep"

# Login
alias hush="sudo nano /etc/motd"
alias hushc="sudo nano /etc/pam.d/sshd"

# Docker
alias de="docker exec -it"
alias dr="docker compose up -d"
alias dc="docker compose config"
alias dk="docker compose down --rmi all"
alias dp="echo y | docker system prune"
alias dns="docker compose -f ~/Adguard/compose.yaml logs -f"

# System
alias show="apt show"                                                           # Packages Description
alias get="sudo apt install"                                                    # Install Packages
alias sim="apt install --simulate"                                              # Simulate Install
alias restart="sudo systemctl reboot"                                           # Restart Machine
alias update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove"    # Update Packages

alias cls="clear"                                                               # Habit Accommodation
alias ips='ip a | grep "inet " | awk "{print \$2}"'                             # Show All IpV4

alias edit="nano ~/.bash_history.bk"                                            # Edit History
alias k="history -a && cp ~/.bash_history.bk ~/.bash_history && exit 0"         # End Session

# Disto
alias distro='lsb_release -d | tail -n 1'                                       # Show Distro (Alt)
alias os='grep ^ID= /etc/os-release | cut -d "=" -f 2'                          # Show Distribution

# Temperature
alias temp="vcgencmd measure_temp"                                              # Get CPU Temperature

get_temp(){
    local temps=/sys/class/thermal/thermal_zone
    paste <(cat ${temps}*/type) <(cat ${temps}*/temp) \
    | column -s $'\t' -t | sed 's/\(.\)..$/.\1°C/'
}
