#!/bin/bash
# wa_env.sh
# /usr/local/etc/pdm-wba/src

# Exports configuration
wa_env(){
    if [ -f "/var/lib/pdm-wba/wa.conf" ]; then
        set -a
        source /var/lib/pdm-wba/wa.conf
        set +a
    fi
}

# Check if --reload argument is provided
# source /usr/local/etc/pdm-wba/src/wa_env.sh --reload
if [[ "$1" == "--reload" ]]; then
    wa_env
fi