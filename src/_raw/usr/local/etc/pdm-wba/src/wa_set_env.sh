#!/bin/bash
# wa_set_env.sh
# /usr/local/etc/pdm-wba/src

# Prompts user to set/update environment tag
wa_set_env (){
    source /var/lib/pdm-wba/wa.conf
    source /usr/local/etc/pdm-wba/cnf/main.conf
    source /usr/local/etc/pdm-wba/src/wa_conf_update.sh
    if [ -n "${WA_ENV}" ]; then
        echo "The system is already configured for '${WA_ENV}'."
        echo "Please note that changing the value does not affect already installed WA services."
        echo -e "\t - Type \033[1;33my\033[0m and press \033[1;33mEnter\033[0m to update the configuration."
        echo -e "\t - Press \033[1;33mEnter\033[0m to cancel."
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

# Prompts user to select environment tag
wa_set_env_prompt(){
    local SELECTED_ENV_TYPE=""
    IFS=',' read -ra ENV_TYPES <<< "${WA_ENV_TYPES}"
    echo -e "\nSelect environment type:\n"
    echo -e "  \033[1;33m0\033[0m \tCancel changing the environment type."
    for i in "${!ENV_TYPES[@]}"; do
        echo -e "  \033[1;33m$((i+1))\033[0m \t${ENV_TYPES[$i]}"
    done
    echo ""
    read -r -p "Enter your choice: " USR_SELECTED_ID
    if [[ -z "${USR_SELECTED_ID}" ]] || [[ "${USR_SELECTED_ID}" == "0" ]]; then
        echo -e "\n\tOperation cancelled."
    elif [[ "${USR_SELECTED_ID}" =~ ^[0-9]+$ ]] && [ "${USR_SELECTED_ID}" -ge 1 ] && [ "${USR_SELECTED_ID}" -le "${#ENV_TYPES[@]}" ]; then
        SELECTED_ENV_TYPE="${ENV_TYPES[$((USR_SELECTED_ID-1))]}"
        echo -e "\n\tSelected: \033[1;33m${SELECTED_ENV_TYPE}\033[0m"
        wa_conf_update "WA_ENV" "${SELECTED_ENV_TYPE}"
        return 0
    else
        echo -e "\n\Invalid choice. Please try again."
        wa_set_env_prompt
    fi
}

# Check if --set argument is provided
# source /usr/local/etc/pdm-wba/src/wa_set_env.sh --set
if [[ "$1" == "--set" ]]; then
    wa_set_env
fi

