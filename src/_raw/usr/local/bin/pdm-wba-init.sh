#!/bin/bash
# pdm-wba-init.sh

mark_init_done(){
    source /usr/local/etc/pdm-wba/src/wa_conf_update.sh
    wa_conf_update "WA_SDO" "true"
    echo "System initialization marked as done."
}

init_new_system(){
    echo "Initializing"
    # Sources
    source /usr/local/etc/pdm-wba/src/wa_prep_os.sh
    source /usr/local/etc/pdm-wba/src/wa_prep_sys.sh
    source /usr/local/etc/pdm-wba/src/wa_prep_ssh.sh
    # Run
    wa_prep_os
    wa_prep_ssh
    wa_prep_sys
    mark_init_done
}

check_and_run() {
    local IS_INIT_DONE
    source /var/lib/pdm-wba/wa.conf
    if [ -z "$WA_SDO" ] || [ "${WA_SDO,,}" = "false" ]; then
        IS_INIT_DONE=false
    else
        IS_INIT_DONE=true
    fi
    if [ "$IS_INIT_DONE" = true ]; then
        exit 0
    fi
    init_new_system
}

check_and_run