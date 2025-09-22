Name: pdm-wba
Version: 1.0.4
Release: 1%{?dist}
Summary: Podman based Web Application Server
License: GPL-3.0-or-later
BuildRequires: systemd-rpm-macros

%description
Podman based Web Application Server

%prep
# No prep needed

%build
# No build needed

%install
# Create tmp dir in buildroot
mkdir -p %{buildroot}/tmp

# Debug information to help understand the build environment
echo "Current directory structure:"
pwd
find . -type d | grep -v "^\.$" | sort


# Generate list of directories for restorecon
find . -path "./src/_raw/*" -type d | sed 's|^./src/_raw/||' > %{buildroot}/tmp/pdm-wba-restorecon-dirs

# 1. Directories → 755
find . -path "./src/_raw/*" -type d -exec sh -c 'install -dm755 "$1" "%{buildroot}/${1#./src/_raw/}"' _ {} \;

# 2. Shell scripts → 755
find . -path "./src/_raw/*" -name "*.sh" -type f -exec sh -c 'install -Dm755 "$1" "%{buildroot}/${1#./src/_raw/}"' _ {} \;

# 3. All other files → 644
find . -path "./src/_raw/*" -type f ! -name "*.sh" -exec sh -c 'install -Dm644 "$1" "%{buildroot}/${1#./src/_raw/}"' _ {} \;

%files
%defattr(-,root,root,-)
/etc/*
/run/*
/usr/*
/tmp/pdm-wba-restorecon-dirs

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