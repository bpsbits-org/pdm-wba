#!/bin/bash
# wa_conf_clone.sh
# /usr/local/etc/pdm-wba/src

wa_conf_clone(){
    local src
    src="/var/lib/pdm-wba/tpl/$(basename "$1")"
    [ -f "${src}" ] && [ ! -f "$1" ] && cp "${src}" "$1"
}

copy_conf_files_if_needed(){
    source /usr/local/etc/pdm-wba/src/wa_conf_clone.sh
    wa_conf_clone "/var/lib/pdm-wba/tpl/wa.conf"
    wa_conf_clone "/etc/fail2ban/jail.d/00-global.local"
    wa_conf_clone "/etc/fail2ban/jail.d/sshd.local"
    wa_conf_clone "/etc/ssh/sshd_config.d/10-wa-auth.conf"
}

# Check if --run argument is provided
# source /usr/local/etc/pdm-wba/src/wa_conf_clone.sh --run
if [[ "$1" == "--run" ]]; then
    copy_conf_files_if_needed
fi