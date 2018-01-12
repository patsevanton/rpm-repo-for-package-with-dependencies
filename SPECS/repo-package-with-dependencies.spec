%global _prefix /usr/local

Name:    repo-package-with-dependencies
Version: 1.1
Release: 1
Summary: RPM repo for package with dependencies
Group:   Development Tools
License: ASL 2.0
Source0: repo-package-with-dependencies.sh
Source1: nginx-repo-package-with-dependencies.conf
Source2: package-list.conf
Source3: repo.conf
Requires: nginx
Requires: createrepo
Requires: yum-utils

%description
RPM repo for package with dependencies

%pre
rm -f /etc/nginx/conf.d/default.conf

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p %{buildroot}/%{_bindir}
%{__install} -m 755 %{SOURCE0} %{buildroot}/%{_bindir}/%{name}
mkdir -p %{buildroot}/etc/nginx/conf.d/
mkdir -p %{buildroot}/var/www/repo-package-with-dependencies
mkdir -p %{buildroot}/etc/repo-package-with-dependencies
cp -a %{SOURCE1} %{buildroot}/etc/nginx/conf.d/
cp -a %{SOURCE2} %{buildroot}/etc/repo-package-with-dependencies
cp -a %{SOURCE3} %{buildroot}/etc/repo-package-with-dependencies

%files
%{_bindir}/%{name}
/etc/nginx/conf.d/nginx-repo-package-with-dependencies.conf
/etc/repo-package-with-dependencies/repo.conf
/etc/repo-package-with-dependencies/package-list.conf

%dir /var/www/repo-package-with-dependencies
