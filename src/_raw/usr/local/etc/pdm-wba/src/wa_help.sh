#!/bin/bash
# wa_help.sh
# /usr/local/etc/pdm-wba/src

# Displays a list of available WA commands with descriptions
wa_help(){
    echo -e "List of WA Commands:"
    echo -e "\033[1;33m  nw-cat \033[0m               View network configuration file contents.";
    echo -e "\033[1;33m  nw-edit \033[0m              Edit network configuration file in text editor.";
    echo -e "\033[1;33m  print-env \033[0m            Displays current server environment type.";
    echo -e "\033[1;33m  print-nw \033[0m             Displays network addresses configuration.";
    echo -e "\033[1;33m  quit \033[0m                 Clear command history and exit terminal session.";
    echo -e "\033[1;33m  status-cockpit \033[0m       Check status of web management interface service.";
    echo -e "\033[1;33m  status-firewall \033[0m      Check status of system firewall service.";
    echo -e "\033[1;33m  status-podman \033[0m        Check status of container management service.";
    echo -e "\033[1;33m  status-user \033[0m          Check status of WA user account service.";
    echo -e "\033[1;33m  wa-containers \033[0m        List all WA containers (running and stopped).";
    echo -e "\033[1;33m  wa-help \033[0m              Displays list of WA Commands";
    echo -e "\033[1;33m  wa-log-init \033[0m          View WA initialization service logs.";
    echo -e "\033[1;33m  wa-log-init-follow \033[0m   View WA initialization logs in real-time (Ctrl+C to exit).";
    echo -e "\033[1;33m  wa-services \033[0m          Displays basic list of available WA services.";
    echo -e "\033[1;33m  wa-services-all \033[0m      List all WA services (running, stopped, and disabled).";
    echo -e "\033[1;33m  wa-services-failed \033[0m   List only failed WA services.";
    echo -e "\033[1;33m  wa-update \033[0m            Update all containers with auto-update enabled.";
    echo -e "\033[1;33m  wa-update-app \033[0m        Update WA application to the latest version.";
    echo -e "\033[1;33m  wai-set-env \033[0m          Sets the environment type";
    echo -e "\033[1;33m  wai-log \033[0m              View WA services installation logs.";
    echo -e "\033[1;33m  wai-log-drop \033[0m         View logs of installation requests from drop directory.";
    echo -e "\033[1;33m  wai-reload \033[0m           Reload WA services configuration.";
    echo -e "\033[1;33m  wai-reset \033[0m            Clear the list of failed WA services.";
}

# Check if --print argument is provided
if [[ "$1" == "--print" ]]; then
    wa_help
fi
