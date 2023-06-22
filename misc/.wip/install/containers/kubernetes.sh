#!/bin/bash

set -e

# Local Env
program=Kubernetes

# Icons
start_icon="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

# Prequisites:
disable_swap(){
    printf "\n$start_icon Disabling Swap\n"
    
    sudo swapoff -a
    sudo sed -i '/ swap / s/^/#/' /etc/fstab
}

get_docker(){
    printf "\n$start_icon Getting Docker dependencies\n"
    
    sudo apt install -y docker.io
}

get_curl(){
    printf "\n$start_icon Getting curl dependencies\n"
    
    sudo apt install -y apt-transport-https ca-certificates curl gpg
}

# Install options
get_kubernetes_alt(){
    
    local version=v1.29
    local api=https://pkgs.k8s.io/core:/stable:
    local keyrings=/etc/apt/keyrings/kubernetes-apt-keyring.gpg
    
    local key=$api/$version/deb/Release.key
    local repository="deb [signed-by=$keyrings] $api/$version/deb/ /"
    
    printf "\n$start_icon Setting up apt Repo for $program\n"
    
    # Add Repository Key
    curl -s $key | sudo apt-key add
    
    # Add Repository
    sudo apt-add-repository $repository
    sudo apt update
    
    printf "\n$start_icon Installing $program using apt\n"
    
    # Install Kubernetes
    sudo apt install -y kubelet kubeadm kubectl kubernetes-cni
    sudo apt-mark hold kubelet kubeadm kubectl kubernetes-cni
    sudo systemctl enable kubelet
    
}

get_kubernetes(){
    local version=v1.29
    
    local API=https://pkgs.k8s.io/core:/stable:
    local latest=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    
    local key=$API/$version/deb/Release.key
    local keyrings=/etc/apt/keyrings/kubernetes-apt-keyring.gpg
    
    printf "\n$start_icon Setting up apt Repo for $program\n"
    
    # Add Repository Key
    curl -fsSL $key | sudo gpg --dearmor -o $keyrings
    
    printf "\n$start_icon Installing $program using apt\n"
    
    # Install Kubernetes
    sudo apt install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
    sudo systemctl enable kubelet
}

# Manage Cluster
create_cluster(){
    local network=pod-network-cidr
    local configurations=https://docs.projectcalico.org/manifests/calico.yaml
    
    printf "\n$start_icon Creating new master cluster\n"
    
    # Initialize Kubernetes with kubeadm
    sudo kubeadm init --pod-network-cidr=$network
    
    # Set Up Kubectl
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    
    # Configure Pod Network
    kubectl apply -f $configurations
}

add_worker(){
    local master=""
    printf "\n$start_icon Adding workder to master node\n"
    
    kubeadm join $master
}


# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    # Prequisites
    sudo apt update && sudo apt upgrade -y
    disable_swap
    get_docker
    get_curl
    
    # Install Kubernetes
    get_kubernetes
    
    # (Optional) Create Master
    # create_cluster
}

main
