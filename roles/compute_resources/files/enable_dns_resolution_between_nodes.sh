#!/bin/bash

usage() { echo "$0 -n <name_of_the_instance>" ; exit 1; }

while getopts "n:" option;do
    case "$option" in
        n) name=$OPTARG;;
        *) usage ;;
    esac
done

# Create file with nodename and it's ipv4 address except current node
multipass list --format json | jq -r --arg name $name '.list[] | select(.name | contains($name) | not) | "\(.ipv4[0]) \(.name)"' > node_details.txt

# Update template to use new nodename and it's ipv4 for DNS resolution
multipass transfer node_details.txt $name:
multipass exec $name -- bash -c 'cat node_details.txt | sudo tee -a /etc/cloud/templates/hosts.debian.tmpl'
rm node_details.txt
multipass restart $name