# Base this image on the basic initramfs provided by yocto
include recipes-bsp/images/initramfs-debug-image.bb

LICENSE = "Apache-2.0"

export IMAGE_BASENAME = "mbed-cloud-client-initramfs"

# Include modules in rootfs
PACKAGE_INSTALL += " \
	u-boot-fw-utils \
	rsync \
	e2fsprogs-mke2fs \
	"
