#!/bin/bash
if [ $# -ne 2 ]; then
	echo 'usage: script filename "text to search"'
	exit
fi

file="$1"
REVISIONS=`svn log $file -q --stop-on-copy |grep "^r" | cut -d"r" -f2 | cut -d" " -f1`
for rev in $REVISIONS; do
    difftext=`svn diff -c $rev $file| tr -s " " | grep -v " -\ \- " | grep -C6 -e "$2"`
    if [ -n "$difftext" ]; then
        echo "$rev: $difftext"
    fi
done
