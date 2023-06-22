#!/bin/bash


display_usage() {
    cat << EOF
Usage: init [-h help] [-r initialize-root] [TEMPLATE]

Initialize given TEMPLATE
EOF
}

help() {
    display_usage
    cat << EOF
This script helps manage and run different templates from the '$(pwd)/init/' directory.

    OPTIONs
        -r                  Initialize the root template (use without specifying a name)
        -h                  Show this screen and exit

    Template management commands:
        INITIALIZE          Initializes a new instance of a template. Requires passing the template name as an argument.

    Examples:
        init mytemplate     Runs the 'mytemplate.sh' initialization script located at '$(pwd)/sh/init/'.
        init -r             Executes the '.root.sh' script which should be present in '$(pwd)/sh/init/.root.sh'.

EOF
    
    exit 0
}

init(){
    local template="$1"
    local source="${HOME}/sh/init"
    local file="${source}/${template}.sh"
    
    if [[ -n "$template" && -f "$file" ]]; then
        bash $file ${@:2}
    else
        printf "\nERROR: Invalid template name was provided"
        [[ -n "$template"  ]] && printf ": $template\n"
        printf "\n\nAvailable Templates:\n"
        ls -Rr1 --sort=extension $source | sed -e "s#$source\|\.sh\|:##g"
    fi
}

main(){
    while getopts "hr" OPTION; do
        case $OPTION in
            h) help                     ;;
            r) init ".root"             ;;
            ?) display_usage; exit 1    ;;
        esac
    done
    shift $((OPTIND -1))
    
    init $@
}

main $@
