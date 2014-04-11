#!/bin/sh

cd ~/work
#NEWDIR=`date +"%Y-%m-%d"`
NEWDIR="2014-01-01"
readonly NEWDIR
rm -fr ${NEWDIR}
mkdir ${NEWDIR}
cd ${NEWDIR}
svn checkout http://scm-yvr.fortinet.com/svn/svnfos/FortiOS/branches/5.x/trunk/FortiOS/fortinet 5tr >/dev/null
cd 5tr
./Configure -m FGT_111C -k -d y -c
patch -p0 < ~/script/newversion.diff
make -s > log.build 2>&1
