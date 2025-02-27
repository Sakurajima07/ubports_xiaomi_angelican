#!/bin/bash
set -ex

TMPDOWN=$(realpath $1)
KERNEL_OBJ=$(realpath $2)
OUT=$(realpath $3)

HERE=$(pwd)
source "${HERE}/deviceinfo"

kernel_arch="${deviceinfo_kernel_arch:-$deviceinfo_arch}"

case "$kernel_arch" in
    aarch64) ARCH="arm64" ;;
    *) ARCH="$kernel_arch" ;;
esac

if [ -n "$deviceinfo_dtbo" ]; then
    PREFIX=$KERNEL_OBJ/arch/$ARCH/boot/dts/
    DTBO_LIST="$PREFIX${deviceinfo_dtbo// / $PREFIX}"
else
    echo "Please define deviceinfo_dtbo in deviceinfo"
    exit 1
fi

python2 "$TMPDOWN/libufdt/utils/src/mkdtboimg.py" create "$OUT" $DTBO_LIST
