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
tree .

%build
# No build needed

%install
BLD_DIR=%{buildroot}
SRC_DIR=$(realpath .)
WBA_DIR="${SRC_DIR}/src/_raw/"
echo "Source directory: ${SRC_DIR}"
echo "Build directory: ${BLD_DIR}"
echo "WBA directory: ${WBA_DIR}"

tree "${SRC_DIR}"
tree "${WBA_DIR}"
tree "${BLD_DIR}"

# Create tmp dir in buildroot
mkdir -p %{buildroot}/tmp

# Generate list of directories for restorecon
find . -path "${WBA_DIR}/*" -type d | sed 's|^./src/_raw/||' > %{buildroot}/tmp/pdm-wba-restorecon-dirs

# 1. Directories → 755
find . -path "${WBA_DIR}/*" -type d -exec sh -c 'install -dm755 "$1" "%{buildroot}/${1#./src/_raw/}"' _ {} \;

# 2. Shell scripts → 755
find . -path "${WBA_DIR}/*" -name "*.sh" -type f -exec sh -c 'install -Dm755 "$1" "%{buildroot}/${1#./src/_raw/}"' _ {} \;

# 3. All other files → 644
find . -path "${WBA_DIR}/*" -type f ! -name "*.sh" -exec sh -c 'install -Dm644 "$1" "%{buildroot}/${1#./src/_raw/}"' _ {} \;

%files
%defattr(-,root,root,-)
/tmp/pdm-wba-restorecon-dirs
%{_unitdir}/pdm-wba-init.service

%post
if [ -f /tmp/pdm-wba-restorecon-dirs ]; then
    cat /tmp/pdm-wba-restorecon-dirs | while read -r dir; do
        [ -n "$dir" ] && [ -e "/$dir" ] && restorecon -Rv "/$dir" 2>/dev/null || :
    done
    rm -f /tmp/pdm-wba-restorecon-dirs
fi
%systemd_post pdm-wba-init.service

%postun
if [ $1 -eq 0 ]; then
    if [ -f /tmp/pdm-wba-restorecon-dirs ]; then
        cat /tmp/pdm-wba-restorecon-dirs | while read -r dir; do
            [ -n "$dir" ] && [ -e "/$dir" ] && restorecon -Rv "/$dir" 2>/dev/null || :
        done
    fi
fi
%systemd_postun pdm-wba-init.service

%changelog
* Mon Sep 22 2025 PDM WBA Packager - 1.0.3
- Initial package