#!/bin/sh

#Custom init script based on the one found in poky/meta-openembedded/meta-initramfs

PATH=/sbin:/bin:/usr/sbin:/usr/bin

do_mount_fs() {
	grep -q "$1" /proc/filesystems || return
	test -d "$2" || mkdir -p "$2"
	mount -t "$1" "$1" "$2"
}

do_mknod() {
	test -e "$1" || mknod "$1" "$2" "$3" "$4"
}

do_obtain_ip(){
	#the init-script finishes before the ethernet device is found -> udhcpc crashes on start
	#try to start it few times so the daemon is started when the device is found
	while [ 1 ]; do
		/sbin/udhcpc >/dev/kmsg 2>/dev/kmsg
		#without this, the loop creates infinite amount of instances when ip is obtained since udhcpc forks to background
		if [ $? -eq 0 ]; then
			break
		fi
		sleep 1
	done
}

#Function that checks if device to be mounted exists, and then mounts the dev if it does
#Occasionally it happens that init runs before the sdcard is detected, and the mounts fail. This prevents that
do_wait_and_mount(){
	while [ 1 ]; do
		ls "$2"
		if [ $? -eq 0 ]; then
			mount $1 "$2" "$3"
			echo "Device $2 mounted" >/dev/kmsg 2>/dev/kmsg
			break
		fi
		sleep 1
	done
}

mkdir -p /proc
mount -t proc proc /proc

do_mount_fs sysfs /sys
do_mount_fs debugfs /sys/kernel/debug
do_mount_fs devtmpfs /dev
do_mount_fs devpts /dev/pts
do_mount_fs tmpfs /dev/shm

mkdir -p /run
mkdir -p /var/run

do_mknod /dev/console c 5 1
do_mknod /dev/null c 1 3
do_mknod /dev/zero c 1 5

do_wait_and_mount "-o ro" /dev/mmcblk0p1 /boot
do_wait_and_mount "-o sync" /dev/mmcblk0p5 /mnt/updatepartition

# Raas-flashing with rsync: always flash into p5/rootfs1
# and clear also flags + cache -partitions to clear bootflags and headers
# to default. Otherwise active firmware header is preserved and we cannot
# revert to older original image and update older image than which have been
# previously updated
mkfs.ext3 -v -L bootflags -F /dev/mmcblk0p2
sync
mkfs.ext3 -v -L cache -F /dev/mmcblk0p8
sync
mkdir -p /mnt/flags
do_wait_and_mount "-o sync" /dev/mmcblk0p2 /mnt/flags
if [ -e /mnt/flags/six ] || [ -e /mnt/flags/five ]
then
    echo "ERROR: flags -partion was not cleared - removing all files.."  >/dev/kmsg 2>/dev/kmsg
    rm -v /mnt/flags/*
    sync
fi


rsync --daemon
if [ $? -eq 0 ]; then
	echo "rsync started" >/dev/kmsg 2>/dev/kmsg
fi

do_obtain_ip &

echo "Initialization done, dropping to prompt." >/dev/kmsg 2>/dev/kmsg

exec sh </dev/console >/dev/console 2>/dev/console
