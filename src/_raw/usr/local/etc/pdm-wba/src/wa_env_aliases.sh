#!/bin/bash
# wa_env_aliases.sh

wa_env_aliases(){
    alias nw-cat='sudo cat "/etc/NetworkManager/system-connections/cloud-init-eth0.nmconnection"'
    alias nw-nano='sudo nano "/etc/NetworkManager/system-connections/cloud-init-eth0.nmconnection"'
    alias print-env='echo "WA_ENV=$WA_ENV"'
    alias print-nw='echo -e "WA_NW1=$WA_NW1\WA_NW2=$WA_NW2"'
    alias quit='cat /dev/null > ~/.bash_history && history -c && history -r && exit;'
    alias status-cockpit='systemctl status cockpit.socket --no-pager'
    alias status-firewall='systemctl status firewalld --no-pager'
    alias status-podman='systemctl --machine="5100@.host" --user status podman.socket --no-pager'
    alias status-user='systemctl status user@5100 --no-pager'
    alias wa-log-init='journalctl -u pdm-wba-init.service --no-pager'
    alias wa-log-init-follow='journalctl -u pdm-wba-init.service --no-pager -f'
    alias wa-podman-ps='sudo -u "#5100" -i bash -c "podman ps -a"'
    alias wa-podman-update='sudo -u "#5100" -i bash -c "podman auto-update"'
    alias wa-services-all='systemctl --machine="5100@.host" --user list-units --type=service --all'
    alias wa-services-failed='systemctl --machine="5100@.host" --user list-units --type=service --state=failed'
    alias wa-services='systemctl --machine="5100@.host" --user list-unit-files --type=service'
    alias wa-update='sudo dnf update --refresh pdm-wba -y'
    alias wai-log='journalctl -u pdm-wba-quadlet-install.service --no-pager'
    alias wai-reload='systemctl --machine="5100@.host" --user daemon-reload'
    alias wai-reset='systemctl --machine="5100@.host" --user reset-failed'
}
