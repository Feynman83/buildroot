#!/bin/sh

ROOT=$(dmesg | grep root= | cut -d" " -f6 | cut -d"=" -f2)

if [ $ROOT == "ubi0:rootfs" ]; then
    echo "recovery require system run in u disk"
    return 0
fi
