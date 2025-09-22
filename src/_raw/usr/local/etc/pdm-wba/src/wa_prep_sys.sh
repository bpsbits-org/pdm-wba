#!/bin/bash

wa_prep_sys(){
    echo "Adjusting system..."
    systemctl preset firewalld.service cockpit.socket pmcd.service pmlogger.service user@5100.service
    firewall-cmd --permanent --remove-service=ssh
    firewall-cmd --permanent --zone=public --add-service=wa
    firewall-cmd --reload
    semanage import -f /etc/selinux/local/port-config.semanage
    sysctl --system
    systemctl daemon-reload
    echo "System prepared"
}