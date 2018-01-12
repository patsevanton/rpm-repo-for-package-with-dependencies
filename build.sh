#!/bin/bash

list_dependencies=(rpm-build rpmdevtools)

for i in ${list_dependencies[*]}
do
    if ! rpm -qa | grep -qw $i; then
        echo "__________Dont installed '$i'__________"
        #yum -y install $i
    fi
done

rm -f *.rpm

spectool -g -R SPECS/repo-package-with-dependencies.spec
rpmbuild -bb --define "_topdir $PWD" SPECS/repo-package-with-dependencies.spec
mv ./RPMS/x86_64/*.rpm .
./clean.sh
