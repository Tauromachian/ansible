#!/bin/bash

if [ "$EUID" -eq 0 ]; then
  echo "Error: Ansible will fail if you run this as root or with sudo"
  echo "Please run it as a regular user."
  exit 1
fi

if ! command -v ansible > /dev/null 2>&1; then
    sudo apt install -y software-properties-common
    sudo apt-add-repository -y ppa:ansible/ansible
    sudo apt update -y
    sudo apt install -y ansible
fi

ansible-playbook ansible.yml --ask-become-pass
