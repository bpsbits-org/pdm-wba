#!/bin/bash
# wai_install_service.sh
# /usr/local/etc/pdm-wba/src

# Installs a quadlet service file for WA by moving it to the user's config directory and reloading daemon
wai_install_service(){
    local file filename dest_file service_name
    file=$1
    filename=$(basename "${file}")
    service_name="${filename//./-}.service"
    [[ "$file" =~ \.(container|volume|network|pod)$ ]] || return 0
    dest_file="/home/wa/.config/containers/systemd/${filename}"
    if [ -f "${file}" ]; then
        mv "${file}" "${dest_file}"
        wai_fix_owner "${dest_file}"
        systemctl --machine="300@.host" --user daemon-reload
        systemctl --machine="300@.host" --user start "${service_name}"
        echo "Installed ${filename}"
    fi
}