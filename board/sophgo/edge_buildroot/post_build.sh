#!/bin/sh

BASE_TARGET_DIR="output/target"
tpu_firmware_dir="/mnt/system/usr/lib/libsophon-0.4.9/data"
tpu_lib_dir="/mnt/system/usr/lib/libsophon-0.4.9/lib/tpu_module"
firmware_dir="$BASE_TARGET_DIR/lib/firmware"

echo $tpu_firmware_dir

if [ -f $BASE_TARGET_DIR/$tpu_firmware_dir/bm1688_firmware0_os.bin ]; then
	ln -sf $tpu_firmware_dir/bm1688_firmware0_os.bin $firmware_dir/bm1688_firmware0_os.bin
fi

if [ -f $BASE_TARGET_DIR/$tpu_firmware_dir/bm1688_firmware1_os.bin ]; then
	ln -sf $tpu_firmware_dir/bm1688_firmware1_os.bin $firmware_dir/bm1688_firmware1_os.bin
fi

if [ -f $BASE_TARGET_DIR/$tpu_lib_dir/libbm1688_kernel_module.so ]; then
	ln -sf $tpu_lib_dir/libbm1688_kernel_module.so $firmware_dir/libbm1688_kernel_module.so 
fi
