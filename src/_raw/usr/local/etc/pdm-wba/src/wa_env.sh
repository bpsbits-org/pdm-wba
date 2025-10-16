#!/bin/bash
# wa_env.sh
# /usr/local/etc/pdm-wba/src

# Exports configuration
wa_env(){
    local WA_ENV WA_SDO
    source /var/lib/pdm-wba/wa.conf
    export WA_ENV="${WA_ENV}"
    export WA_SDO="${WA_SDO}"
}