#!/bin/bash
# pdm-wba-auto-enable-service.sh

set -e
export XDG_RUNTIME_DIR=/run/user/5100
source /usr/local/etc/pdm-wba/src/wa_auto_enable_service.sh

changed_file="$1"

[ -z "${changed_file}" ] || [ ! -f "${changed_file}" ] && exit 0

wa_auto_enable_service "${changed_file}"