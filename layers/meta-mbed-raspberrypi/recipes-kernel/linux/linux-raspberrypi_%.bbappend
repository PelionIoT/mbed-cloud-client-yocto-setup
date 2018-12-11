
INITRAMFS_IMAGE = "rpi-mbed-initramfs"

# CMDLINE for raspberrypi (change the partition number)
CMDLINE = "dwc_otg.lpm_enable=0 console=serial0,115200 root=/dev/mmcblk0p5 rootfstype=ext4 rootwait"

do_install_append() {
    install -d ${D}/usr/src
    install -m 0600 ${WORKDIR}/linux-raspberrypi3-standard-build/arch/arm/boot/${KERNEL_IMAGETYPE} ${D}/usr/src/${KERNEL_IMAGETYPE}
}

FILES_${KERNEL_PACKAGE_NAME}-base += " \
    /usr \
    /usr/src \
    /usr/src/${KERNEL_IMAGETYPE} \
    "
