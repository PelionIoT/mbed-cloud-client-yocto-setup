## Changelog for Pelion Device Management Client reference example application with Yocto

### Release 4.11.2 (01.12.2021)

Updated to Device Management Client 4.11.2.

### Release 4.11.1 (11.10.2021)

Updated to Device Management Client 4.11.1.

### Release 4.11.0 (17.09.2021)

Updated to Device Management Client 4.11.0.

### Release 4.10.0 (07.07.2021)

Updated to Device Management Client 4.10.0.

### Release 4.9.1 (17.06.2021)

Updated to Device Management Client 4.9.1.

### Release 4.9.0 (21.05.2021)

- Updated to Device Management Client 4.9.0.
- Changed the default compilation profile to debug as an a workaround for `FORTIFY_SOURCE` compilation.

### Release 4.8.0 (24.03.2021)

Updated to Device Management Client 4.8.0.

### Release 4.7.1 (28.01.2021)

Updated to Device Management Client 4.7.1.

### Release 4.7.0 (07.12.2020)

- Updated to Device Management Client 4.7.0.
- Support for new update mechanism and scripts.

### Release 4.6.0 (24.08.2020)

Updated to Device Management Client 4.6.0.

### Release 4.5.0 (12.06.2020)

Updated to Device Management Client 4.5.0.

### Release 4.4.0 (17.04.2020)

- Updated to Device Management Client 4.4.0.
-	Updated Yocto to Zeus.
-	Fixed Yocto deployment issues with Mbed tooling.

### Release 4.3.0 (06.02.2020)

- Updated to Device Management Client 4.3.0.
- Cache size for rootfs changed to be dynamic.

## Release 4.2.1 (20.12.2019)

Updated to Device Management Client 4.2.1.

### Release 4.2.0 (18.12.2019)

Updated to Device Management Client 4.2.0.

### Release 4.1.0 (28.11.2019)

Updated to Device Management Client 4.1.0.

### Release 4.0.0 (25.09.2019)

Updated to Device Management Client 4.0.0.

### Release 3.4.0 (28.08.2019)

No changes.

### Release 3.3.0 (19.05.2019)

No changes.

### Release 3.2.0 (12.06.2019)

* Removed the dependency of requiring Mbed CLI to be globally installed. This allows also virtualenv installations of Mbed CLI to work with the provided meta-layers.
  * Changed the meta-layer to use SSH authentication for Mbed CLI when needed. This is mostly needed when pulling in meta-layers from private repositories.
  * Changed the `meta-mbed-cloud-client.lib` file to use `https` format instead of `ssh`.

**Delta update related:**

* Modified application makefiles to call the new script for building a `tar` package of `rootfs`.
* Added the `build-raspberry-update-rootfs-tar.sh` script for building a `tar` package of `rootfs` contents to be used for delta purposes.
* Edited the local configuration sample and `fstab` to set `rootfs` into "read-only" mode so that delta firmware update can be applied into the device.
* Edited the Update client `metalayer recipe` to include the `Prepare` script in the image for delta processing.

### Release 3.1.1 (13.05.2019)

No changes.

### Release 3.1.0 (26.04.2019)

No changes.

### Release 3.0.0 (27.03.2019)

No changes.

### Release 2.2.1 (28.02.2019)

No changes.

### Release 2.2.0 (25.02.2019)

No changes.

### Release 2.1.1 (19.12.2018)

No changes.

### Release 2.1.0 (11.12.2018)

Yocto branch updated from Rocto to Sumo

 <span class="notes">**Note**: The Linux kernel has not been updated to the default Sumo version 4.14. It uses the version 4.9 that is the default for the Rocko branch. This guarantees the software update support from Rocko to Sumo when using Device Management Update.</span>
