Name: pdm-wba
Version: 1.0
Release: 1%{?dist}
Summary: Podman based Web Application Server
License: GPL-3.0-or-later

%description
Podman based Web Application Server

%prep
%setup -q -T -D

%build
# No build needed

%install
# Generate list of directories for restorecon
find src/_raw -type d | sed 's|src/_raw/||' > %{buildroot}/tmp/%{name}-restorecon-dirs

# 1. Directories → 755
find src/_raw -type d -exec sh -c 'install -dm755 "$1" "%{buildroot}/${1#src/_raw/}"' _ {} \;

# 2. Shell scripts → 755
find src/_raw -name "*.sh" -type f -exec sh -c 'install -Dm755 "$1" "%{buildroot}/${1#src/_raw/}"' _ {} \;

# 3. All other files → 644
find src/_raw -type f ! -name "*.sh" -exec sh -c 'install -Dm644 "$1" "%{buildroot}/${1#src/_raw/}"' _ {} \;

%files
%defattr(-,root,root,-)
/etc/
/run/
/usr/
tmp/%{name}-restorecon-dirs
%{_unitdir}/pdm-wba-init.service

%post
if [ -f /tmp/%{name}-restorecon-dirs ]; then
    cat /tmp/%{name}-restorecon-dirs | while read -r dir; do
        [ -n "$dir" ] && [ -e "/$dir" ] && restorecon -Rv "/$dir" 2>/dev/null || :
    done
    rm -f /tmp/%{name}-restorecon-dirs
fi

%systemd_post pdm-wba-init.service

%postun
if [ $1 -eq 0 ]; then
    if [ -f /tmp/%{name}-restorecon-dirs ]; then
        cat /tmp/%{name}-restorecon-dirs | while read -r dir; do
            [ -n "$dir" ] && [ -e "/$dir" ] && restorecon -Rv "/$dir" 2>/dev/null || :
        done
    fi
fi

%systemd_postun pdm-wba-init.service