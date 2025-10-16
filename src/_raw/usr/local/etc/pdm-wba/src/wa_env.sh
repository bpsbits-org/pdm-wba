#!/bin/bash
# wa_env.sh
# /usr/local/etc/pdm-wba/src

# Exports configuration
wa_env(){
    set -a
    source /var/lib/pdm-wba/wa.conf
    set +a
}

# Check if --print argument is provided
if [[ "$1" == "--reload" ]]; then
    wa_set_env
fi