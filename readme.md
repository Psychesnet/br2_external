## Layout

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

## Useful Variables

* change DL and br2_external folder location

  ```bash
  export BR2_DL_DIR=<shared download location>
  export BR2_EXTERNAL=<br2_external location>
  ```

* special folder which make clean would not clean it and download it to output/build

  ```bash
  LINUX_OVERRIDE_SRCDIR = /home/bob/linux/
  ```

* For BR2_ROOTFS_POST_BUILD_SCRIPT and BR2_ROOTFS_POST_IMAGE_SCRIPT

  ```ini
  BR2_CONFIG: the path to the Buildroot .config file
  HOST_DIR, STAGING_DIR, TARGET_DIR: see Section 17.5.2
  BUILD_DIR: the directory where packages are extracted and built
  BINARIES_DIR: the place where all binary files (aka images) are stored
  BASE_DIR: the base output directory
  ```

## Take notes

1. Configuration

   ```shell
   make menuconfig
   ```

   **The make command will generally perform the following steps:**

   * download source files (as required);
   * configure, build and install the cross-compilation toolchain, or simply import an external toolchain;
   * configure, build and install selected target packages;
   * build a kernel image, if selected;
   * build a bootloader image, if selected;
   * create a root filesystem in selected formats.

2. Folders under output/.

   * **images/** where all the images (kernel image, bootloader and root filesystem images) are stored.
   * **build/** where all the components are built.
   * **host/** contains both the tools built for the host, and the sysroot of the target toolchain.
   * **staging/** is a symlink to the target toolchain sysroot inside host/, which exists for backwards compatibility. This is prefix.
   * **target/** which contains almost the complete root filesystem for the target. The development files (headers, etc.) are not present, the binaries are stripped.

3. Avaiable make commands

   ```shell
   #Display the list of boards with a defconfig:
   $ make list-defconfigs
   # Dumping the internal make variables
   $ make -s printvars
   # a full rebuild is achieved by running:
   $ make clean all
   # download all sources that you previously selected
   $ make source
   # To generate a dependency graph of the full system you have compiled
   # You will find the generated graph in output/graphs/graph-depends.pdf.
   $ make graph-depends
   # Graphing the build duration
   $ make graph-build
   # To generate overall root filesystem size
   $ make graph-size
   # How to create oss file
   $ make legal-info
   # check avaliable
   $ make -s printvars | grep XXX	
   # make pkg-xxx
   $ make <package>-dirclean
   $ make <package>-rebuild
   $ make <package>-reconfigure
   $ make <package>-reinstall
   # build with project1 config
   $ make BR2_EXTERNAL=br2_external project1_defconfig
   # save defconfig at specfic path
   $ make savedefconfig BR2_DEFCONFIG=<path-to-defconfig>
   ```

4. update kernel config

   ```shell
   make linux-menuconfig
   make linux-savedefconfig
   cp kernel/.config chk/baseunit_buildplatform/defconfigs
   cd chk/baseunit_buildplatform/defconfigs
   sh make_linux.config.sh .config linux-duff.config
   ```

5. update busybox config

   ```shell
   make busybox-menuconfig
   make buxybox-update-config
   ```

6. How to add new opensoure

   ```makefile
   # Go to package and create usbtop dir
   # edit Config.in
   config BR2_PACKAGE_USBTOP
           bool "usbtop"
       depends on BR2_PACKAGE_LIBPCAP
       
   # edit usbtop.hash
   sha256 eea7f2fbdcaacbf1097f62f9e4fb50ffd238cec3085b67d384ab0a419274e1da release-1.0.tar.gz
   
   # edit usbtop.mk
   ################################################################################
   #
   # usbtop
   #
   ################################################################################
   
   USBTOP_VERSION = 1.0
   USBTOP_SOURCE = release-$(USBTOP_VERSION).tar.gz
   USBTOP_SITE = https://github.com/aguinet/usbtop/archive
   USBTOP_LICENSE = GPL-2.0
   USBTOP_LICENSE_FILES = COPYING
   USBTOP_INSTALL_STAGING = YES
   USBTOP_INSTALL_TARGET = YES
   USBTOP_DEPENDENCIES = libpcap
   
   $(eval $(cmake-package))
   
   # more mk example
   ################################################################################
   #
   # libfoo
   #
   ################################################################################
   
   LIBFOO_VERSION = 1.0
   LIBFOO_SOURCE = libfoo-$(LIBFOO_VERSION).tar.gz
   LIBFOO_SITE = http://www.foosoftware.org/download
   LIBFOO_INSTALL_STAGING = YES
   LIBFOO_INSTALL_TARGET = NO
   LIBFOO_CONF_OPTS = --disable-shared
   LIBFOO_DEPENDENCIES = libglib2 host-pkgconf
   
   $(eval $(autotools-package))
   ```
