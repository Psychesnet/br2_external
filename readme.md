# Start a project
* copy a sample config to your folder 

  ```bash
  cp configs/qemu_arm_versatile_defconfig br2_external/configs/
  ```

* make a default config to .config

  ```bash
  make BR2_EXTERNAL=br2_external qemu_arm_versatile_defconfig
  ```

* change what you need

  ```bash
  make menuconfig
  ```

* update default config

  ```bash
  make savedefconfig
  ```

  

