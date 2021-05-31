#!/bin/bash

if [ -c /dev/fb0 ]; then
    echo "XBM" >/etc/hostname
    rm -rf /boot/zImage-A02
    rm -rf /boot/zImage-C02
    rm -rf /etc/network/interfaces
    mv /etc/network/interfaces-XBM /etc/network/interfaces
    if [ -f /home/970uimage-XBM ]; then
        flash_erase /dev/mtd1 0 0
        nandwrite -p /dev/mtd1 /home/970uimage-XBM
        rm -rf /boot/zImage-XBM
    fi
   
elif [ -c /dev/i2c-0 ]; then
    echo "RBC02" >/etc/hostname
    rm -rf /boot/zImage-XBM
    rm -rf /boot/zImage-A02
    rm -rf /etc/network/interfaces-XBM
    if [ -f /home/970uimage-C02 ]; then
        flash_erase /dev/mtd1 0 0
        nandwrite -p /dev/mtd1 /home/970uimage-C02
        rm -rf /boot/zImage-C02
    fi
else
    echo "XDUD-G3000" >/etc/hostname
    rm -rf /boot/zImage-XBM
    rm -rf /boot/zImage-C02
    rm -rf /etc/network/interfaces-XBM
    if [ -f /home/970uimage-A02 ]; then
        flash_erase /dev/mtd1 0 0
        nandwrite -p /dev/mtd1 /home/970uimage-A02
        rm -rf /boot/zImage-A02
    fi
fi


ln -s /home/xbrother /xbrother

umount /home
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
    mount -t ubifs ubi1:data /home
else
    ubimkvol /dev/ubi0 -m -N data
    sleep 1
    mount -t ubifs ubi0:data /home
fi

mkdir -p /home/xbrother/app
mkdir -p /home/xbrother/data
mkdir -p /home/legion

rm -rf /etc/init.d/S11startup.sh

sync
sync

reboot
