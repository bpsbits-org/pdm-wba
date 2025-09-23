#!/bin/bash
# wai_install_service.sh

wai_install_service(){
    local file filename dest_file
    file=$1
    filename=$(basename "${file}")
    dest_file="/home/wa/.config/containers/systemd/${filename}"
    if [ -f "${file}" ]; then
        mv "${file}" "${dest_file}"
        wai_fix_owner "${dest_file}"
        # Run systemctl commands
        systemctl --machine="5100@.host" --user daemon-reload
        sleep 2
        systemctl --machine="5100@.host" --user start "${filename}" --no-pager
        sleep 2
        systemctl --machine="5100@.host" --user status "${filename}" --no-pager
        echo "Installed ${filename}"
    fi
}