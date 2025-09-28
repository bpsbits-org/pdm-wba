#!/bin/bash
# pdm-wba-auto-enable-service.sh
# /usr/local/bin
set -e
changed_file="$1"
echo "Quadlet change: ${changed_file}"
[ -z "${changed_file}" ] || [ ! -f "${changed_file}" ] && exit 0
source /usr/local/etc/pdm-wba/src/wa_auto_enable_service.sh
wa_auto_enable_service "${changed_file}"