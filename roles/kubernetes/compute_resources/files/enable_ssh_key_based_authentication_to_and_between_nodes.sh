#!/bin/bash

usage() { echo "$0 -n <name_of_the_instance>" ; exit 1; }

while getopts "n:" option;do
    case "$option" in
        n) name=$OPTARG ;;
        *) usage ;;
    esac
done

#Allow SSH access from host to nodes
multipass transfer ~/.ssh/kubernetes.pub $name:
multipass exec $name -- bash -c 'cat kubernetes.pub >> ~/.ssh/authorized_keys'

# Allow SSH access between nodes
multipass transfer ~/.ssh/kubernetes.pub $name:.ssh/id_rsa.pub
multipass transfer ~/.ssh/kubernetes $name:.ssh/id_rsa
