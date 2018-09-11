FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"
SRC_URI_append = " file://init-debug.sh \
                  file://initrd-shutdown.sh \
                  file://partition-and-format.sh "

do_install_append(){
    install -d ${D}/boot
    install -d ${D}/var/lock
    install -d ${D}/mnt/updatepartition
    install -d ${D}/usr/bin
    install -m 0755 ${WORKDIR}/initrd-shutdown.sh ${D}/usr/bin
    install -m 0755 ${WORKDIR}/partition-and-format.sh ${D}/usr/bin
}

FILES_${PN} += " \
    /mnt \
    /mnt/updatepartition \
    /boot \
    /var/lock \
    /run \
    /run/lock \
    /usr/bin/initrd-shutdown.sh \
    /usr/bin/partition-and-format \
    "
