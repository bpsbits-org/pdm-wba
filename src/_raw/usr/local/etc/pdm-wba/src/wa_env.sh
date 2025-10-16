#!/bin/bash
# wa_env.sh
# /usr/local/etc/pdm-wba/src

# Exports configuration
wa_env(){
    set -a
    source /var/lib/pdm-wba/wa.conf
    set +a
}