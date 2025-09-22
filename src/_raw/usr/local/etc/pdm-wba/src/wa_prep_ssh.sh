#!/bin/bash

wa_prep_ssh.sh(){
    echo "Updating SSHD configuration..."
    sed -i "s/#Port 22/Port 1022/" /etc/ssh/sshd_config
    sed -i "s/Port 22/Port 1022/" /etc/ssh/sshd_config
    systemctl restart sshd
    echo "SSHD configuration updated."
}