#!/bin/sh

UDIR=/media/BOOT

ROOT=$(df / | grep ubi0:rootfs)

if [ ! -z "${ROOT}" ]; then
    if [ -f ${UDIR}/env.bin ]; then
        echo "burn environment..."
        echo default-on >/sys/class/leds/heartbeat/trigger
        flash_erase /dev/mtd0 0x80000 1
        nandwrite -p -s 0x80000 /dev/mtd0 ${UDIR}/env.bin

        if [ -f ${UDIR}/u-boot.bin ]; then
            echo "burn uboot..."
            flash_erase /dev/mtd0 0x100000 8
            nandwrite -p -s 0x100000 /dev/mtd0 ${UDIR}/u-boot.bin
        fi
        reboot
        exit 1
    fi
else

    echo timer >/sys/class/leds/heartbeat/trigger
    sleep 2
    echo 500 >/sys/class/leds/heartbeat/delay_on
    echo 500 >/sys/class/leds/heartbeat/delay_off

    if [ -f ${UDIR}/env.bin ]; then
        echo "burn environment..."
        flash_erase /dev/mtd0 0x80000 1
        nandwrite -p -s 0x80000 /dev/mtd0 ${UDIR}/env.bin
    fi

    if [ -f ${UDIR}/u-boot.bin ]; then
        echo "burn uboot..."
        flash_erase /dev/mtd0 0x100000 8
        nandwrite -p -s 0x100000 /dev/mtd0 ${UDIR}/u-boot.bin
    fi

    if [ -f /dev/i2c-0 ]; then
        echo "burn zImage..."
        flash_erase /dev/mtd1 0 0
        nandwrite -p /dev/mtd1 ${UDIR}/970uimage-C02
    else
        echo "burn zImage..."
        flash_erase /dev/mtd1 0 0
        nandwrite -p /dev/mtd1 ${UDIR}/970uimage-A02
    fi

    echo 200 >/sys/class/leds/heartbeat/delay_on
    echo 200 >/sys/class/leds/heartbeat/delay_off

    if [ -f ${UDIR}/rootfs.ubi ]; then
        echo "burn rootfs partition..."
        ubidetach -m 2
        flash_erase /dev/mtd2 0 0
        ubiformat /dev/mtd2 -f ${UDIR}/rootfs.ubi -s 2048 -O 2048
    fi
    echo 100 >/sys/class/leds/heartbeat/delay_on
    echo 100 >/sys/class/leds/heartbeat/delay_off
    if [ -f ${UDIR}/data.ubi ]; then
        echo "burn data partition..."
        ubidetach -m 3
        flash_erase /dev/mtd3 0 0
        ubiformat /dev/mtd3 -f ${UDIR}/data.ubi -s 2048 -O 2048
    fi
    sync
    sync
    echo default-on >/sys/class/leds/heartbeat/trigger
fi
