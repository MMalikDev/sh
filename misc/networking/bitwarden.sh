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
        -o      Show something
        -k      Create a CA key
        -c      Create a CA certificate:
        -b      Create a bitwarden key
        -r      Create the bitwarden certificate request file
        -f      Create a bitwarden text file for (bitwarden.ext)
        -s      Create the bitwarden certificate, signed from the root CA
        -h      Show this page

EOF
    
    exit 0
}

configs(){
    cat << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:TRUE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = $1
DNS.2 = $2
EOF
}

# OPTIONS
create_key(){
    # > Chrome needs the certificate to include the domain
    # name in the alternative name field of the certificate.
    
    openssl genpkey             \
    -outform PEM -algorithm RSA  \
    -aes128 -out private-ca.key   \
    -pkeyopt rsa_keygen_bits:2048
    
    # Note: instead of -aes128 you could also use the older -des3.
}
create_cert(){
    openssl req                         \
    -x509 -new -nodes -sha256 -days 3650 \
    -key private-ca.key -out ca-cert.crt
    
    # Note: the -nodes argument prevents setting a pass-phrase
    # for the private key (key pair) in a test/safe environment,
    # otherwise you'll have to input the pass-phrase every time
    # you start/restart the server.
}

create_bitwarden_key(){
    openssl genpkey             \
    -out bitwarden.key           \
    -outform PEM -algorithm RSA   \
    -pkeyopt rsa_keygen_bits:2048
}
create_bitwarden_cert(){
    openssl req -new \
    -key bitwarden.key -out bitwarden.csr
}
create_bitwarden_file(){
    local dns1=bitwarden.local
    local dns2=www.bitwarden.local
    
    configs $dns1 $dns2 > bitwarden.ext
}
create_bitwarden_signed_root_cert(){
    openssl x509 -req -in bitwarden.csr                 \
    -CA self-signed-ca-cert.crt -CAkey private-ca.key    \
    -CAcreateserial -out bitwarden.crt -days 365 -sha256  \
    -extfile bitwarden.ext
}
# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    while getopts "kcbrfsh" OPTION; do
        case $OPTION in
            k) create_key                           ;;
            c) create_cert                          ;;
            b) create_bitwarden_key                 ;;
            r) create_bitwarden_cert                ;;
            f) create_bitwarden_file                ;;
            s) create_bitwarden_signed_root_cert    ;;
            h) display_usage                        ;;
            ?) display_usage                        ;;
        esac
    done
    shift $((OPTIND -1))
    
}

main $@
