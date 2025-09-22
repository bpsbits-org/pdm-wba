#!/bin/bash
# wa_env_aliases.sh

wa_env_aliases(){
    alias cat-nw='cat "/etc/NetworkManager/system-connections/cloud-init-eth0.nmconnection"'
    alias nano-nw='nano "/etc/NetworkManager/system-connections/cloud-init-eth0.nmconnection"'
    alias pm-update='podman auto-update'
    alias print-env='echo "WA_ENV=$WA_ENV"'
    alias print-nw='echo -e "WA_NW1=$WA_NW1\WA_NW2=$WA_NW2"'
    alias st-cockpit='systemctl status cockpit --no-pager'
    alias st-firewall='systemctl status firewalld --no-pager'
    alias st-podman='systemctl status podman --no-pager'
    alias st-user='systemctl status user@5100 --no-pager'
    alias log-wa-init='journalctl -u pdm-wba-init.service --no-pager'
    alias log-wa-install='journalctl -u pdm-wba-install.service --no-pager'
}