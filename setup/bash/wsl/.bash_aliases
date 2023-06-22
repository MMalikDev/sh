# Find Alias
alias br="cp ~/.bash_history.bk ~/.bash_history"
alias ag="alias | grep"

# Project
alias init="~/sh/init.sh"                                                       # Initialize Project
alias re="bash reset.sh"                                                        # Reset Project
alias r="bash run.sh"                                                           # Run Project
alias run="re && r"                                                             # Reset & Run Project

# Package Manager
alias show="apt show"                                                           # Packages Description
alias get="sudo apt install"                                                    # Install Packages
alias sim="apt install --simulate"                                              # Simulate Install
alias update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove"    # Update Packages

# System
alias cls="clear"                                                               # Habit Accommodation
alias distro='lsb_release -d'                                                   # Show Distro (Alt)
alias os='grep ^ID= /etc/os-release | cut -d "=" -f 2'                          # Show Distribution

alias edit="nano ~/.bash_history.bk"                                            # Edit History
alias ips='ip a | grep "inet " | awk "{print \$2}"'                             # Show All IpV4

alias k="history -a && cp ~/.bash_history.bk ~/.bash_history && exit 0"         # End Session

# Ansible
alias set_ansible="export ANSIBLE_CONFIG=./ansible.cfg"                         # Set Ansible dev config
alias play="ansible-playbook"                                                   # Shortcut for Ansible Playbook
