#!/bin/bash
# wa_prep_ssh.sh
# /usr/local/etc/pdm-wba/src

# Updates SSHD configuration to change the port to 1022 and restarts the service
wa_prep_ssh(){
    echo "Updating SSHD configuration..."
    sed -i "s/#Port 22/Port 1022/" /etc/ssh/sshd_config
    sed -i "s/Port 22/Port 1022/" /etc/ssh/sshd_config
    systemctl restart sshd
    echo "SSHD configuration updated."
}