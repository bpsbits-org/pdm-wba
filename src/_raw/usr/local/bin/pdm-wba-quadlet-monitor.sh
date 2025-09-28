#!/bin/bash
# pdm-wba-quadlet-monitor.sh

set -e
source /usr/local/etc/pdm-wba/cnf/main.conf
inotifywait -m -e create,modify,delete --format '%w%f' "${WA_DIR_QUADLETS}" | while read -r CHANGED_FILE
do
    echo "Quadlet: ${CHANGED_FILE}"
    /usr/local/bin/pdm-wba-auto-enable-service.sh "${CHANGED_FILE}"
done