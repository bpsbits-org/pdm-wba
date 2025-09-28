#!/bin/bash
# wa_user_wa_aliases.sh

wa_user_wa_aliases(){
    alias containers='podman ps -a'
    alias daemon-reload='systemctl --user daemon-reload'
    alias reset-failed='systemctl --user reset-failed'
    alias services-failed='systemctl --user list-units --type=service --state=failed --no-pager'
    alias services='systemctl --user list-units --type=service --all --no-pager'
    # shellcheck disable=SC2154
    alias volumes="for vol in \$(podman volume ls --format \"{{.Name}}\"); do containers=\$(podman ps -a --filter volume=\"\$vol\" --format \"{{.Names}}\" | tr '\n' ',' | sed 's/,*$//'); [ -z \"\$containers\" ] && containers=\"None\"; echo \"\$vol | \$containers\"; done"
}
