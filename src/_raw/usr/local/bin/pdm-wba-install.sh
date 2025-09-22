#!/bin/bash

INSTALL_DIR="/home/wa/install"

DEBOUNCE_TIMEOUT=10

handle_wa_quadlet() {
    local pattern="$1"
    local files
    files=$(find "$INSTALL_DIR" -type f -name "*$pattern" | sort)
    if [ -n "$files" ]; then
        echo "Processing $pattern files..."
        while IFS= read -r file; do
        echo "Processing file: $file"
            if [[ $pattern == ".network" ]]; then
                echo "Handling network file: $file"
            elif [[ $pattern == ".volume" ]]; then
            e   cho "Handling volume file: $file"
            elif [[ $pattern == ".container" ]]; then
                echo "Handling container file: $file"
            fi
        done <<< "$files"
        echo "$pattern files processed."
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