#!/bin/bash
# wai_install_service.sh

wai_install_service(){
    local file filename dest_file extension srv_core_name
    file=$1
    filename=$(basename "${file}")
    dest_file="/home/wa/.config/containers/systemd/${filename}"
    extension="${filename##*.}"
    srv_core_name="${filename%.*}"
    if [ "${extension}" == "container" ]; then
        extension=""
    else
        extension="-${extension}"
    fi
    # "${NW_NAME}-network.service"
    if [ -f "${file}" ]; then
        mv "${file}" "${dest_file}"
        wai_fix_owner "${dest_file}"
        # Run systemctl commands
        systemctl --machine="5100@.host" --user daemon-reload
        sleep 2
        systemctl --machine="5100@.host" --user start "${srv_core_name}${extension}.service" --no-pager
        sleep 2
        systemctl --machine="5100@.host" --user status "${srv_core_name}${extension}.service" --no-pager
        echo "Installed ${filename}"
    fi
}