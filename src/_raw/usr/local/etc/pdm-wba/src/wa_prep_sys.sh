#!/bin/bash
# wa_prep_sys.sh
# /usr/local/etc/pdm-wba/src

# Waits for firewall-cmd and semanage tools to become available with timeout
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

wa_make_remote_rss_key_if_needed(){
    local wa_rss_key_file wa_ssh_dir epoch
    epoch=$(date +%s)
    wa_rss_key_file="/home/wa/.ssh/wa_remote_rss"
    wa_ssh_dir="$(dirname "${wa_rss_key_file}")"
    if [ ! -f "${wa_rss_key_file}" ]; then
        mkdir -p "${wa_ssh_dir}"
        ssh-keygen -t rsa -b 4096 -f "${wa_rss_key_file}" -q -N "" -C "wa-rss-${epoch}@${HOSTNAME}"
        chown -R wa:wa "${wa_ssh_dir}"
        chmod 700 "${wa_ssh_dir}"
        chmod 600 "${wa_rss_key_file}"
    fi
}

# Prepares the system for WA by configuring services, firewall, SELinux, and user settings
wa_prep_sys(){
    echo "Adjusting system..."

    # Wait for essential tools (max 10 seconds)
    wait_for_tools || echo "Warning: Required tools are not available!"

    # Enable linger for wa
    echo "Enabling linger for wa..."
    mkdir -p /var/lib/systemd/linger
    touch /var/lib/systemd/linger/wa
    chown root:root /var/lib/systemd/linger/wa
    chmod 0644 /var/lib/systemd/linger/wa
cat >> /home/wa/.bashrc << 'EOF'
source /usr/local/etc/pdm-wba/cnf/wa.conf
source "${WA_USER_ALIASES}"
wa_user_wa_aliases
EOF
cat > /home/wa/.bash_profile << 'EOF'
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
EOF
    chown -R wa:wa /home/wa
    systemctl restart systemd-logind
    systemctl --machine="300@.host" --user enable systemd-tmpfiles-setup.service
    systemctl --machine="300@.host" --user start systemd-tmpfiles-setup.service

    # Enable Firewall
    systemctl enable firewalld
    systemctl start firewalld

    # Import presets
    systemctl preset firewalld.service cockpit.socket pmcd.service pmlogger.service user@300.service 2>/dev/null || true

    # Update Firewall
    firewall-cmd --permanent --remove-service=ssh 2>/dev/null || true
    firewall-cmd --permanent --zone=public --add-service=pdm-wba 2>/dev/null || true
    firewall-cmd --reload 2>/dev/null || true

    # Update SELinux
    semanage import -f /etc/selinux/local/port-config.semanage 2>/dev/null || true

    # Make user Podman compatible
    usermod --add-subuids 100000-165535 --add-subgids 100000-165535 wa || true
    su - wa -c "podman system migrate" || true

    # Update System
    sysctl --system 2>/dev/null || true
    systemctl daemon-reload 2>/dev/null || true

    # Start podman
    systemctl --machine="300@.host" --user enable podman.socket
    systemctl --machine="300@.host" --user start podman.socket

    # Enable WA Quadlet Drop Monitor
    systemctl enable pdm-wba-monitor-qd-install-dir.path 2>/dev/null || true
    systemctl enable pdm-wba-monitor-quadlet-dir.service 2>/dev/null || true
    #
    systemctl enable pdm-wba-quadlet-install.service 2>/dev/null || true
    systemctl enable pdm-wba-auto-enable.service 2>/dev/null || true
    #
    systemctl start pdm-wba-monitor-qd-install-dir.path 2>/dev/null || true
    systemctl start pdm-wba-monitor-quadlet-dir.service 2>/dev/null || true
    #
    systemctl enable fail2ban 2>/dev/null || true
    systemctl start fail2ban 2>/dev/null || true

    # Make remote rss key for wa
    wa_make_remote_rss_key_if_needed

    #
    echo "System prepared"
}