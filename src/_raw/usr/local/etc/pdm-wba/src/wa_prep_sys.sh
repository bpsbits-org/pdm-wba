#!/bin/bash
# wa_prep_sys.sh

wa_prep_sys(){
    echo "Adjusting system..."

    # Preset services if systemctl available
    if command -v systemctl >/dev/null 2>&1; then
        if systemctl preset firewalld.service cockpit.socket pmcd.service pmlogger.service user@5100.service 2>/dev/null; then
            echo "Services preset successfully"
        else
            echo "Warning: Failed to preset some services"
        fi
    else
        echo "Warning: systemctl not available - skipping service preset"
    fi

    # Firewall rules if firewalld available
    if command -v firewall-cmd >/dev/null 2>&1; then
        if firewall-cmd --permanent --remove-service=ssh 2>/dev/null && \
           firewall-cmd --permanent --zone=public --add-service=wa 2>/dev/null && \
           firewall-cmd --reload 2>/dev/null; then
            echo "Firewall rules applied successfully"
        else
            echo "Warning: Failed to apply firewall rules"
        fi
    else
        echo "Warning: firewalld not available - skipping firewall rules"
    fi

    # SELinux rules if semanage available
    if command -v semanage >/dev/null 2>&1; then
        if semanage import -f /etc/selinux/local/port-config.semanage 2>/dev/null; then
            echo "SELinux rules applied successfully"
        else
            echo "Warning: Failed to apply SELinux rules"
        fi
    else
        echo "Warning: semanage not available - skipping SELinux rules"
    fi

    # System config
    if sysctl --system 2>/dev/null; then
        echo "System configuration applied"
    else
        echo "Warning: Failed to apply system configuration"
    fi

    if command -v systemctl >/dev/null 2>&1 && systemctl daemon-reload 2>/dev/null; then
        echo "System daemon reloaded"
    else
        echo "Warning: Failed to reload systemd daemon"
    fi

    echo "System prepared"
}