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
        XDG_RUNTIME_DIR=/run/user/5100 systemctl --user daemon-reload
        sleep 2
        XDG_RUNTIME_DIR=/run/user/5100 systemctl --user start "${filename}" --no-pager
        sleep 2
        XDG_RUNTIME_DIR=/run/user/5100 systemctl --user status "${filename}" --no-pager
        echo "Installed ${filename}"
    fi
}