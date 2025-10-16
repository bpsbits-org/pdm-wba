#!/bin/bash
# pdm-wba-init.sh
# /usr/local/bin

make_conf_file_if_needed(){
    local conf_file="/var/lib/pdm-wba/wa.conf"
    local default_conf="/var/lib/pdm-wba/wa-default.conf"
    [ -f "${conf_file}" ] || cp "${default_conf}" "${conf_file}"
    source /usr/local/etc/pdm-wba/src/wa_env.sh --reload
}

# Marks system initialization as done
mark_init_done(){
    source /usr/local/etc/pdm-wba/src/wa_conf_update.sh
    wa_conf_update "WA_SDO" "true"
    echo "System initialization marked as done."
}

# Performs full WA system initialization: prepares OS, SSH, and system components, then marks completion.
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

# Checks if WA is initialized and runs full system initialization if needed.
check_and_run() {
    local IS_INIT_DONE
    make_conf_file_if_needed
    if [ -z "${WA_SDO}" ] || [ "${WA_SDO,,}" = "false" ]; then
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