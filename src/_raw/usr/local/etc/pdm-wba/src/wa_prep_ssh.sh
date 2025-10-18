#!/bin/bash
# wa_prep_ssh.sh
# /usr/local/etc/pdm-wba/src

# Updates SSHD configuration to change the port to 1022 and restarts the service
wa_prep_ssh() {
    local conf_file backup_file
    conf_file="/etc/ssh/sshd_config"
    backup_file="${conf_file}.bak.$(date +%F_%H%M%S)"
    [ ! -f "${conf_file}" ] && return 1
    grep -q "^Port 1022$" "${conf_file}" && return 0
    systemctl cat sshd >/dev/null 2>&1 || return 1
    cp "${conf_file}" "${backup_file}" || return 1
    sed -i "s/#Port 22/Port 1022/" "${conf_file}"
    sed -i "s/Port 22/Port 1022/" "${conf_file}"
    systemctl restart sshd || return 1
}