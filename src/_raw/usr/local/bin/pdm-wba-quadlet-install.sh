#!/bin/bash
# pdm-wba-quadlet-install.sh
# /usr/local/bin

source /usr/local/etc/pdm-wba/cnf/main.conf
DEBOUNCE_TIMEOUT=5

source /usr/local/etc/pdm-wba/src/wai_add_timer.sh
source /usr/local/etc/pdm-wba/src/wai_user_srv.sh
source /usr/local/etc/pdm-wba/src/wai_fix_owner.sh
source /usr/local/etc/pdm-wba/src/wai_install_service.sh
source /usr/local/etc/pdm-wba/src/wai_update_vars.sh

wai_validate_vars(){
    local file invalid_file filename
    file=$1
    filename=$(basename "${file}")
    # Check if file contains the invalid var marker
    if grep -q "<INVALID_VAR>" "$file"; then
        # File contains invalid variables, rename it
        invalid_file="${file}.invalid"
        mv "${file}" "${invalid_file}"
        echo "Marked '${filename}' as invalid due to invalid variables."
    fi
}

wai_validate_quadlet(){
    local file filename invalid_file
    file=$1
    filename=$(basename "${file}")
    if [ -f "${file}" ]; then
        if ! grep -q "\[Unit\]" "${file}" || ! grep -q "\[Install\]" "${file}"; then
            invalid_file="${file}.invalid"
            mv "${file}" "${invalid_file}"
            echo "Marked ${filename} as invalid due to missing sections"
        fi
    fi
}

wai_validate_nw(){
    local file filename invalid_file
    file=$1
    filename=$(basename "${file}")
    if [ -f "${file}" ]; then
        if ! grep -q "\[Network\]" "${file}" ; then
            invalid_file="${file}.invalid"
            mv "${file}" "${invalid_file}"
            echo "Marked ${filename} as invalid due to missing sections"
        fi
    fi
}

wai_validate_vl(){
    local file filename invalid_file
    file=$1
    filename=$(basename "${file}")
    if [ -f "${file}" ]; then
        if ! grep -q "\[Volume\]" "${file}" ; then
            invalid_file="${file}.invalid"
            mv "${file}" "${invalid_file}"
            echo "Marked ${filename} as invalid due to missing sections"
        fi
    fi
}

wai_validate_cn(){
    local file filename
    file=$1
    filename=$(basename "${file}")
    if [ -f "${file}" ]; then
        if ! grep -q "\[Container\]" "${file}"  || ! grep -q "\[Service\]" "${file}"; then
            local invalid_file="${file}.invalid"
            mv "${file}" "${invalid_file}"
            echo "Marked ${filename} as invalid due to missing sections"
        fi
    fi
}

wai_prepare_file(){
    local file
    file=$1
    wai_fix_owner "${file}"
    wai_update_vars "${file}"
    wai_validate_vars "${file}"
    wai_validate_quadlet "${file}"
}

wai_nw(){
    local file filename
    file=$1
    filename=$(basename "${file}")
    echo "Handling network: ${filename}"
    wai_prepare_file "${file}"
    wai_validate_nw "${file}"
    wai_install_service "${file}"
}

wai_vl(){
    local file filename
    file=$1
    filename=$(basename "${file}")
    echo "Handling volume: ${filename}"
    wai_prepare_file "${file}"
    wai_validate_vl "${file}"
    wai_install_service "${file}"
}

wai_cn(){
    local file filename
    file=$1
    filename=$(basename "${file}")
    echo "Handling container: ${filename}"
    wai_prepare_file "${file}"
    wai_validate_cn "${file}"
    wai_install_service "${file}"
}

wai_handle_quadlet() {
    local files pattern
    pattern="$1"
    files=$(find "$WA_INSTALL_DIR" -type f -name "*$pattern" | sort)
    if [ -n "$files" ]; then
        while IFS= read -r file; do
            if [[ $pattern == ".network" ]]; then
                wai_nw "${file}"
            elif [[ $pattern == ".volume" ]]; then
                wai_vl "${file}"
            elif [[ $pattern == ".container" ]]; then
                wai_cn "${file}"
            fi
        done <<< "$files"
    fi
}

wai_on_install_request() {
    wai_add_timer
    wai_user_srv
    #
    wai_handle_quadlet ".network"
    wai_handle_quadlet ".volume"
    wai_handle_quadlet ".container"
}

# Wait for debounce period
sleep "${DEBOUNCE_TIMEOUT}"

# Process in exact order
wai_on_install_request