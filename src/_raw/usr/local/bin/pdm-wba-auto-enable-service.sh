#!/bin/bash
# pdm-wba-auto-enable-service.sh
# /usr/local/bin

set -e

echo "File changed: $DIRECTORY/$PATH_CHANGED"

changed_file="$1"
echo "FILE: ${changed_file}"

[ -z "${changed_file}" ] || [ ! -f "${changed_file}" ] && exit 0

export XDG_RUNTIME_DIR=/run/user/5100
source /usr/local/etc/pdm-wba/src/wa_auto_enable_service.sh
wa_auto_enable_service "${changed_file}"