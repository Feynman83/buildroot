#!/bin/bash

if [ -f /dev/fb0 ]; then
    echo "XBM" >/etc/hostname
elif [ -f /dev/i2c-0 ]; then
    echo "RBC02" >/etc/hostname
else
    echo "XDUD-G3000" >/etc/hostname
fi

umount /home/xbrother
sleep 1
ubidetach -m 3
sleep 1
flash_erase /dev/mtd3 0 0
sleep 1
ubiformat /dev/mtd3 -y
sleep 1
ubiattach /dev/ubi_ctrl -m 3
sleep 1
if [ -c /dev/ubi1 ]; then
    ubimkvol /dev/ubi1 -m -N data
    sleep 1
    mount -t ubifs ubi1:data /home/xbrother
else
    ubimkvol /dev/ubi0 -m -N data
    sleep 1
    mount -t ubifs ubi0:data /home/xbrother
fi

rm -rf /etc/init.d/S11startup.sh

sync
sync

reboot
