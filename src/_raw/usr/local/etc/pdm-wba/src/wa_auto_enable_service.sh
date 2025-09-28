#!/bin/bash
# wa_auto_enable_service.sh

wa_auto_enable_service(){
    local file filename extension srv_core_name srv_name
    file="$1"
    # Exit if file is not a quadlet type
    [[ "$file" =~ \.(container|volume|network|pod)$ ]] || return 0
    filename=$(basename "${file}")
    extension="${filename##*.}"
    srv_core_name="${filename%.*}"
    # Set service name: no suffix for .container, otherwise -<type>
    [ "${extension}" == "container" ] && extension="" || extension="-${extension}"
    srv_name="${srv_core_name}${extension}.service"
    if [ -f "${file}" ]; then
        echo "Processing service for '${filename}'..."
        systemctl --machine="5100@.host" --user daemon-reload
        # Enable and start only if not already active
        if ! systemctl --machine="5100@.host" --user is-active "${srv_name}" &>/dev/null; then
            systemctl --machine="5100@.host" --user enable --now "${srv_name}" --no-pager
        else
            echo "Service '${srv_name}' is already active, skipping enable/start."
        fi
        systemctl --machine="5100@.host" --user status "${srv_name}" --no-pager
    fi
}