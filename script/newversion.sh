#!/bin/sh

cd ~/work
#NEWDIR=`date +"%Y-%m-%d"`
NEWDIR="2014-01-01"
readonly NEWDIR
rm -fr ${NEWDIR}
mkdir ${NEWDIR}
cd ${NEWDIR}
svn checkout http://scm-yvr.fortinet.com:8080/svn/svnfos/FortiOS/branches/5.x/5.2/trunk/FortiOS/fortinet 5.2-VM64 >/dev/null
cd 5.2-VM64

#./Configure -m FGT_111C -k -d y -c
./Configure -m FGT_VM64 -k -d y -c -l all

patch -p0 < ~/script/newversion.diff
make image -s > log.build 2>&1
