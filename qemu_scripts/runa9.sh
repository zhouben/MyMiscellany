#!/bin/sh
# run qemu-system-arm for vexpress-a9
KERNEL_IMAGE=../linux-3.16.44/arch/arm/boot/zImage
qemu-system-arm $* -M vexpress-a9 -m 512 -kernel $KERNEL_IMAGE  -append "root=/dev/mmcblk0 rw console=ttyAMA0" -nographic -sd a9rootfs.ext3 
