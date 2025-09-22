#!/bin/bash
# wa_prep_sys.sh

wait_for_tools() {
    local timeout=10
    local count=0
    # First check if tools are already available
    if command -v firewall-cmd >/dev/null 2>&1 && command -v semanage >/dev/null 2>&1; then
        return 0  # Tools are available, exit immediately
    fi
    # If tools aren't available yet, wait and check periodically
    echo "Waiting for tools to become available..."
    while [ $count -lt $timeout ]; do
        sleep 3
        count=$((count + 1))
        if command -v firewall-cmd >/dev/null 2>&1 && command -v semanage >/dev/null 2>&1; then
            return 0  # Tools are now available
        fi
        echo "Still waiting... ($count/$timeout)"
    done
    # If we reached here, the tools were not available within the timeout
    echo "Error: Required tools (firewall-cmd and semanage) not available after $timeout tries" >&2
    return 1
}

wa_prep_sys(){
    echo "Adjusting system..."

    # Wait for essential tools (max 10 seconds)
    wait_for_tools || echo "Warning: Required tools are not available!"

    # Services
    systemctl preset firewalld.service cockpit.socket pmcd.service pmlogger.service user@5100.service 2>/dev/null || true

    # Firewall
    firewall-cmd --permanent --remove-service=ssh 2>/dev/null || true
    firewall-cmd --permanent --zone=public --add-service=pdm-wba 2>/dev/null || true
    firewall-cmd --reload 2>/dev/null || true

    # SELinux
    semanage import -f /etc/selinux/local/port-config.semanage 2>/dev/null || true

    # System
    sysctl --system 2>/dev/null || true
    systemctl daemon-reload 2>/dev/null || true
    #
    systemctl enable pdm-wba-install.path 2>/dev/null || true
    systemctl enable pdm-wba-install.service 2>/dev/null || true
    systemctl start pdm-wba-install.path 2>/dev/null || true
    #

    echo "System prepared"
}