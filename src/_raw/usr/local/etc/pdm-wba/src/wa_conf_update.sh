#!/bin/bash
# wa_conf_update.sh
# /usr/local/etc/pdm-wba/src

# # Updates or adds a configuration key-value pair in WA conf
wa_conf_update() {
    local key value conf_file
    conf_file="/var/lib/pdm-wba/wa.conf"
    # Check if both key and value are provided
    if [ $# -ne 2 ]; then
        echo -e "\033[1;33mError\033[0m: Invalid inputs. Usage: wa_conf_update <key> <value>" >&2
        return 1
    fi
    key="$1"
    value="$2"
    # Trim whitespace, convert to uppercase, replace non-alphanumeric chars with _
    key=$(echo "$key" | tr -s '[:space:]' | tr '[:lower:]' '[:upper:]' | tr -c '[:alnum:]' '_')
    if [ ! -f "${conf_file}" ]; then
        touch "${conf_file}"
    fi
    # Check if the key is empty
    if [ -z "${key}" ]; then
        echo -e "\033[1;33mError\033[0m: Key is required." >&2
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
    echo -e "Updated \033[1;33m${key}\033[0m to: \033[1;33m${value}\033[0m"
    source /usr/local/etc/pdm-wba/src/wa_env.sh --reload
}

# Check if --set argument is provided
# source /usr/local/etc/pdm-wba/src/wa_conf_update.sh --set
if [[ "$1" == "--set" ]]; then
    wa_conf_update "$2" "$3"
fi
