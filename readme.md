## Start a project

* structure

  ```txt
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
  
  
  
  /path/to/br2-ext-tree/
  |- external.desc
  |     |name: BAR_42
  |     |desc: Example br2-external tree
  |     `----
  |
  |- Config.in
  |     |source "$BR2_EXTERNAL_BAR_42_PATH/toolchain/toolchain-external-mine/Config.in.options"
  |     |source "$BR2_EXTERNAL_BAR_42_PATH/package/pkg-1/Config.in"
  |     |source "$BR2_EXTERNAL_BAR_42_PATH/package/pkg-2/Config.in"
  |     |source "$BR2_EXTERNAL_BAR_42_PATH/package/my-jpeg/Config.in"
  |     |
  |     |config BAR_42_FLASH_ADDR
  |     |    hex "my-board flash address"
  |     |    default 0x10AD
  |     `----
  |
  |- external.mk
  |     |include $(sort $(wildcard $(BR2_EXTERNAL_BAR_42_PATH)/package/*/*.mk))
  |     |include $(sort $(wildcard $(BR2_EXTERNAL_BAR_42_PATH)/toolchain/*/*.mk))
  |     |
  |     |flash-my-board:
  |     |    $(BR2_EXTERNAL_BAR_42_PATH)/board/my-board/flash-image \
  |     |        --image $(BINARIES_DIR)/image.bin \
  |     |        --address $(BAR_42_FLASH_ADDR)
  |     `----
  |
  |- package/pkg-1/Config.in
  |     |config BR2_PACKAGE_PKG_1
  |     |    bool "pkg-1"
  |     |    help
  |     |      Some help about pkg-1
  |     `----
  |- package/pkg-1/pkg-1.hash
  |- package/pkg-1/pkg-1.mk
  |     |PKG_1_VERSION = 1.2.3
  |     |PKG_1_SITE = /some/where/to/get/pkg-1
  |     |PKG_1_LICENSE = blabla
  |     |
  |     |define PKG_1_INSTALL_INIT_SYSV
  |     |    $(INSTALL) -D -m 0755 $(PKG_1_PKGDIR)/S99my-daemon \
  |     |                          $(TARGET_DIR)/etc/init.d/S99my-daemon
  |     |endef
  |     |
  |     |$(eval $(autotools-package))
  |     `----
  |- package/pkg-1/S99my-daemon
  |
  |- package/pkg-2/Config.in
  |- package/pkg-2/pkg-2.hash
  |- package/pkg-2/pkg-2.mk
  |
  |- provides/jpeg.in
  |     |config BR2_PACKAGE_MY_JPEG
  |     |    bool "my-jpeg"
  |     `----
  |- package/my-jpeg/Config.in
  |     |config BR2_PACKAGE_PROVIDES_JPEG
  |     |    default "my-jpeg" if BR2_PACKAGE_MY_JPEG
  |     `----
  |- package/my-jpeg/my-jpeg.mk
  |     |# This is a normal package .mk file
  |     |MY_JPEG_VERSION = 1.2.3
  |     |MY_JPEG_SITE = https://example.net/some/place
  |     |MY_JPEG_PROVIDES = jpeg
  |     |$(eval $(autotools-package))
  |     `----
  |
  |- provides/toolchains.in
  |     |config BR2_TOOLCHAIN_EXTERNAL_MINE
  |     |    bool "my custom toolchain"
  |     |    depends on BR2_some_arch
  |     |    select BR2_INSTALL_LIBSTDCPP
  |     `----
  |- toolchain/toolchain-external-mine/Config.in.options
  |     |if BR2_TOOLCHAIN_EXTERNAL_MINE
  |     |config BR2_TOOLCHAIN_EXTERNAL_PREFIX
  |     |    default "arch-mine-linux-gnu"
  |     |config BR2_PACKAGE_PROVIDES_TOOLCHAIN_EXTERNAL
  |     |    default "toolchain-external-mine"
  |     |endif
  |     `----
  |- toolchain/toolchain-external-mine/toolchain-external-mine.mk
  |     |TOOLCHAIN_EXTERNAL_MINE_SITE = https://example.net/some/place
  |     |TOOLCHAIN_EXTERNAL_MINE_SOURCE = my-toolchain.tar.gz
  |     |$(eval $(toolchain-external-package))
  |     `----
  |
  |- linux/Config.ext.in
  |     |config BR2_LINUX_KERNEL_EXT_EXAMPLE_DRIVER
  |     |    bool "example-external-driver"
  |     |    help
  |     |      Example external driver
  |     |---
  |- linux/linux-ext-example-driver.mk
  |
  |- configs/my-board_defconfig
  |     |BR2_GLOBAL_PATCH_DIR="$(BR2_EXTERNAL_BAR_42_PATH)/patches/"
  |     |BR2_ROOTFS_OVERLAY="$(BR2_EXTERNAL_BAR_42_PATH)/board/my-board/overlay/"
  |     |BR2_ROOTFS_POST_IMAGE_SCRIPT="$(BR2_EXTERNAL_BAR_42_PATH)/board/my-board/post-image.sh"
  |     |BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="$(BR2_EXTERNAL_BAR_42_PATH)/board/my-board/kernel.config"
  |     `----
  |
  |- patches/linux/0001-some-change.patch
  |- patches/linux/0002-some-other-change.patch
  |- patches/busybox/0001-fix-something.patch
  |
  |- board/my-board/kernel.config
  |- board/my-board/overlay/var/www/index.html
  |- board/my-board/overlay/var/www/my.css
  |- board/my-board/flash-image
  `- board/my-board/post-image.sh
        |#!/bin/sh
        |generate-my-binary-image \
        |    --root ${BINARIES_DIR}/rootfs.tar \
        |    --kernel ${BINARIES_DIR}/zImage \
        |    --dtb ${BINARIES_DIR}/my-board.dtb \
        |    --output ${BINARIES_DIR}/image.bin
        `----
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

  
