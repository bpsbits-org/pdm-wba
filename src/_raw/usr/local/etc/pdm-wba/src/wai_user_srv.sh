#!/bin/bash
# wai_user_srv.sh
# /usr/local/etc/pdm-wba/src

# Ensures the user@300.service is enabled and started
wai_user_srv(){
    local service="user@300.service"
    if ! systemctl is-enabled $service &>/dev/null; then
        echo "Enabling $service..."
        systemctl enable $service
    fi
    if ! systemctl is-active $service &>/dev/null; then
        echo "Starting $service..."
        systemctl start $service
    fi
}