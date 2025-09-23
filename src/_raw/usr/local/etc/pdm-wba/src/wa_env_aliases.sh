#!/bin/bash
# wa_env_aliases.sh

wa_env_aliases(){
    alias nw-cat='cat "/etc/NetworkManager/system-connections/cloud-init-eth0.nmconnection"'
    alias nw-nano='nano "/etc/NetworkManager/system-connections/cloud-init-eth0.nmconnection"'
    alias pm-update='podman auto-update'
    alias print-env='echo "WA_ENV=$WA_ENV"'
    alias print-nw='echo -e "WA_NW1=$WA_NW1\WA_NW2=$WA_NW2"'
    alias st-cockpit='systemctl status cockpit.socket --no-pager'
    alias st-firewall='systemctl status firewalld --no-pager'
    alias st-podman='systemctl --machine="5100@.host" --user status podman --no-pager'
    alias st-user='systemctl status user@5100 --no-pager'
    alias wa-log-init='journalctl -u pdm-wba-init.service --no-pager'
    alias wai-log='journalctl -u pdm-wba-install.service --no-pager'
    alias wai-reload='systemctl --machine="5100@.host" --user daemon-reload'
    alias wai-reset='systemctl --machine="5100@.host" --user reset-failed'
    alias wai-services-all='systemctl --machine="5100@.host" --user list-units --type=service --all'
    alias wai-services-failed='systemctl --machine="5100@.host" --user list-units --type=service --state=failed'
    alias wai-services='systemctl --machine="5100@.host" --user list-unit-files --type=service'
}