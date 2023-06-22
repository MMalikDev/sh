# Bash
alias bh="cp ~/sh/.bash_history ~/.bash_history"                          # Reset history
alias br="cp ~/sh/.bash_aliases ~/.bashrc"                                # Apply aliases to gitbash
alias ag="alias | grep"                                                   # Find alias

# IDE
alias code="code --profile VSCode"                                        # VSCode default profile
alias codium="codium --profile VSCodium"                                  # VSCodium default profile

# Project
alias init="~/sh/init.sh"                                                 # Initialize project
alias re="bash reset.sh"                                                  # Reset project
alias r="bash run.sh"                                                     # Run project
alias run="re && r"                                                       # Reset & run project

# Docker
alias de="docker exec -it"                                                # Run command in docker container
alias dc="docker compose config"                                          # Check docker config
alias dr="docker compose up -d"                                           # Turn on docker services
alias dk="docker compose down --rmi all"                                  # Shutdown docker services

alias dp="echo y | docker system prune"                                   # Prune docker system
alias dpb="docker builder prune"                                          # Prune docker builds
alias dcp="docker compose pull"                                           # Pull all compose images

# Git
alias gl="git log --oneline"                                              # Git log
alias gf="git log --all --graph"                                          # Git log verbose
alias gn='echo $(basename `git rev-parse --show-toplevel`).git'           # Get current git repo name

alias gv="git remote -v"                                                  # Show verbose remote
alias gprivate='git remote add origin'                                    # Add private remote
alias gpublic='git remote add portfolio'                                  # Add public remote

alias gc="git commit -m"                                                  # Git commit
alias gca="git add . && gc"                                               # Git add and commit
alias g1="gca 'Initial Commit'"                                           # Git initial commit
alias gd="git diff --compact-summary HEAD~1"                              # Git diff last commit

alias gp="git push"                                                       # Git push
alias gpf="git push -f"                                                   # Git push force
alias gu="git push -u origin"                                             # Set upstream for new branch

alias ga="git add . && git commit --amend --no-edit"                      # Git amend changes
alias gad="ga && git gc && gpf"                                           # Git amend and force push
alias gr="git rebase -i"                                                  # Git rebase (gr head~#)

alias gitcb="code /etc/profile.d/git-prompt.sh"                           # Git bash edit
alias gcount="git rev-list --count --all"                                 # Git commit count
alias gps="git push origin -u"                                            # Set git push default
alias ghc="git remote set-head origin -d"                                 # Clear remote head

# System
alias cls="clear"                                                         # Habit accommodation
alias size="du -hd 1 . | sort -hr"                                        # List folder sizes
alias k="history -a && bh && exit 0"                                      # Close terminal
alias diffs="diff -y --suppress-common-lines"                             # Show deferences in columns
alias keygen="ssh-keygen -t ed25519"                                      # Create new ssh key using ed25519

alias kwsl="wsl --shutdown && wsl -l -v"                                  # End wsl instances
alias wslset="cd $HOME && wsl -e bash sh/setup/bash/wsl/sync.sh"          # Customize wsl bash

alias pset="bash $HOME/sh/windows/setup.sh"                               # Customize powershell

# Python
alias python3="python"                                                    # Windows alias
alias py="python3"                                                        # Python3 abbreviation
alias pipr="pip install -r"                                               # Install from file
alias pipf="pip freeze -l"                                                # Show pip packages
alias pipup="python3 -m pip install --upgrade pip"                        # Upgrade pip
alias venv="source .venv/Scripts/activate"                                # Use venv (windows)
alias venvnew="python3 -m venv .venv"                                     # Create venv
alias venvls="find -type d -name '*.venv*'"                               # Show all venv
alias venvdel='rm -rf `find -type d -name "*.venv*"`'                     # Delete all venv
alias pyclear='rm -rf `find -type d -name "*pycache*"`'                   # Delete all pycache

# Databases
alias redis="de redis       redis-cli -h localhost                     "  # Use DB CLI for redis in docker
alias mongo="de mongo       mongosh                        -u admin -p "  # Use DB CLI for mongo in docker
alias mysql="de mysql       mysql     -h localhost         -u root  -p "  # Use DB CLI for mysql in docker
alias pgsql="de postgres    psql      -h localhost -p 5432 -U admin -W "  # Use DB CLI for postgres in docker
