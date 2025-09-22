#!/bin/bash
# wa_env_aliases.sh

wa_env_aliases(){
    alias cat-nw='cat "/etc/NetworkManager/system-connections/cloud-init-eth0.nmconnection"'
    alias log-wa-init='journalctl -u pdm-wba-init.service --no-pager'
    alias nano-nw='nano "/etc/NetworkManager/system-connections/cloud-init-eth0.nmconnection"'
    alias pm-update='podman auto-update'
    alias print-env='echo "WA_ENV=$WA_ENV"'
    alias print-nw='echo -e "WA_NW1=$WA_NW1\WA_NW2=$WA_NW2"'
    alias st-cockpit='systemctl status cockpit --no-pager'
    alias st-firewall='systemctl status firewalld --no-pager'
    alias st-podman='systemctl status podman --no-pager'
    alias st-user='systemctl status user@5100 --no-pager'
    alias wai-log='journalctl -u pdm-wba-install.service --no-pager'
    alias wai-reload='XDG_RUNTIME_DIR=/run/user/5100 systemctl --user daemon-reload'
    alias wai-reset='XDG_RUNTIME_DIR=/run/user/5100 systemctl --user reset-failed'
    alias wai-services='XDG_RUNTIME_DIR=/run/user/5100 systemctl --user list-units --type=service'
}