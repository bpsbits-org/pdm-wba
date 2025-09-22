#!/bin/bash
# wa_prep_sys.sh

wait_for_tools() {
    local timeout=10
    local count=0
    while [ $count -lt $timeout ]; do
        command -v firewall-cmd >/dev/null 2>&1 && command -v semanage >/dev/null 2>&1 && return 0
        sleep 3
        count=$((count + 1))
        echo "Waiting when tools are available..."
    done
}

wa_prep_sys(){
    echo "Adjusting system..."

    # Wait for essential tools (max 10 seconds)
    wait_for_tools

    # Services
    systemctl preset firewalld.service cockpit.socket pmcd.service pmlogger.service user@5100.service 2>/dev/null || true

    # Firewall
    firewall-cmd --permanent --remove-service=ssh 2>/dev/null || true
    firewall-cmd --permanent --zone=public --add-service=wa 2>/dev/null || true
    firewall-cmd --reload 2>/dev/null || true

    # SELinux
    semanage import -f /etc/selinux/local/port-config.semanage 2>/dev/null || true

    # System
    sysctl --system 2>/dev/null || true
    systemctl daemon-reload 2>/dev/null || true

    echo "System prepared"
}