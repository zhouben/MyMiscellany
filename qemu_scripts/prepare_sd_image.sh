#!/bin/sh
# make an image file with ext3 format for rootfs
#
# 1. create an image file with 256M bytes and format it by ext3
# 2. mount the image file to subdirectory "tmpfs"
# 3. copy all files from rootfs to tmpfs
# 4. umount the image file.
#
set -e
[ -d rootfs ] || (echo rootfs is needed. exit! && exit 1)
[ -d tmpfs ] || mkdir tmpfs
dd if=/dev/zero of=a9rootfs.ext3 bs=1M count=256
mkfs.ext3 -t ext3 a9rootfs.ext3
sudo mount -t ext3 a9rootfs.ext3 tmpfs -o loop
sudo cp -r rootfs/* tmpfs
sudo umount tmpfs
