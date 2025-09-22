Name: pdm-wba
Version: 1.0
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

# Generate list of directories for restorecon (same logic)
find . -type d > %{buildroot}/%%{_tmpfilesdir}/pdm-wba-restorecon-dirs

# 1. Directories → 755 (use relative paths after pushd)
find . -type d -exec install -dm755 {} %{buildroot}/{} \;

# 2. Shell scripts → 755 (executable) (use relative paths after pushd)
find . -name "*.sh" -type f -exec install -Dm755 {} %{buildroot}/{} \;

# 3. All other files → 644 (use relative paths after pushd)
find . -type f ! -name "*.sh" -exec install -Dm644 {} %{buildroot}/{} \;

popd || exit 1

%files
%defattr(-,root,root,-)
/etc/
/run/
/usr/
%{_tmpfilesdir}/pdm-wba-restorecon-dirs

%post
# Use the generated list (same find logic, but on target system)
if [ -f %{_tmpfilesdir}/pdm-wba-restorecon-dirs ]; then
    sed "s|^\./||" %{_tmpfilesdir}/pdm-wba-restorecon-dirs | while read -r dir; do
        [ -n "$dir" ] && [ -e "/$dir" ] && restorecon -Rv "/$dir" 2>/dev/null || :
    done
    rm -f %{_tmpfilesdir}/pdm-wba-restorecon-dirs
fi

# Enable service automatically
%systemd_post pdm-wba-init.service

%postun
if [ $1 -eq 0 ]; then
    # Same logic for cleanup
    if [ -f %{_tmpfilesdir}/pdm-wba-restorecon-dirs ]; then
        sed "s|^\./||" %{_tmpfilesdir}/pdm-wba-restorecon-dirs | while read -r dir; do
            [ -n "$dir" ] && [ -e "/$dir" ] && restorecon -Rv "/$dir" 2>/dev/null || :
        done
    fi
fi

# Disable service on uninstall
%systemd_postun pdm-wba-init.service