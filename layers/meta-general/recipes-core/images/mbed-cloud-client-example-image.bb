# Base this image on mbed-cloud-client-example
include recipes-core/users_and_security/general-security.bb
# Include image recipe for HW configurations
include ${TARGET_HW_IMAGE_RECIPE}

LICENSE = "Apache-2.0"

# Include modules in rootfs
IMAGE_INSTALL += " \
	mbed-cloud-client"

IMAGE_INSTALL_append = "${@'' if FOTA_ENABLE == '1' else ' update-scripts '}"
