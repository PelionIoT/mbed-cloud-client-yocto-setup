DESCRIPTION = "General security recipe."
LICENSE = "Apache-2.0"

# Default password if not defined. These password can be defined in conf/local.conf.
ROOT_PASSWD ?= "AsD443aaRo0t"

# Include openssh modules in rootfs
IMAGE_INSTALL += " \
	packagegroup-core-ssh-openssh \
	openssh-sftp-server \
	add-authorized-users \
	sudo"

CORE_IMAGE_EXTRA_INSTALL += "openssh"

# Set root password
inherit extrausers
EXTRA_USERS_PARAMS += "usermod  -p '$(mkpasswd -m sha-512 ${ROOT_PASSWD})' root;"

create_mnt_dirs() {
   mkdir -p ${IMAGE_ROOTFS}/mnt/flags
   mkdir -p ${IMAGE_ROOTFS}/mnt/config
   mkdir -p ${IMAGE_ROOTFS}/mnt/cache
   mkdir -p ${IMAGE_ROOTFS}/mnt/root
}

ROOTFS_POSTPROCESS_COMMAND += "create_mnt_dirs;"
