#!/bin/sh

PORTSDIR=/usr/ports

set -ex

pwd

mkdir -p /usr/local/poudriere

mv /usr/ports /usr/ports.old
git clone https://github.com/freebsd/freebsd-ports /usr/ports

# copy the file to PORTSDIR
make -C ${CIRRUS_WORKING_DIR} PORTSTREE=${PORTSDIR}
make -C ${CIRRUS_WORKING_DIR} PORTSTREE=${PORTSDIR} options

mkdir /usr/ports/distfiles

df -h

echo "NO_ZFS=yes" >> /usr/local/etc/poudriere.conf
echo "ALLOW_MAKE_JOBS=yes" >> /usr/local/etc/poudriere.conf
sed -i.bak -e 's,FREEBSD_HOST=_PROTO_://_CHANGE_THIS_,FREEBSD_HOST=https://download.FreeBSD.org,' /usr/local/etc/poudriere.conf

poudriere jail -c -j jail -v `uname -r`
poudriere ports -c -f none -m null -M /usr/ports

# use an easy port to bootstrap pkg repo
poudriere bulk -t -j jail net/nc

PORT=lang/julia

cd /usr/ports
cd ${PORT}
PWD=`pwd -P`
PORTDIR=`dirname ${PWD}`
PORTDIR=`dirname ${PORTDIR}`
make all-depends-list | sed -e "s,${PORTDIR}/,," | xargs sudo pkg fetch -y -o pkgs
rm -fr /usr/local/poudriere/data/packages/jail-default/.latest/All
mv pkgs/All /usr/local/poudriere/data/packages/jail-default/.latest/
rm -fr pkgs

if [ ${PORT_OPTION_SET} ]
then
    poudriere testport -j jail -z ${PORT_OPTION_SET} ${PORT}
else
    poudriere testport -j jail ${PORT}
fi
