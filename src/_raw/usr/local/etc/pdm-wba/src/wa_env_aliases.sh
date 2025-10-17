#!/bin/bash
# wa_env_aliases.sh
# /usr/local/etc/pdm-wba/src

# Sets up WA environment aliases for convenience commands
wa_env_aliases(){
    alias nw-cat='sudo cat "/etc/NetworkManager/system-connections/cloud-init-eth0.nmconnection"'
    alias nw-edit='sudo nano "/etc/NetworkManager/system-connections/cloud-init-eth0.nmconnection"'
    alias print-env='echo "WA_ENV=$WA_ENV"'
    alias print-nw='echo -e "WA_NW1=$WA_NW1\nWA_NW2=$WA_NW2\nWA_NW3=$WA_NW3\nWA_NW4=$WA_NW4"'
    alias quit='cat /dev/null > ~/.bash_history && history -c && history -r && exit;'
    alias status-cockpit='sudo systemctl status cockpit.socket --no-pager'
    alias status-firewall='sudo systemctl status firewalld --no-pager'
    alias status-podman='systemctl --machine="300@.host" --user status podman.socket --no-pager'
    alias status-user='sudo systemctl status user@300 --no-pager'
    alias wa-containers='sudo -u "#300" -i bash -c "podman ps -a"'
    alias wa-help='/usr/local/etc/pdm-wba/src/wa_help.sh --print'
    alias wa-log-init-follow='sudo journalctl -u pdm-wba-init.service --no-pager -f'
    alias wa-log-init='sudo journalctl -u pdm-wba-init.service --no-pager'
    alias wa-reload-env='source /usr/local/etc/pdm-wba/src/wa_env.sh --reload'
    alias wa-services-all='systemctl --machine="300@.host" --user list-units --type=service --all'
    alias wa-services-failed='systemctl --machine="300@.host" --user list-units --type=service --state=failed'
    alias wa-services='systemctl --machine="300@.host" --user list-unit-files --type=service'
    alias wa-update-app='sudo dnf update --refresh pdm-wba -y'
    alias wa-update='sudo -u "#300" -i bash -c "podman auto-update"'
    alias wai-log-drop='sudo journalctl -u pdm-wba-quadlet-install.service --no-pager'
    alias wai-log='sudo journalctl -u pdm-wba-monitor-quadlet-dir.service --no-pager'
    alias wai-reload='systemctl --machine="300@.host" --user daemon-reload'
    alias wai-reset='systemctl --machine="300@.host" --user reset-failed'
    alias wai-set-cnf='sudo /usr/local/etc/pdm-wba/src/wa_conf_update.sh --set '
    alias wai-set-env='/usr/local/etc/pdm-wba/src/wa_set_env.sh --set'
}