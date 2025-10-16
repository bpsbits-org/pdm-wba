#!/bin/bash
# wai_update_vars
# /usr/local/etc/pdm-wba/src

# Replaces environment variables in the specified file with their actual values
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
    source /usr/local/etc/pdm-wba/src/wai_fix_owner.sh
    wai_fix_owner "${file}"
}