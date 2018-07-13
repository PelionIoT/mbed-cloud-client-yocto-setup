DESCRIPTION="mbed-cloud-client-example"

TOOLCHAIN = "POKY-GLIBC"
LICENSE = "Apache-2.0"
LICENSE_MD5SUM = "4336ad26bb93846e47581adc44c4514d"
SOURCE_REPOSITORY = "git://git@github.com/ARMmbed/mbed-cloud-client-example.git"
SOURCE_BRANCH = "master"
SRCREV = "33d1f5628bc62d63fba981dc76bcb9a1f4a80a7d"
APP_NAME = "mbed-cloud-client-example"
SCRIPT_DIR = "${WORKDIR}/git/${APP_NAME}/mbed-cloud-client/update-client-hub/modules/pal-linux/scripts"

LIC_FILES_CHKSUM = "file://${WORKDIR}/git/${APP_NAME}/mbed-cloud-client/LICENSE;md5=${LICENSE_MD5SUM}"

# Patches for quilt goes to files directory
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = "${SOURCE_REPOSITORY};branch=${SOURCE_BRANCH};protocol=ssh;name=${APP_NAME};destsuffix=git/${APP_NAME}; \
    file://yocto-toolchain.cmake \
    file://CloudClientExample.sh"

DEPENDS = " glibc"
RDEPENDS_${PN} = " libstdc++ libgcc"

# Installed packages
PACKAGES = "${PN}-dbg ${PN}"
FILES_${PN} += "/opt \
                /opt/arm \
                /opt/arm/mbedCloudClientExample.elf \
                /opt/arm/activate_script"
FILES_${PN}-dbg += "/opt/arm/.debug \
                    /usr/src/debug/mbed-cloud-client"

TARGET = "Yocto_Generic_YoctoLinux_mbedtls"

# Allowed [Debug|Release]
RELEASE_TYPE="Debug"

inherit cmake

do_setup_pal_env() {
    echo "Setup pal env"
    CUR_DIR=$(pwd)
    cd "${WORKDIR}/git/${APP_NAME}"
    # Clean the old build directory
    rm -rf "__${TARGET}"
    mbed deploy --protocol ssh
    SSH_AUTH_SOCK=${SSH_AUTH_SOCK} python ./pal-platform/pal-platform.py -v deploy --target="${TARGET}" generate
    cd ${CUR_DIR}
}

addtask setup_pal_env after do_unpack before do_patch

do_configure() {
    CUR_DIR=$(pwd)
    cd "${WORKDIR}/git/${APP_NAME}/__${TARGET}"

    if [ -e "${MBED_CLOUD_IDENTITY_CERT_FILE}" ]; then
        cp ${MBED_CLOUD_IDENTITY_CERT_FILE} "${WORKDIR}/git/${APP_NAME}/mbed_cloud_dev_credentials.c"
    else
        # Not set.
        echo "ERROR certification file does not set !!!"
        exit 1
    fi

    if [ -e "${MBED_UPDATE_RESOURCE_FILE}" ]; then
        cp ${MBED_UPDATE_RESOURCE_FILE} "${WORKDIR}/git/${APP_NAME}/update_default_resources.c"
    fi

    cp "${WORKDIR}/yocto-toolchain.cmake" "${WORKDIR}/git/${APP_NAME}/pal-platform/Toolchain/${TOOLCHAIN}"

    # Set cmake extra defines
    EXTRA_DEFINES=""
    if [ "${RESET_STORAGE}" = "1" ]; then
        echo "Define RESET_STORAGE for cmake."
        EXTRA_DEFINES="-DRESET_STORAGE=ON"
    fi

    YOCTO_DIR=${TOPDIR} cmake -G "Unix Makefiles" ${EXTRA_DEFINES} -DCMAKE_BUILD_TYPE="${RELEASE_TYPE}" -DCMAKE_TOOLCHAIN_FILE="./../pal-platform/Toolchain/${TOOLCHAIN}/${TOOLCHAIN}.cmake" -DEXTARNAL_DEFINE_FILE="./../define-rpi3-yocto.txt"
    cd ${CUR_DIR}
}

do_compile() {
    CUR_DIR=$(pwd)
    cd "${WORKDIR}/git/${APP_NAME}/__${TARGET}"
    make mbedCloudClientExample.elf
    cd ${CUR_DIR}
}

do_install() {
    install -d "${D}/opt/arm"
    install "${WORKDIR}/git/${APP_NAME}/__${TARGET}/${RELEASE_TYPE}/mbedCloudClientExample.elf" "${D}/opt/arm"
    install -m 755 "${SCRIPT_DIR}/arm_update_cmdline.sh"                  "${D}/opt/arm"
    install -m 755 "${SCRIPT_DIR}/yocto_rpi/arm_update_activate.sh"       "${D}/opt/arm"
    install -m 755 "${SCRIPT_DIR}/yocto_rpi/arm_update_active_details.sh" "${D}/opt/arm"

    install -d "${D}${sysconfdir}/init.d"
    install "${WORKDIR}/CloudClientExample.sh" "${D}${sysconfdir}/init.d"
}

INITSCRIPT_PACKAGES = "${PN}"
INITSCRIPT_NAME = "CloudClientExample.sh"
INITSCRIPT_PARAMS = "defaults 99"

inherit update-rc.d
