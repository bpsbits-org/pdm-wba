#!/bin/bash
# wai_update_vars
# /usr/local/etc/pdm-wba/src

# Replaces environment variables in the specified file with their actual values
wai_update_vars(){
    local var file escaped_value value vars temp_file
    file=$1
    source /etc/profile.d/wa.sh
    temp_file=$(mktemp)
    cp "${file}" "${temp_file}"
    # Find all ${VAR} patterns in the file
    vars=$(grep -o '\${[A-Za-z0-9_]*}' "${file}" | sort -u | sed 's/\${//;s/}//')
    # Process each variable
    for var in $vars; do
        value="${!var}"
        [ -z "$value" ] && value="<INVALID_VAR>"
        escaped_value=$(echo "$value" | sed 's/[\/&]/\\&/g')
        sed -i "s/\${$var}/$escaped_value/g" "${temp_file}"
    done
    # Replace an original file with an updated version
    mv "${temp_file}" "${file}"
    source /usr/local/etc/pdm-wba/src/wai_fix_owner.sh
    wai_fix_owner "${file}"
}