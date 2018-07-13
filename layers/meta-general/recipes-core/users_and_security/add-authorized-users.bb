DESCRIPTION = "Add users, keys and default passwords"
LICENSE = "Apache-2.0"

# Set default passwords, user name etc. if not defined. These can be defined in conf/local.conf.
AUTHORIZED_USER_NAME ?= "pi"
#default group is same than user name. This can used for creating new group.
#AUTHORIZED_USER_GROUP ?= "pi_group" 
AUTHORIZED__USER_HOME_DIR ?= "/home/${AUTHORIZED_USER_NAME}"
AUTHORIZED_USER_PASSWD ?= "AsD443aaPi"

# Patches for quilt goes to files directory
#FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

LIC_FILES_CHKSUM = "file://${TOPDIR}/../LICENSE;md5=4336ad26bb93846e47581adc44c4514d"
#SRC_URI = "file://authorized_keys"

inherit useradd

# You must set USERADD_PACKAGES when you inherit useradd. This
# lists which output packages will include the user/group
# creation code.
USERADD_PACKAGES = "${PN}"

# You must also set USERADD_PARAM and/or GROUPADD_PARAM when
# you inherit useradd.

# USERADD_PARAM specifies command line options to pass to the
# useradd command. Multiple users can be created by separating
# the commands with a semicolon.
USERADD_PARAM_${PN} = "-U -d ${AUTHORIZED__USER_HOME_DIR} -G sudo -r -s /bin/sh -p '$(${bindir}/mkpasswd -m sha-512 ${AUTHORIZED_USER_PASSWD})' ${AUTHORIZED_USER_NAME}"

# GROUPADD_PARAM works the same way, which you set to the options
# you'd normally pass to the groupadd command.
#GROUPADD_PARAM_${PN} = "-g 880 ${AUTHORIZED_USER_GROUP}"


do_install () {
    install -d -m 0755 "${D}${AUTHORIZED__USER_HOME_DIR}"
    install -d -m 0700 "${D}${AUTHORIZED__USER_HOME_DIR}/.ssh"

    # The new users and groups are created before the do_install
    # step, so you are now free to make use of them:
    chown -R ${AUTHORIZED_USER_NAME} "${D}${AUTHORIZED__USER_HOME_DIR}"
    chgrp -R ${AUTHORIZED_USER_NAME} "${D}${AUTHORIZED__USER_HOME_DIR}"
}

FILES_${PN} = "${AUTHORIZED__USER_HOME_DIR} \
               ${AUTHORIZED__USER_HOME_DIR}/.ssh \
               /etc/sudoers.d/0001_${AUTHORIZED_USER_NAME}"

# Prevents do_package failures with:
# debugsources.list: No such file or directory:
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
