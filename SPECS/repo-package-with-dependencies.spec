%global _prefix /usr/local

Name:    repo-package-with-dependencies
Version: 0.1
Release: 1
Summary: RPM repo for package with dependencies
Group:   Development Tools
License: ASL 2.0
Source0: repo-package-with-dependencies.sh
Source1: nginx-repo-package-with-dependencies.conf
Source2: repo-package-with-dependencies.conf
Requires: nginx
Requires: createrepo
Requires: yum-utils

%description

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p %{buildroot}/%{_bindir}
%{__install} -m 755 %{SOURCE0} %{buildroot}/%{_bindir}/%{name}
mkdir -p %{buildroot}/etc/nginx/conf.d/
cp -a %{SOURCE1} %{buildroot}/etc/nginx/conf.d/
cp -a %{SOURCE2} %{buildroot}/etc/
mkdir -p %{buildroot}/var/www/repo-package-with-dependencies

%files
%{_bindir}/%{name}
/etc/nginx/conf.d/nginx-repo-package-with-dependencies.conf
/etc/repo-package-with-dependencies.conf
%dir /var/www/repo-package-with-dependencies
