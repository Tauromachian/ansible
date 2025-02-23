#!/bin/bash

if ! command -v ansible > /dev/null 2>&1; then
    sudo apt install -y software-properties-common
    sudo apt-add-repository -y ppa:ansible/ansible
    sudo apt update -y
    sudo apt install -y ansible
fi

ansible-playbook ansible.yml --ask-become-pass
