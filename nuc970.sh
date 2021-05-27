#!/bin/bash

chmod 600 ${TARGET_DIR}/etc/ssh/ssh_host*
chmod 600 ${TARGET_DIR}/etc/profile
chmod 600 ${TARGET_DIR}/etc/hostname
chmod 744 ${TARGET_DIR}/sbin/blkid


export DATA_UBIFS_FILE=${BASE_DIR}/images/data.ubifs
mkdir -p /tmp/nuc970-data
mkfs.ubifs -F -x lzo -m 2KiB -e 124KiB -c 560 -o ${DATA_UBIFS_FILE} -d /tmp/nuc970-data

sed -e 's@BR2_DATA_UBI_PATH@'"$DATA_UBIFS_FILE"'@' ${BASE_DIR}/../fs/ubi/ubinize_data.cfg >> ${BASE_DIR}/images/ubinize_data.cfg
ubinize -o ${BASE_DIR}/images/data.ubi -m 2KiB -p 128KiB  -s 2048 ${BASE_DIR}/images/ubinize_data.cfg
