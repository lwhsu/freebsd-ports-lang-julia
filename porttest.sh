#!/bin/sh

PORTSDIR=/usr/ports

set -ex

pwd

cd /usr
mv ports ports.old
portsnap --interactive fetch extract
git clone --depth=1 --single-branch -b main https://github.com/freebsd/freebsd-ports.git ports

# copy the file to PORTSDIR
cd ${CIRRUS_WORKING_DIR}
make PORTSTREE=${PORTSDIR}
make PORTSTREE=${PORTSDIR} options

mkdir /usr/ports/distfiles

df -h

echo "NO_ZFS=yes" >> /usr/local/etc/poudriere.conf
echo "ALLOW_MAKE_JOBS=yes" >> /usr/local/etc/poudriere.conf
sed -i.bak -e 's,FREEBSD_HOST=_PROTO_://_CHANGE_THIS_,FREEBSD_HOST=https://download.FreeBSD.org,' /usr/local/etc/poudriere.conf
mkdir -p /usr/local/poudriere

poudriere jail -c -j jail -v `uname -r`
poudriere ports -c -f none -m null -M /usr/ports

# bootstrap pkg repo
poudriere bulk -t -j jail ports-mgmt/pkg

PORT=lang/julia

cd /usr/ports
cd ${PORT}
PWD=`pwd -P`
PORTDIR=`dirname ${PWD}`
PORTDIR=`dirname ${PORTDIR}`
make all-depends-list | sed -e "s,${PORTDIR}/,," | xargs sudo \
	pkg fetch -y -o /usr/local/poudriere/data/packages/jail-default/.latest

if [ ${PORT_OPTION_SET} ]
then
    poudriere testport -j jail -z ${PORT_OPTION_SET} ${PORT}
else
    poudriere testport -j jail ${PORT}
fi
