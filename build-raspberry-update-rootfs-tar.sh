#!/bin/sh

WORKDIR=$(pwd)
FILENAME=${2}-raspberrypi3-$(date +%G%m%d%H%M%S).rootfs.tar

cd "${1}/tmp/deploy/images/raspberrypi3"
if [ ! -e tmp ]; then
    mkdir tmp
fi
rm -rf tmp/*
cd tmp

# The final image tar package has some specific post-install steps applied:
# /etc/shadow and couple of others have different filemode compared to files in 
# rootfs -directory under tmp/work... below. For this reason extracting the tar
# package and rebuilding a new tar package out of it.
tar xpjf ../*.rootfs.tar.bz2 .
tar  --exclude='run/*' --exclude='var/lib' --exclude='var/volatile' --exclude='lost+found' --sort=name --format=ustar --mtime="2019-01-01 00:00Z" --owner=0 --group=0 --numeric-owner --one-file-system -cpf ${WORKDIR}/${FILENAME} *
echo "Update tar package (for delta) made with name:" ${WORKDIR}/${FILENAME}
cd ${WORKDIR}
