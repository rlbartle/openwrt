#!/usr/bin/env bash
#
# Copyright (C) 2013 OpenWrt.org
#               2019 Benedikt-Alexander Mokroß (iCOGNIZE GmbH)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

set -ex
[ $# -eq 4 ] || {
    echo "SYNTAX: $0 <kernel> <dtb image> <page size> <block size>"
    echo "Given: $@"
    exit 1
}

KERNEL="$1"
DTB="$2"
PAGESIZE="$3"
BLOCKSIZE="$4"

LEBSIZE=$(($BLOCKSIZE - (($PAGESIZE / 1024) * 2)))
KERNSIZE=$(stat -c %s "$KERNEL")
DTBSIZE=$(stat -c %s "$DTB")
TOTALSIZE=$(($KERNSIZE + $DTBSIZE))

LEBS=$((($TOTALSIZE / ($LEBSIZE*1024)) + 17))

WORKDIR=$(mktemp -d)

# cp "$KERNEL" "$WORKDIR/uImage"
# cp "$DTB" "$WORKDIR/dtb"
## if wanting to preserve the input files
# cp "$KERNEL" /home/robert/uImage
# cp "$DTB" /home/robert/dtb

# Special axium hack - load 5.10 kernel as the ubi kernel section by hardcoding paths to the image and dtb.
cp /home/robert/Documents/openwrt/21.02-CUSTOM_DIFF/5.10_image/boot/spinand/uImage "$WORKDIR/uImage"
cp /home/robert/Documents/openwrt/21.02-CUSTOM_DIFF/5.10_image/boot/spinand/dtb "$WORKDIR/dtb"

# MKUBIFS=mkfs.ubifs
MKUBIFS=/home/robert/Documents/openwrt/openwrt-master/staging_dir/host/bin/mkfs.ubifs

# printf "%s -o %s -F -m %u -e %uKiB -c %u -U -v -r <WORKDIR>\n" "$MKUBIFS" "$KERNEL.new" $PAGESIZE $LEBSIZE $LEBS >> /home/robert/image.out

$MKUBIFS -o "$KERNEL.new" -F -m $PAGESIZE -e ${LEBSIZE}KiB -c $LEBS -U -v -r $WORKDIR

rm "$KERNEL"
mv "$KERNEL.new" "$KERNEL"
rm -rf $WORKDIR
