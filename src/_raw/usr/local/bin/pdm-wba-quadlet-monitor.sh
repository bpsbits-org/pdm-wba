#!/bin/bash
# pdm-wba-quadlet-monitor.sh
# /usr/local/bin
set +e
source /usr/local/etc/pdm-wba/cnf/main.conf
source /usr/local/etc/pdm-wba/src/wa_handle_quadlet_change.sh
# Wait for changes to files and trigger handler
inotifywait -m -e create,modify,delete --format '%w%f' "${WA_DIR_QUADLETS}" | while read -r CHANGED_FILE
do
    echo "Change of '${CHANGED_FILE}' occurred."
    wa_handle_quadlet_change "${CHANGED_FILE}"
done