#!/bin/bash

wa_conf_update() {
    local key="$1"
    local value="$2"
    local conf_file="/run/pdm-wba/wa.conf"
    # Check if both key and value are provided
    if [ $# -ne 2 ]; then
        echo "Error: Usage: wa_conf_update <key> <value>" >&2
        return 1
    fi
    # Update existing key or append new one
    if grep -q "^$key=" "$conf_file"; then
        sudo sed -i "s/^$key=.*/$key=$value/" "$conf_file" || {
            echo "Error: Failed to update $key in $conf_file" >&2
            return 1
        }
    else
        echo "$key=$value" | sudo tee -a "$conf_file" >/dev/null || {
            echo "Error: Failed to append $key to $conf_file" >&2
            return 1
        }
    fi
    echo "Updated '$key' to: $value"
}
