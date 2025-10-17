#!/bin/bash
# wa_prep_os.sh
# /usr/local/etc/pdm-wba/src

# Installs required OS packages for WA setup with retry logic
wa_prep_os() {
    local PACKAGES
    echo "Installing required packages..."
    source /usr/local/etc/pdm-wba/cnf/main.conf
    IFS=',' read -ra PACKAGES <<< "${WA_DEPS}"
    for pkg in "${PACKAGES[@]}"; do
        if ! rpm -q "$pkg" > /dev/null 2>&1; then
            echo "Installing $pkg..."
            # Retry up to 3 times with exponential backoff
            for attempt in 1 2 3; do
                if dnf install -y --nobest --skip-broken "$pkg" 2>/dev/null; then
                    break
                else
                    if [ $attempt -eq 3 ]; then
                        echo "WARNING. Failed to install $pkg after $attempt attempts!"
                        return 0
                    else
                        sleep $((attempt * 2))
                    fi
                fi
            done
        fi
    done
}