#!/bin/bash
# wai_add_timer.sh
# /usr/local/etc/pdm-wba/src

# Adds and enables the podman auto-update timer for WA if not already present
wai_add_timer(){
    local timer_conf timer_file
    timer_conf='podman-auto-update.timer.d/override.conf'
    timer_file="/home/wa/.config/systemd/user/${timer_conf}"
    if [ ! -f "${timer_file}" ]; then
        source /usr/local/etc/pdm-wba/src/wai_fix_owner.sh
        cp "/usr/local/etc/pdm-wba/cnf/${timer_conf}" "${timer_file}"
        wai_fix_owner "${timer_file}"
        systemctl --machine="300@.host" --user enable --now podman-auto-update.timer
        echo "Created WA auto-update timer"
    fi
}