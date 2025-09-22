Name: pdm-wba
Version: 1.0.12
Release: 1%{?dist}
Summary: Podman based Web Application Server
License: GPL-3.0-or-later
BuildRequires: systemd-rpm-macros tree
Source0: https://github.com/bpsbits-org/pdm-wba/archive/refs/heads/main.tar.gz

%global debug_package %{nil}

%description
Podman based Web Application Server

%prep
%setup -q -c
echo "prep directory structure:"

%build
# No build needed

%install
SRC_DIR=$(realpath .)
WBA_DIR="${SRC_DIR}/pdm-wba-main/src/_raw"
BLD_DIR=%{buildroot}

# Go to source dir
cd "${WBA_DIR}" || exit 1

# 1. Generate list of directories for restorecon (only dirs with files)
find . -type f | sed 's|/[^/]*$||' | sed 's|^./|/|' | sort -u | grep -v '^/[^/]*$' > "${WBA_DIR}/usr/local/etc/pdm-wba/cnf/dirs-rs-con"
# 2. Directories → 755
find . -type d -exec sh -c 'install -dm755 "$1" "%{buildroot}/${1#./}"' _ {} \;
# 3. Shell scripts → 755
find . -name "*.sh" -type f -exec sh -c 'install -Dm755 "$1" "%{buildroot}/${1#./}"' _ {} \;
# 4. All other files → 644
find . -type f ! -name "*.sh" -exec sh -c 'install -Dm644 "$1" "%{buildroot}/${1#./}"' _ {} \;

# Go back to root dir
cd "${SRC_DIR}" || exit 1

# Generate dynamic files list for RPM packaging
> files.list
find "%{buildroot}" -type f | sed 's|^%{buildroot}||' | sort >> files.list

tree "${BLD_DIR}"

cat files.list

%files -f files.list
%defattr(-,root,root,-)

%post
if [ -f /usr/local/etc/pdm-wba/cnf/dirs-rs-con ]; then
    cat /usr/local/etc/pdm-wba/cnf/dirs-rs-con | while read -r dir; do
        [ -n "$dir" ] && [ -e "/$dir" ] && restorecon -Rv "/$dir" 2>/dev/null || :
    done
fi

# Enable the systemd service
%systemd_post pdm-wba-init.service

# Explicitly enable the service to start on boot
if [ $1 -eq 1 ]; then
    # Fresh install
    systemctl enable pdm-wba-init.service >/dev/null 2>&1 || :
    # Mark that reboot is required
    touch /run/reboot-required
    # Apply sys users immediately
    systemd-sysusers >/dev/null 2>&1 || :
    # Reload systemd to apply unit override changes
    systemctl daemon-reload >/dev/null 2>&1 || :
    # Apply tmp files
    systemd-tmpfiles --create >/dev/null 2>&1 || :
    # Trigger the one-time setup timer
    systemctl start pdm-wba-setup.timer >/dev/null 2>&1 || :
fi

%postun
if [ $1 -eq 0 ]; then
    if [ -f /usr/local/etc/pdm-wba/cnf/dirs-rs-con ]; then
        cat /usr/local/etc/pdm-wba/cnf/dirs-rs-con | while read -r dir; do
            [ -n "$dir" ] && [ -e "/$dir" ] && restorecon -Rv "/$dir" 2>/dev/null || :
        done
    fi
fi

# Handle service on uninstall
%systemd_postun pdm-wba-init.service

if [ $1 -eq 0 ]; then
    # Complete uninstall
    systemctl disable pdm-wba-init.service pdm-wba-setup.timer >/dev/null 2>&1 || :
fi

%changelog
* Mon Sep 22 2025 PDM WBA Packager - 1.0.12
- Initial package