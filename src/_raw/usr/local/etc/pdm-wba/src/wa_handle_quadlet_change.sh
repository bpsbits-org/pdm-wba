#!/bin/bash
# wa_handle_quadlet_change.sh
# /usr/local/etc/pdm-wba/src

wa_handle_quadlet_change(){
    local file filename extension srv_core_name srv_name
    file="$1"
    echo "Processing quadlet: ${file}"
    # Exit if file is not a quadlet type
    [[ "${file}" =~ \.(container|volume|network|pod)$ ]] || return 0
    filename=$(basename "${file}")
    extension="${filename##*.}"
    srv_core_name="${filename%.*}"
    # Set service name: no suffix for .container, otherwise -<type>
    [ "${extension}" == "container" ] && extension="" || extension="-${extension}"
    srv_name="${srv_core_name}${extension}.service"
    if [ -f "${file}" ]; then
        echo "Processing service for '${filename}'..."
        systemctl --machine="5100@.host" --user daemon-reload
        if ! systemctl --machine="5100@.host" --user is-active "${srv_name}" &>/dev/null; then
            echo "Starting service '${srv_name}'..."
            systemctl --machine="5100@.host" --user start "${srv_name}" --no-pager
        else
            echo "Service '${srv_name}' is already active, skipping."
        fi
        systemctl --machine="5100@.host" --user status "${srv_name}" --no-pager
    fi
}