#!/bin/bash

wa_update_system(){
    local PACKAGES WA_DEPS
    echo "Updating OS..."
    dnf upgrade -y --refresh
    echo "Installing required packages..."
    source /usr/local/etc/pdm-wba/cnf/main.conf
    IFS=',' read -ra PACKAGES <<< "$WA_DEPS"
    for pkg in "${PACKAGES[@]}"; do
        if ! rpm -q "$pkg" > /dev/null 2>&1; then
            echo "Installing $pkg..."
            dnf install -y "$pkg"
        fi
    done
}
