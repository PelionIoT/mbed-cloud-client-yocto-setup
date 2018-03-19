#!/bin/sh

print_usage ()
{
  echo >&2 "usage: $0 [-r] [-f] NOTE! CURRENTLY ONLY RASPBERRYPI SDCARD SUPPORTED!"
  echo >&2 "  -r: re-partition the partition with label rootfs1 (default root filesystem)"
  echo >&2 "  -f: format the partition with label rootfs1 using ext3-filesystem"
}

re_partition ()
{
  start_addr=$(fdisk -l |grep $rootfs_device|awk '{print $2}')
  end_addr=$(fdisk -l |grep $rootfs_device|awk '{print $3}')

  #TODO: we are making a bold assumption that the partition number can be obtained by splitting string at p (e.g. /dev/mmcblk0p5)
  #This may not always be the case (e.g /dev/sda1). This works with Raspberrypi, but functionality with other boards may be problematic
  partition_number=$(echo $rootfs_device |cut -d"p" -f2)

  if [ -z "$partition_number" ] || [ "${INPUT_STRING//[0-9]}" != "" ]; then
    echo "Partition number empty or not a number! Partition number: $partition_number"
    exit 1
  fi

  umount /mnt/updatepartition

  echo "d
  $partition_number
  n
  l
  $start_addr
  $end_addr
  x
  f
  w
  "|fdisk /dev/mmcblk0

  mount -o sync $rootfs_device /mnt/updatepartition
}

format_partition ()
{
  umount /mnt/updatepartition
  mkfs.ext3 -L rootfs1 -F $rootfs_device
  mount -o sync $rootfs_device /mnt/updatepartition
}

rootfs_device=$(blkid |grep rootfs1|cut -d":" -f1)
partition=0
format=0

if [ $# -eq 0 ]; then
  print_usage
  exit 1
fi

while [ $# -gt 0 ]
do
  case "$1" in
    -r) partition=1;;
    -f) format=1;;
    -*)
      print_usage
      exit 1;;
    *)
      print_usage
      exit 1;;
  esac
  shift
done

if [ $partition -eq 1 ]; then
  re_partition
fi

if [ $format -eq 1 ]; then
  format_partition
fi
