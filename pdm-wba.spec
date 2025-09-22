Name: pdm-wba
Version: 1.0.2
Release: 1%{?dist}
Summary: Podman based Web Application Server
License: GPL-3.0-or-later

%description
Podman based Web Application Server

%prep
# No prep needed

%build
# No build needed

%install
pushd src/_raw || exit 1

# Generate list of directories for restorecon
find . -type d > %{buildroot}/tmp/pdm-wba-restorecon-dirs

# 1. Directories → 755
find . -type d -exec install -dm755 {} %{buildroot}/{} \;

# 2. Shell scripts → 755
find . -name "*.sh" -type f -exec install -Dm755 {} %{buildroot}/{} \;

# 3. All other files → 644
find . -type f ! -name "*.sh" -exec install -Dm644 {} %{buildroot}/{} \;

popd || exit 1

%files
%defattr(-,root,root,-)
/etc/
/run/
/usr/
tmp/pdm-wba-restorecon-dirs
%{_unitdir}/pdm-wba-init.service

%post
if [ -f /tmp/pdm-wba-restorecon-dirs ]; then
    sed "s|^\./||" /tmp/pdm-wba-restorecon-dirs | while read -r dir; do
        [ -n "$dir" ] && [ -e "/$dir" ] && restorecon -Rv "/$dir" 2>/dev/null || :
    done
    rm -f /tmp/pdm-wba-restorecon-dirs
fi
%systemd_post pdm-wba-init.service

%postun
if [ $1 -eq 0 ]; then
    if [ -f /tmp/pdm-wba-restorecon-dirs ]; then
        sed "s|^\./||" /tmp/pdm-wba-restorecon-dirs | while read -r dir; do
            [ -n "$dir" ] && [ -e "/$dir" ] && restorecon -Rv "/$dir" 2>/dev/null || :
        done
    fi
fi
%systemd_postun pdm-wba-init.service


%changelog
* Mon Sep 22 2025 PDM WBA Packager - 1.0.2
- Initial package