# Base this image on rpi-basic-image
include recipes-core/images/rpi-hwup-image.bb
include recipes-core/users_and_security/general-security.bb

LICENSE = "Apache-2.0"

MACHINE = "raspberrypi3"

# Include modules in rootfs
IMAGE_INSTALL += " \
	ldd \
	u-boot-fw-utils \
	mbed-cloud-client \
	logrotate \
	util-linux-agetty \
	util-linux \
	rng-tools \
	e2fsprogs"

