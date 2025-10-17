#!/bin/bash
# wa_conf_clone.sh
# /usr/local/etc/pdm-wba/src

# Tries to clone given configuration file if needed
wa_conf_clone(){
    local src
    src="/var/lib/pdm-wba/tpl/$(basename "$1")"
    [ -f "${src}" ] && [ ! -f "$1" ] && cp "${src}" "$1"
}

# Imports configuration into system
copy_conf_files_if_needed(){
    wa_conf_clone "/var/lib/pdm-wba/tpl/wa.conf"
    wa_conf_clone "/etc/fail2ban/jail.d/00-global.local"
    wa_conf_clone "/etc/fail2ban/jail.d/sshd.local"
    wa_conf_clone "/etc/ssh/sshd_config.d/10-wa-auth.conf"
    wa_conf_clone "/etc/ssh/sshd_config.d/20-wa-access.conf"
}

# Check if --run argument is provided
# source /usr/local/etc/pdm-wba/src/wa_conf_clone.sh --run
if [[ "$1" == "--run" ]]; then
    copy_conf_files_if_needed
fi