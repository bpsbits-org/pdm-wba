#!/bin/bash

wa_prep_os() {
    local PACKAGES
    # Source the configuration file
    source /usr/local/etc/pdm-wba/cnf/main.conf
    # Convert comma-separated WA_DEPS to an array
    IFS=',' read -ra PACKAGES <<< "$WA_DEPS"
    echo "Updating OS..."
    dnf upgrade -y --refresh
    # Install packages
    echo "Installing required packages..."
    for pkg in "${PACKAGES[@]}"; do
        if ! rpm -q "$pkg" > /dev/null 2>&1; then
            echo "Installing $pkg..."
            dnf install -y "$pkg"
        fi
    done
}