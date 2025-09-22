#!/bin/bash
# wa_prep_os.sh

wa_prep_os() {
    local PACKAGES WA_DEPS
    echo "Installing required packages..."
    source /usr/local/etc/pdm-wba/cnf/main.conf
    IFS=',' read -ra PACKAGES <<< "$WA_DEPS"

    for pkg in "${PACKAGES[@]}"; do
        if ! rpm -q "$pkg" > /dev/null 2>&1; then
            echo "Installing $pkg..."
            # Retry up to 3 times with exponential backoff
            for attempt in 1 2 3; do
                if dnf install -y --nobest --skip-broken "$pkg" 2>/dev/null; then
                    break
                else
                    if [ $attempt -eq 3 ]; then
                        echo "Failed to install $pkg after $attempt attempts"
                    else
                        sleep $((attempt * 2))
                    fi
                fi
            done
        fi
    done
}