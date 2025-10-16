#!/bin/bash
# wa_conf_update.sh
# /usr/local/etc/pdm-wba/src

# # Updates or adds a configuration key-value pair in WA conf
wa_conf_update() {
    local key value conf_file
    key="$1"
    value="$2"
    conf_file="/var/lib/pdm-wba/wa.conf"
    if [ ! -f "${conf_file}" ]; then
        touch "${conf_file}"
    fi
    # Check if both key and value are provided
    if [ $# -ne 2 ]; then
        echo "Error: Usage: wa_conf_update <key> <value>" >&2
        return 1
    fi
    # Update existing key or append new one
    if grep -q "^$key=" "${conf_file}"; then
        sudo sed -i "s/^$key=.*/$key=$value/" "${conf_file}" || {
            echo "Error: Failed to update ${key} in ${conf_file}" >&2
            return 1
        }
    else
        echo "$key=$value" | sudo tee -a "${conf_file}" >/dev/null || {
            echo "Error: Failed to append ${key} to ${conf_file}" >&2
            return 1
        }
    fi
    echo "Updated '${key}' to: ${value}"
    source /usr/local/etc/pdm-wba/src/wa_env.sh --reload
}
