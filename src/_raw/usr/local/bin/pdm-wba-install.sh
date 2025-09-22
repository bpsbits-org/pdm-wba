#!/bin/bash

WA_INSTALL_DIR="/home/wa/install"
DEBOUNCE_TIMEOUT=10

wai_fix_owner(){
    local file=$1
    chown wa:wa "${file}"
}

wai_update_vars(){
    local file escaped_value value vars temp_file
    file=$1

    temp_file=$(mktemp)
    cp "${file}" "${temp_file}"

    # Find all ${VAR} patterns in the file
    vars=$(grep -o '\${[A-Za-z0-9_]*}' "$file" | sort -u | sed 's/\${//;s/}//')

    source /etc/profile.d/wa.sh

    # Process each variable
    for var in $vars; do
        value="${!var}"
        if [ -z "$value" ]; then
            value="<INVALID_VAR>"
        fi
        # Escape special characters for sed
        escaped_value=$(echo "$value" | sed 's/[\/&]/\\&/g')
        # Replace variable with its value
        sed -i "s/\${$var}/$escaped_value/g" "$temp_file"
    done

    # Replace original file with updated version
    mv "${temp_file}" "${file}"
    wai_fix_owner "${file}"
}

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

wai_install_service(){
    local file filename dest_file
    file=$1
    filename=$(basename "${file}")
    dest_file="/home/wa/.config/containers/systemd/${filename}"
    if [ -f "${file}" ]; then
        mv "${file}" "${dest_file}"
        wai_fix_owner "${dest_file}"
        # Run systemctl commands
        XDG_RUNTIME_DIR=/run/user/5100 systemctl --user daemon-reload
        sleep 2
        XDG_RUNTIME_DIR=/run/user/5100 systemctl --user start "${filename}" --no-pager
        sleep 2
        XDG_RUNTIME_DIR=/run/user/5100 systemctl --user status "${filename}" --no-pager
        echo "Installed ${filename}"
    fi
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

handle_wa_quadlet() {
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

on_wa_install_request() {
    handle_wa_quadlet ".network"
    handle_wa_quadlet ".volume"
    handle_wa_quadlet ".container"
}

# Wait for debounce period
sleep "$DEBOUNCE_TIMEOUT"

# Process in exact order
on_wa_install_request