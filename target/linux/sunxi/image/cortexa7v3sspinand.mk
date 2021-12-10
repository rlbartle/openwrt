
define Device/licheepi-zero-spinand
  DEVICE_VENDOR := LicheePi
  DEVICE_MODEL := Zero (SPI-NAND)
  DEVICE_PACKAGES:=kmod-rtl8723bs rtl8723bs-firmware
  SOC := sun8i-v3s
  SUPPORTED_DEVICES:=licheepi,licheepi-zero
#   SUNXI_DTS:=sun8i-v3s-licheepi-zero-spinand

  KERNEL := kernel-bin | lzma | uImage lzma | sunxi-kernelubifs
  IMAGES := ubispinand.img.gz

  MKUBIFS_OPTS := -F -m $(CONFIG_SUNXI_SPINAND_PAGESIZE) -e $(shell echo $$(($(CONFIG_SUNXI_SPINAND_BLOCKSIZE) - (($(CONFIG_SUNXI_SPINAND_PAGESIZE)/1024)*2))))KiB -c 880 -U
  UBINIZE_OPTS := -vv

  BLOCKSIZE := $(CONFIG_SUNXI_SPINAND_BLOCKSIZE)KiB
  PAGESIZE := $(CONFIG_SUNXI_SPINAND_PAGESIZE)
  SUBPAGESIZE := $(CONFIG_SUNXI_SPINAND_PAGESIZE)
  VID_HDR_OFFSET := $(CONFIG_SUNXI_SPINAND_PAGESIZE)
  IMAGE_SIZE := $(CONFIG_TARGET_ROOTFS_PARTSIZE)m
  KERNEL_IN_UBI := 1
  UBOOTENV_IN_UBI := 1
  # UBINIZE_PARTS := dtb=$(DTS_DIR)/$$(SUNXI_DTS).dtb=1
  IMAGE/ubispinand.img.gz := \
      sunxi-spinandboot | \
      pad-to $$(CONFIG_SUN8I_V3S_OFFSET_UBI) | \
      append-ubi | \
      gzip
endef
TARGET_DEVICES += licheepi-zero-spinand
