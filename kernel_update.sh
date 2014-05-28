#!/bin/bash

# Kernel update constants.
KTMP="/tmp/kupdate"

# Boot.Scr's
BOOT_SCR_UBUNTU="http://builder.mdrjr.net/tools/boot.scr_ubuntu.tar"
BOOT_SCR_UBUNTU_XU="http://builder.mdrjr.net/tools/boot.scr_ubuntu_xu.tar"
BOOT_SCR_OpenSUSE="http://builder.mdrjr.net/tools/boot.scr_opensuse.tar"
BOOT_SCR_FEDORA19="http://builder.mdrjr.net/tools/boot.scr_fedora19.tar"
BOOT_SCR_FEDORA19_XU="http://builder.mdrjr.net/tools/boot.scr_fedora19_xu.tar"
BOOT_SCR_FEDORA20="http://builder.mdrjr.net/tools/boot.scr_fedora20.tar"
BOOT_SCR_FEDORA20_XU="http://builder.mdrjr.net/tools/boot.scr_fedora20_xu.tar"

# Firmware
FIRMWARE_URL="http://builder.mdrjr.net/tools/firmware.tar.xz"

# Kernel builds
export K_PKG_URL="http://builder.mdrjr.net/kernel-3.8/$KERNEL_RELEASE"
export XU_K_PKG_URL="http://builder.mdrjr.net/kernel-3.4/$KERNEL_RELEASE"


kernel_update() {
	while true; do
		KO=$(whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --menu "Kernel Update/Configuration" 0 0 0 \
		"1" "Update Kernel" \
		"2" "Install firmware files to /lib/firmware" \
		"3" "Update boot.scr's" \
		"4" "Update udev rules for ODROID subdevices (mali, cec..)" \
		"5" "Update the bootloader" \
		"6" "Exit" \
		3>&1 1>&2 2>&3)
	
		KR=$?
	
		if [ $KR -eq 1 ]; then
			return 0
		else
			case "$KO" in 
				"1") do_kernel_update ;;
				"2") do_firmware_update ;;
				"3") do_bootscript_update ;;
				"4") do_udev_update ;;
				"5") do_bootloader_update ;;
				"6") return 0 ;;
				*) msgbox "KERNEL-UPDATE: Error. You shouldn't be here. Value $KO please report this on the forums" ;;
			esac
		fi
	
	done

	return 0

}

do_kernel_update() {
	# STUB
}

do_firmware_update() {
	# STUB
}

do_bootscript_update() {
	# STUB
}

do_udev_update() {
	# STUB
}

do_bootloader_update() {
	# STUB
}
