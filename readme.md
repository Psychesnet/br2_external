## Start a project

* structure

  ```bash
  +-- board/
  |   +-- <company>/
  |       +-- <boardname>/
  |           +-- linux.config
  |           +-- busybox.config
  |           +-- <other configuration files>
  |           +-- post_build.sh
  |           +-- post_image.sh
  |           +-- rootfs_overlay/ (for BR2_ROOTFS_OVERLAY)
  |           |   +-- etc/
  |           |   +-- <some file>
  |           +-- patches/
  |               +-- foo/
  |               |   +-- <some patch>
  |               +-- libbar/
  |                   +-- <some other patches>
  |
  +-- configs/
  |   +-- <boardname>_defconfig
  |
  +-- package/
  |   +-- <company>/
  |       +-- Config.in (if not using a br2-external tree)
  |       +-- <company>.mk (if not using a br2-external tree)
  |       +-- package1/
  |       |    +-- Config.in
  |       |    +-- package1.mk
  |       +-- package2/
  |           +-- Config.in
  |           +-- package2.mk
  |
  +-- Config.in (For make menuconfig, EX: source "$BR2_EXTERNAL_BAR_42_PATH/package/package1/Config.in")
  +-- external.mk (For makefile logic, EX: include $(sort $(wildcard $(BR2_EXTERNAL_BAR_42_PATH)/package/*/*.mk)))
  +-- external.desc (Each folder can define xxx.desc file to annonce name(you should use upper letter) and desc, then you will have BR2_EXTERNAL_$(NAME)_PATH and BR2_EXTERNAL_$(NAME)_DESC)
  ```

* copy a sample config to your folder 

  ```bash
  cp configs/qemu_arm_versatile_defconfig br2_external/configs/
  ```

* make a default config to .config

  ```bash
  make BR2_EXTERNAL=br2_external qemu_arm_versatile_defconfig
  # or 
  make defconfig BR2_DEFCONFIG=br2_external/configs/qemu_arm_versatile_defconfig
  ```

* change what you need

  ```bash
  make menuconfig
  # for kernel
  make linux-menuconfig
  make linux-update-defconfig
  # for busybox
  make busybox-menuconfig
  make busybox-update-defconfig
  ```

* we should update following variables for our project

  * Following variables are important because we need it when we save package config

  ```bash
  BR2_GLOBAL_PATCH_DIR=$(BR2_EXTERNAL_PROJECT_PATH)/patches/ BR2_ROOTFS_OVERLAY=$(BR2_EXTERNAL_PROJECT_PATH)/board/<boardname>/overlay/ BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE=$(BR2_EXTERNAL_PROJECT_PATH)/board/<boardname>/kernel.config
  BR2_PACKAGE_BUSYBOX_CONFIG=$(BR2_EXTERNAL_PROJECT_PATH)/board/<boardname>/busybox.config
  ```

* we should create overlay rootfs to copy project related items

  ```bash
  BR2_ROOTFS_OVERLAY=board/<company>/<boardname>/rootfs-overlay
  BR2_ROOTFS_POST_BUILD_SCRIPT=board/<company>/<boardname>/post_build.sh
  # if you need to create static devices
  BR2_ROOTFS_STATIC_DEVICE_TABLE=board/<company>/<boardname>/device_table.txt
  # if you need to create something on fakeroot for root user
  BR2_ROOTFS_POST_FAKEROOT_SCRIPT=board/<company>/<boardname>/post_fakeroot.sh
  # custom operations after image have been created
  BR2_ROOTFS_POST_IMAGE_SCRIPT=board/<company>/<boardname>/post_image.sh
  ```

  

* update default config

  ```bash
  make savedefconfig
  # or
  make savedefconfig BR2_DEFCONFIG=<path-to-defconfig>
  ```

* show br2_external path

  ```bash
  make -s printvars VARS="BR2_EXTERNAL"
  ```

## How to create oss report

```bash
make legal-info
```

## How to check availabile variables

```bash
make -s printvars | grep XXX		
```

## Useful Variables

* change DL folder location

  ```bash
  export BR2_DL_DIR=<shared download location>
  ```

* special folder which make clean would not clean it and download it to output/build

  ```bash
  LINUX_OVERRIDE_SRCDIR = /home/bob/linux/
  ```

* For BR2_ROOTFS_POST_BUILD_SCRIPT and BR2_ROOTFS_POST_IMAGE_SCRIPT

  ```bash
  BR2_CONFIG: the path to the Buildroot .config file
  HOST_DIR, STAGING_DIR, TARGET_DIR: see Section 17.5.2
  BUILD_DIR: the directory where packages are extracted and built
  BINARIES_DIR: the place where all binary files (aka images) are stored
  BASE_DIR: the base output directory
  ```

  