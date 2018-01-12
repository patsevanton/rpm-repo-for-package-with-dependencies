#!/bin/bash -x

source /etc/repo-package-with-dependencies.conf

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

if yum list "$PACKAGES" | grep 'Error: No matching'; then
        echo "$PACKAGES" in repo
    else
        echo Error: No matching "$PACKAGES" to list
        echo check: yum list "$PACKAGES"
        exit 1
fi

if repoclosure --pkg="$PACKAGES" | grep -q 'unresolved'; then
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
