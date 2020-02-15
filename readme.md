# Start a project
cp configs/qemu_arm_versatile_defconfig br2_external/configs/
make BR2_EXTERNAL=br2_external qemu_arm_versatile_defconfig
make menuconfig
