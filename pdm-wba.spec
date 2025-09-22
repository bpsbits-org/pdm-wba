Name: pdm-wba
Version: 1.0.4
Release: 1%{?dist}
Summary: Podman based Web Application Server
License: GPL-3.0-or-later
BuildRequires: systemd-rpm-macros tree
Source0: https://github.com/bpsbits-org/pdm-wba/archive/refs/heads/main.tar.gz

%description
Podman based Web Application Server

%prep
%setup -q -c
echo "prep directory structure:"

%build
# No build needed

%install
tree .
SRC_DIR=$(realpath .)
WBA_DIR="${SRC_DIR}/pdm-wba-main/src/_raw"
BLD_DIR=%{buildroot}

echo "Source directory: ${SRC_DIR}"
echo "Build directory: ${BLD_DIR}"
echo "WBA directory: ${WBA_DIR}"

tree "${WBA_DIR}"

# 1. Generate list of directories for restorecon
(cd "${WBA_DIR}" && find . -mindepth 1 -type d | cut -c2-) > "${WBA_DIR}/usr/local/etc/pdm-wba/cnf/dirs-rs-con"
cat "${WBA_DIR}/usr/local/etc/pdm-wba/cnf/dirs-rs-con"
# 2. Directories → 755
(cd "${WBA_DIR}" && find . -type d -exec sh -c 'install -dm755 "$1" "${BLD_DIR}/${1#./}"' _ {} \;)
# 3. Shell scripts → 755
(cd "${WBA_DIR}" && find . -name "*.sh" -type f -exec sh -c 'install -Dm755 "$1" "${BLD_DIR}/${1#./}"' _ {} \;)
# 4. All other files → 644
(cd "${WBA_DIR}" && find . -type f ! -name "*.sh" -exec sh -c 'install -Dm644 "$1" "${BLD_DIR}/${1#./}"' _ {} \;)

tree "${BLD_DIR}"

%files
%defattr(-,root,root,-)
/etc
/run
/usr

%post
if [ -f /usr/local/etc/pdm-wba/cnf/dirs-rs-con ]; then
    cat /usr/local/etc/pdm-wba/cnf/dirs-rs-con | while read -r dir; do
        [ -n "$dir" ] && [ -e "/$dir" ] && restorecon -Rv "/$dir" 2>/dev/null || :
    done
    rm -f /usr/local/etc/pdm-wba/cnf/dirs-rs-con
fi

%systemd_post pdm-wba-init.service

%postun
if [ $1 -eq 0 ]; then
    if [ -f /usr/local/etc/pdm-wba/cnf/dirs-rs-con ]; then
        cat /usr/local/etc/pdm-wba/cnf/dirs-rs-con | while read -r dir; do
            [ -n "$dir" ] && [ -e "/$dir" ] && restorecon -Rv "/$dir" 2>/dev/null || :
        done
    fi
fi

%systemd_postun pdm-wba-init.service

%changelog
* Mon Sep 22 2025 PDM WBA Packager - 1.0.3
- Initial package