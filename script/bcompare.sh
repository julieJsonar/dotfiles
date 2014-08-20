#!/bin/bash

if [ $# == 1 ]; then
	rm -f /tmp/"code_org_0"
	git show HEAD:$1 > /tmp/"code_org_0"
	bcompare -iu -nobackups /tmp/"code_org" $1
fi

if [ $# == 2 ]; then
	rm -f /tmp/"code_org_$2"
	git show HEAD~$2:$1 > /tmp/"code_org_$2"
	bcompare -iu -nobackups /tmp/"code_org_$2"  $1
fi
