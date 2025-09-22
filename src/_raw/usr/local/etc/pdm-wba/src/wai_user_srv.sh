#!/bin/bash
# wai_user_srv.sh

wai_user_srv(){
    local service="user@5100.service"
    if ! systemctl is-enabled $service &>/dev/null; then
        echo "Enabling $service..."
        systemctl enable $service
    fi
    if ! systemctl is-active $service &>/dev/null; then
        echo "Starting $service..."
        systemctl start $service
    fi
}