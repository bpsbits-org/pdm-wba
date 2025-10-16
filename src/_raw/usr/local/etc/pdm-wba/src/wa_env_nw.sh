#!/bin/bash
# wa_env_nw.sh
# /usr/local/etc/pdm-wba/src

# Extracts and exports network IP addresses from cloud-init eth0 connection
wa_env_nw() {
    local NW_CNF SRV_NW1_IP SRV_NW2_IP SRV_NW3_IP SRV_NW4_IP
    NW_CNF=$(nmcli -t -f IP4.ADDRESS connection show "cloud-init eth0")
    SRV_NW1_IP=$(echo "$NW_CNF" | grep "IP4.ADDRESS\[1\]" | cut -d':' -f2 | cut -d'/' -f1)
    SRV_NW2_IP=$(echo "$NW_CNF" | grep "IP4.ADDRESS\[2\]" | cut -d':' -f2 | cut -d'/' -f1)
    SRV_NW3_IP=$(echo "$NW_CNF" | grep "IP4.ADDRESS\[3\]" | cut -d':' -f2 | cut -d'/' -f1)
    SRV_NW4_IP=$(echo "$NW_CNF" | grep "IP4.ADDRESS\[4\]" | cut -d':' -f2 | cut -d'/' -f1)
    export WA_NW1="$SRV_NW1_IP"
    export WA_NW2="$SRV_NW2_IP"
    export WA_NW3="$SRV_NW3_IP"
    export WA_NW4="$SRV_NW4_IP"
}