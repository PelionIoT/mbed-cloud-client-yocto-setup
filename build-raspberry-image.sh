#!/usr/bin/env bash

WORKDIR=$(pwd)

# Use raspberrypi templates
export TEMPLATECONF="${WORKDIR}/configurations/${7}"

source poky/oe-init-build-env "${1}"

if [ -e "${MBED_CLOUD_IDENTITY_CERT_FILE_IMPORT}" ]; then
   sed -i -e "s|.*MBED_CLOUD_IDENTITY_CERT_FILE.*|MBED_CLOUD_IDENTITY_CERT_FILE = \"${MBED_CLOUD_IDENTITY_CERT_FILE_IMPORT}\"|g" conf/local.conf
else
   echo "!!!! PATH FOR CERTIFICATION CREDENTIAL FILE MISSING !!!!!" 
   echo "Please set file with command: export MBED_CLOUD_IDENTITY_CERT_FILE_IMPORT=\"Full path to file here\""
   exit 1
fi

if [ -e "${MBED_UPDATE_RESOURCE_FILE_IMPORT}" ]; then
   sed -i -e "s|.*MBED_UPDATE_RESOURCE_FILE.*|MBED_UPDATE_RESOURCE_FILE = \"${MBED_UPDATE_RESOURCE_FILE_IMPORT}\"|g" conf/local.conf
else
   sed -i -e "s|.*MBED_UPDATE_RESOURCE_FILE.*|MBED_UPDATE_RESOURCE_FILE = \"\"|g" conf/local.conf
fi

# Enable/Disable RESET_STORAGE
if  [ "$6" -eq "1" ]; then
   sed -i -e "s|RESET_STORAGE =.*|RESET_STORAGE = \"1\"|g" conf/local.conf
else
   sed -i -e "s|RESET_STORAGE =.*|RESET_STORAGE = \"0\"|g" conf/local.conf
fi

# Set extra configation file for jenkins
if [ "$2" -eq "1" ]; then
    BITBAKE_EXTRA_CONF_FILE="${WORKDIR}/extra-bitbake.conf"
    if [ -e "${BITBAKE_EXTRA_CONF_FILE}" ]; then
       BITBAKE_EXTRA_CONF="--read ${BITBAKE_EXTRA_CONF_FILE}"
    else
       echo "File ${BITBAKE_EXTRA_CONF_FILE} does not exist !!!!!"
       BITBAKE_EXTRA_CONF=""
       exit 1
    fi
fi

if [ "$5" -eq "1" ]; then
   # Compile only mbed cloud client elf
   echo "Build ${3}."
   bitbake ${BITBAKE_EXTRA_CONF} ${3} -c configure -f
   bitbake ${BITBAKE_EXTRA_CONF} ${3}
else
    echo "Build ${4}."
    # Make sure that cloud client has been rebuild
    # if changed some configuration.
    bitbake ${BITBAKE_EXTRA_CONF} add-authorized-users -c clean
    bitbake ${BITBAKE_EXTRA_CONF} ${3} -c configure -f
    bitbake ${BITBAKE_EXTRA_CONF} ${4}
fi
