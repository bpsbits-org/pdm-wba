#!/bin/bash#
# wa_env_nw.sh

wa_env_nw(){
    local NW_CNF_FILE SRV_NW1_IP SRV_NW2_IP SRV_NW3_IP SRV_NW4_IP
    NW_CNF_FILE="/etc/NetworkManager/system-connections/cloud-init-eth0.nmconnection"
    #
    SRV_NW1_IP=$(grep "^address1=" "${NW_CNF_FILE}" | cut -d'=' -f2 | grep -o '^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
    SRV_NW1_IP=$(echo "${SRV_NW1_IP}" | xargs)
    #
    SRV_NW2_IP=$(grep "^address2=" "${NW_CNF_FILE}" | cut -d'=' -f2 | grep -o '^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
    SRV_NW2_IP=$(echo "${SRV_NW2_IP}" | xargs)
    #
    SRV_NW3_IP=$(grep "^address3=" "${NW_CNF_FILE}" | cut -d'=' -f2 | grep -o '^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
    SRV_NW3_IP=$(echo "${SRV_NW3_IP}" | xargs)
    #
    SRV_NW4_IP=$(grep "^address4=" "${NW_CNF_FILE}" | cut -d'=' -f2 | grep -o '^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
    SRV_NW4_IP=$(echo "${SRV_NW4_IP}" | xargs)
    #
    export WA_NW1="${SRV_NW1_IP}"
    export WA_NW2="${SRV_NW2_IP}"
    export WA_NW3="${SRV_NW3_IP}"
    export WA_NW4="${SRV_NW4_IP}"
}