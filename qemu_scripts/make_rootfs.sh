#!/bin/sh
# make rootfs(root file system) for QEMU virtual machine.
# make subdirectory rootfs, copy necessary files from busybox to rootfs.
#
BUSYBOX_PATH=../busybox-1.26.2
CROSS_COMPILE_LIBC_PATH=/usr/local/gcc-linaro-6.3.1-2017.02-x86_64_arm-linux-gnueabi/arm-linux-gnueabi/libc/lib
[ -d rootfs ] && rm -rf rootfs
mkdir rootfs
cp -r $BUSYBOX_PATH/_install/* rootfs
cd rootfs
mkdir -p lib sys proc dev tmp  root etc etc/init.d proc/sys/kernel etc/network
sudo mknod dev/tty1 c 4 1
sudo mknod dev/tty2 c 4 2
sudo mknod dev/tty3 c 4 3
sudo mknod dev/tty4 c 4 4

cat > etc/init.d/rcS <<EOF
mount -a
echo /sbin/mdev > /proc/sys/kernel/hotplug
mdev -s
EOF
chmod 755 etc/init.d/rcS

cat > etc/fstab <<EOF
proc /proc proc defaults 0 0
sysfs /sys sysfs defaults 0 0
mdev /dev ramfs defaults 0 0
EOF

cd ..
cp -r $CROSS_COMPILE_LIBC_PATH/* rootfs/lib/
