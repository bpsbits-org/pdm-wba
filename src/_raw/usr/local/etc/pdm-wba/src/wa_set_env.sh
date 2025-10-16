#!/bin/bash
# wa_set_env.sh
# /usr/local/etc/pdm-wba/src

wa_set_env (){
    source /var/lib/pdm-wba/wa.conf
    source /usr/local/etc/pdm-wba/cnf/main.conf
    source /usr/local/etc/pdm-wba/src/wa_conf_update.sh
    if [ -n "${WA_ENV}" ]; then
        echo "The system is already configured for '${WA_ENV}'."
        echo "Please note that changing the value does not affect already installed WA services."
        echo -e "\t - Type 'y' and press Enter to update the configuration."
        echo -e "\t - Press Enter to cancel."
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
    echo -e "\nSelect environment type:\n"
    echo -e "  0 \tCancel changing the environment type."
    for i in "${!ENV_TYPES[@]}"; do
        echo -e "  $((i+1)) \t${ENV_TYPES[$i]}"
    done
    echo ""
    read -r -p "Enter your choice: " USR_SELECTED_ID
    if [[ -z "${USR_SELECTED_ID}" ]] || [[ "${USR_SELECTED_ID}" == "0" ]]; then
        echo -e "\n\tOperation cancelled."
    elif [[ "${USR_SELECTED_ID}" =~ ^[0-9]+$ ]] && [ "${USR_SELECTED_ID}" -ge 1 ] && [ "${USR_SELECTED_ID}" -le "${#ENV_TYPES[@]}" ]; then
        SELECTED_ENV_TYPE="${ENV_TYPES[$((USR_SELECTED_ID-1))]}"
        echo -e "\n\tSelected: ${SELECTED_ENV_TYPE}"
        wa_conf_update "WA_ENV" "${SELECTED_ENV_TYPE}"
        return 0
    else
        echo -e "\n\Invalid choice. Please try again."
        wa_set_env_prompt
    fi
}

# Check if --print argument is provided
if [[ "$1" == "--set" ]]; then
    wa_set_env
fi

