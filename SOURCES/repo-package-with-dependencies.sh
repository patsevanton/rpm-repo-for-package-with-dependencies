#!/bin/bash

source /etc/repo-package-with-dependencies.conf

yum makecache

if [ ! -d $REPOS_ROOT ];
then
    echo "$REPOS_ROOT directory doesn't exists"
    exit 1
fi

if [ -z "$PACKAGES" ];
then
    echo "PACKAGES variable is empty"
    exit 1
fi

if rpm -qa | grep -q "$PACKAGES";
then
    echo ok
else
    echo Error: No matching "$PACKAGES" to list
    echo "rpm -qa | grep -q $PACKAGES"
    exit 1
fi

if repoclosure --pkg="$PACKAGES" | grep -q 'unresolved';
then
    echo unresolved dependencies "$PACKAGES"
    echo check: repoclosure --pkg="$PACKAGES"
    exit 1
fi

declare -a deps=( $(sort <(sed -e 's/ [| \\\_]\+\|-[[:digit:]]\+..*\|[[:digit:]]\://g' <(repoquery --tree-requires $PACKAGES )) | uniq) )

for i in "${deps[@]}"
do
    repo=$(repoquery -ai "$i" | grep 'Repository  : ' | cut -d ":" -f 2 | cut -d " " -f 2 | uniq)
    echo "$i"
    yumdownloader "$i" --destdir "$REPOS_ROOT$repo"

done

for dir in `ls $REPOS_ROOT`;
do
    find $REPOS_ROOT$dir -type f -name "*.i686.rpm" -delete
    createrepo $REPOS_ROOT$dir
done
