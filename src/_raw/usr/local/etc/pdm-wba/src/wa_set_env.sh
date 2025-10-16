#!/bin/bash
# wa_set_env.sh
# /usr/local/etc/pdm-wba/src

wa_set_env (){
    source /var/lib/pdm-wba/wa.conf
    source /usr/local/etc/pdm-wba/cnf/main.conf
    source /usr/local/etc/pdm-wba/src/wa_conf_update.sh
    if [ -n "${WA_ENV}" ]; then
        echo "The system is already configured for '${WA_ENV}'."
        echo "To update the configuration, enter 'y' and press Enter, or simply press Enter to cancel."
        echo "Please note that changing the value does not affect already installed WA services."
        read -r -p "Continue? " response
        if [[ "${response,,}" == y* ]]; then
            wa_set_env_prompt
        else
            echo "Cancelled changing environment type."
            return 0
        fi
    else
        wa_set_env_prompt
    fi
}

wa_set_env_prompt(){
    local SELECTED_ENV_TYPE=""
    IFS=',' read -ra ENV_TYPES <<< "${WA_ENV_TYPES}"
    echo "Select environment type:"
    echo -e "\t0 - Cancel changing the environment type."
    for i in "${!ENV_TYPES[@]}"; do
        echo -e "\t$((i+1)). - ${ENV_TYPES[$i]}"
    done
    read -r -p "Enter your choice: " USR_SELECTED_ID
    if [[ -z "${USR_SELECTED_ID}" ]] || [[ "${USR_SELECTED_ID}" == "0" ]]; then
        echo "Operation cancelled."
    elif [[ "${USR_SELECTED_ID}" =~ ^[0-9]+$ ]] && [ "${USR_SELECTED_ID}" -ge 1 ] && [ "${USR_SELECTED_ID}" -le "${#ENV_TYPES[@]}" ]; then
        SELECTED_ENV_TYPE="${ENV_TYPES[$((USR_SELECTED_ID-1))]}"
        echo "Selected: ${SELECTED_ENV_TYPE}"
        wa_conf_update "WA_ENV" "${SELECTED_ENV_TYPE}"
        return 0
    else
        echo "Invalid choice. Please try again."
        wa_set_env_prompt
    fi
}

# Check if --print argument is provided
if [[ "$1" == "--set" ]]; then
    wa_set_env
fi

