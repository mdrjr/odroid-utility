#!/bin/bash

# Kernel update constants.
KTMP="/tmp/kupdate"

# Boot.Scr's
BOOT_SCR_UBUNTU="http://builder.mdrjr.net/tools/boot.scr_ubuntu.tar"
BOOT_SCR_UBUNTU_XU="http://builder.mdrjr.net/tools/boot.scr_ubuntu_xu.tar"
BOOT_SCR_FEDORA20="http://builder.mdrjr.net/tools/boot.scr_fedora20.tar"
BOOT_SCR_FEDORA20_XU="http://builder.mdrjr.net/tools/boot.scr_fedora20_xu.tar"
BOOT_SCR_UBUNTU_XU3="http://builder.mdrjr.net/tools/odroidxu3.boot.ini"

# Firmware
FIRMWARE_URL="http://builder.mdrjr.net/tools/firmware.tar.xz"

# Kernel builds
export K_PKG_URL="http://builder.mdrjr.net/kernel-3.8/00-LATEST"
export XU_K_PKG_URL="http://builder.mdrjr.net/kernel-3.4/00-LATEST"
export XU3_K_PKG_URL="http://builder.mdrjr.net/kernel-3.10/00-LATEST"


kernel_update() {
	
	get_board
	
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
				"6") break;;
				*) msgbox "KERNEL-UPDATE: Error. You shouldn't be here. Value $KO please report this on the forums" ;;
			esac
		fi
	
	done
}

do_kernel_download() {
	rm -fr $KTMP
	mkdir -p $KTMP
	cd $KTMP
	
	if [ "$BOARD" = "odroidxu" ]; then
		dlf_fast $XU_K_PKG_URL/$BOARD.tar.xz "Downloading ODROID-XU Kernel. Please wait." $KTMP/$BOARD.tar.xz
		dlf_fast $XU_K_PKG_URL/$BOARD.tar.xz.md5sum "Downloading ODROID-XU Kernel MD5SUM. Please wait." $KTMP/$BOARD.tar.xz.md5sum
	elif [ "$BOARD" = "odroidxu3" ]; then
		dlf_fast $XU3_K_PKG_URL/$BOARD.tar.xz "Downloading ODROID-XU3 Kernel. Please wait." $KTMP/$BOARD.tar.xz
		dlf_fast $XU3_K_PKG_URL/$BOARD.tar.xz.md5sum "Downloading ODROID-XU3 Kernel MD5SUM. Please wait." $KTMP/$BOARD.tar.xz.md5sum
	else
		dlf_fast $K_PKG_URL/$BOARD.tar.xz "Downloading $BOARD Kernel. Please Wait." $KTMP/$BOARD.tar.xz
		dlf_fast $K_PKG_URL/$BOARD.tar.xz.md5sum "Downloading $BOARD Kernel MD5SUM. Please Wait." $KTMP/$BOARD.tar.xz.md5sum
	fi
	
	VALID=`cat $KTMP/$BOARD.tar.xz.md5sum | awk '{printf $1}'`
	CURRENT=`md5sum $KTMP/$BOARD.tar.xz | awk '{printf $1}'`
	if [ "$VALID" != "$CURRENT" ]; then
		msgbox "There was a issue downloading the kernel. Application will exit."
		exit
	fi
}

do_kernel_update() {
	do_kernel_download
	
	case "$DISTRO" in 
		"ubuntu")
			do_ubuntu_kernel_update ;;
		"debian")
			do_debian_kernel_update ;;
		*) msgbox "KERNEL-UPDATE: Distro not found. Shouldn't be here. Please report on the forums" ;;
	esac
}

do_firmware_update() {
	rm -rf $KTMP
	mkdir -p $KTMP
	cd $KTMP
	dlf_fast $FIRMWARE_URL "Downloading Linux Firmware files (/lib/firmware)" $KTMP/firmware.tar.xz
	echo "Updating the firmware"
	xz -d firmware.tar.xz
	(cd /lib/firmware && tar xf $KTMP/firmware.tar)
	msgbox "KERNEL-UPDATE: Done. Firmware updated"
	rm -fr $KTMP
	
}

do_bootscript_update() {

	rm -fr $KTMP
	mkdir -p $KTMP
	cd $KTMP

	case "$DISTRO" in
		"ubuntu")
			if [ "$BOARD" = "odroidxu" ]; then
				dlf $BOOT_SCR_UBUNTU_XU "Download boot.ini for ODROID-XU" $KTMP/bscrxu.tar
				tar xf bscrxu.tar
				cp $KTMP/xu/* /media/boot
			elif [ "$BOARD" = "odroidx2" ] || [ "$BOARD" = "odroidu2" ]; then
				dlf $BOOT_SCR_UBUNTU "Downloading boot.scr's for $BOARD" $KTMP/prime.tar
				tar xf prime.tar
				cp $KTMP/x2u2/*.scr /media/boot
			elif [ "$BOARD" = "odroidx" ]; then
				dlf $BOOT_SCR_UBUNTU "Downloading boot.scr's for ODROID-X" $KTMP/reg.tar
				tar xf reg.tar
				cp $KTMP/x/*.scr /media/boot
			elif [ "$BOARD" = "odroidxu3" ]; then
				dlf $BOOT_SCR_UBUNTU_XU3 "Updating boot.ini for ODROID-XU3" /media/boot/boot.ini
			fi
			;;
		"debian")
			if [ "$BOARD" = "odroidxu" ]; then
				dlf $BOOT_SCR_UBUNTU_XU "Download boot.ini for ODROID-XU" $KTMP/bscrxu.tar
				tar xf bscrxu.tar
				cp $KTMP/xu/* /boot
			elif [ "$BOARD" = "odroidx2" ] || [ "$BOARD" = "odroidu2" ]; then
				dlf $BOOT_SCR_UBUNTU "Downloading boot.scr's for $BOARD" $KTMP/prime.tar
				tar xf prime.tar
				cp $KTMP/x2u2/*.scr /boot
			elif [ "$BOARD" = "odroidx" ]; then
				dlf $BOOT_SCR_UBUNTU "Downloading boot.scr's for ODROID-X" $KTMP/reg.tar
				tar xf reg.tar
				cp $KTMP/x/*.scr /boot
			elif [ "$BOARD" = "odroidxu3" ]; then
				dlf $BOOT_SCR_UBUNTU_XU3 "Updating boot.ini for ODROID-XU3" /media/boot/boot.ini
			fi
			;;
		*)
		msgbox "KERNEL-UPDATE: bootscript: Distro not supported"
		;;
	esac
	
	msgbox "KERNEL-UPDATE: boostscript: Boot scripts updated"
}

do_udev_update() {

	if [ "$DISTRO" = "ubuntu" ] || [ "$DISTRO" = "debian" ]; then
		echo "KERNEL==\"mali\",SUBSYSTEM==\"misc\",MODE=\"0777\"" > /etc/udev/rules.d/10-odroid.rules
		echo "KERNEL==\"mali0\",SUBSYSTEM==\"misc\",MODE=\"0777\"" >> /etc/udev/rules.d/10-odroid.rules
		echo "KERNEL==\"ump\",SUBSYSTEM==\"ump\",MODE=\"0777\"" >> /etc/udev/rules.d/10-odroid.rules
		echo "KERNEL==\"ttySAC0\", SYMLINK+=\"ttyACM99\"" >> /etc/udev/rules.d/10-odroid.rules
		echo "KERNEL==\"event*\", SUBSYSTEM==\"input\", MODE=\"0777\"" >> /etc/udev/rules.d/10-odroid.rules
		echo "KERNEL==\"CEC\", MODE=\"0777\"" >> /etc/udev/rules.d/10-odroid.rules
	fi
	
	msgbox "KERNEL-UPDATE: UDEV: udev rules for ODROID Installed"

}

do_bootloader_update() {
	# This part is heavily based on this: 
	#  https://github.com/hardkernel/u-boot/blob/odroid-v2010.12/sd_fuse/sd_fusing.sh

	device=/dev/mmcblk0
	D="SDCard"

	if [ -f /sys/block/mmcblk0boot0/force_ro ]; then
		emmc=1
		D="eMMC"
		device=/dev/mmcblk0boot0
		if ! echo 0 > /sys/block/mmcblk0boot0/force_ro; then
			msgbox "I've found a running eMMC but I couldn't get it to accept the new bootloaders."
			return
		fi
	fi
	
	if [ -n "$emmc" ]; then
		# Going eMMC Mode
		if [ "$BOARD" = "odroidx" ] || [ "$BOARD" = "odroidx2" ] || [ "$BOARD" = "odroidu2" ]; then
			# 4412 eMMC Positions
			signed_bl1_position=0
			bl2_position=30
			uboot_position=62
			tzsw_position=2110
		elif [ "$BOARD" = "odroidxu3" ]; then
			# 5422 eMMC Positions
			signed_bl1_position=0
			bl2_position=30
			uboot_position=62
			tzsw_position=718
		fi
	else
		if [ "$BOARD" = "odroidx" ] || [ "$BOARD" = "odroidx2" ] || [ "$BOARD" = "odroidu2" ]; then
			# 4412 SD Positions
			signed_bl1_position=1
			bl2_position=31
			uboot_position=63
			tzsw_position=2111
		elif [ "$BOARD" = "odroidxu3" ]; then
			# 5422 SD Positions
			signed_bl1_position=1
			bl2_position=31
			uboot_position=63
			tzsw_position=719
		else
			msgbox "Your board isn't supported"
		fi
	fi

	
	BLTEMP=/tmp/blTemp
	rm -fr $BLTEMP
	mkdir $BLTEMP
	
	
	if ! whiptail --yesno "I found that you booted from a $D. If that's correct say Yes and I'll download and update your bootloaders. Otherwise please say NO" 0 0; then
		msgbox "Understood! Aborting!"
		return
	fi
	
	if [ "$BOARD" = "odroidxu3" ]; then
		# 5422 Update
		# bl1
		echo "*** Downloading Bootloaders for ODROID-XU3"
		if ! curl -s https://raw.githubusercontent.com/hardkernel/u-boot/odroidxu3-v2012.07/sd_fuse/hardkernel/bl1.bin.hardkernel > $BLTEMP/bl1.bin; then
			msgbox "Something wrong with the Download. Will now quit"
			break
		fi
		# bl2
		if ! curl -s https://raw.githubusercontent.com/hardkernel/u-boot/odroidxu3-v2012.07/sd_fuse/hardkernel/bl2.bin.hardkernel > $BLTEMP/bl2.bin; then
			msgbox "Something wrong with the Download. Will now quit"
			break
		fi
		# u-boot
		if ! curl -s https://raw.githubusercontent.com/hardkernel/u-boot/odroidxu3-v2012.07/sd_fuse/hardkernel/u-boot.bin.hardkernel > $BLTEMP/uboot.bin; then
			msgbox "Something wrong with the Download. Will now quit"
			break
		fi
		#tzsw
		if ! curl -s https://raw.githubusercontent.com/hardkernel/u-boot/odroidxu3-v2012.07/sd_fuse/hardkernel/tzsw.bin.hardkernel > $BLTEMP/tzsw.bin; then
			msgbox "Something wrong with the Download. Will now quit"
			break
		fi
	elif [ "$BOARD" = "odroidx" ] || [ "$BOARD" = "odroidx2" ] || [ "$BOARD" = "odroidu2" ]; then
		# 4412 Update
		# bl1
		echo "*** Downloading Bootloaders for ODROID-X/X2/U2/U3"
		if ! curl -s https://raw.githubusercontent.com/hardkernel/u-boot/odroid-v2010.12/sd_fuse/bl1.HardKernel > $BLTEMP/bl1.bin; then
			msgbox "Something wrong with the Download. Will now quit"
			break
		fi
		# bl2
		if ! curl -s https://raw.githubusercontent.com/hardkernel/u-boot/odroid-v2010.12/sd_fuse/bl2.HardKernel > $BLTEMP/bl2.bin; then
			msgbox "Something wrong with the Download. Will now quit"
			break
		fi
		# u-boot
		if ! curl -s https://raw.githubusercontent.com/hardkernel/u-boot/odroid-v2010.12/sd_fuse/u-boot.bin.HardKernel > $BLTEMP/uboot.bin; then
			msgbox "Something wrong with the Download. Will now quit"
			break
		fi
		#tzsw
		if ! curl -s https://raw.githubusercontent.com/hardkernel/u-boot/odroid-v2010.12/sd_fuse/tzsw.HardKernel > $BLTEMP/tzsw.bin; then
			msgbox "Something wrong with the Download. Will now quit"
			break
		fi
	else
		msgbox "Your board: $BOARD isn't supported yet"
		return
	fi

	echo "*** Updating bl1"
	dd iflag=dsync oflag=dsync if=$BLTEMP/bl1.bin of=$device seek=$signed_bl1_position
	echo "*** Updating bl2"
	dd iflag=dsync oflag=dsync if=$BLTEMP/bl2.bin of=$device seek=$bl2_position
	echo "*** Updating U-Boot" 
	dd iflag=dsync oflag=dsync if=$BLTEMP/uboot.bin of=$device seek=$uboot_position
	echo "*** Update tzsw" 
	dd iflag=dsync oflag=dsync if=$BLTEMP/tzsw.bin of=$device seek=$tzsw_position
	
	msgbox "Bootloader Update complete"
	
}

do_ubuntu_kernel_update() { 
	cd $KTMP
	
	echo "*** Installing new kernel. Please wait. A backup and log will be saved on /root"
	export klog=/root/kernel_update-log-$DATE.txt
	
	tar -Jcf /root/kernel-backup-$DATE.tar.xz /lib/modules /media/boot &>> $klog
	xz -d $BOARD.tar.xz &>> $klog
	tar xf $BOARD.tar &>> $klog
	
	rm -fr /media/boot/exynos5422-odroidxu3.dtb /media/boot/zImage* /media/boot/uImage* /media/boot/uInitrd* /lib/modules/3.8.13* /lib/modules/3.4* &>> $klog
	
	cp -aRP boot/zImage /media/boot/zImage &>> $klog
	if [ "$BOARD" = "odroidxu3" ]; then
		cp -aRP boot/exynos5422-odroidxu3.dtb /media/boot/exynos5422-odroidxu3.dtb &>> $klog
	fi
	cp -aRP lib/modules/* /lib/modules &>> $klog
	
	if [ -f /etc/initramfs-tools/initramfs.conf ]; then
		cat /etc/initramfs-tools/initramfs.conf | sed s/"MODULES=most"/"MODULES=dep"/g > /tmp/a.conf
		mv /tmp/a.conf /etc/initramfs-tools/initramfs.conf
	fi

    export K_VERSION=`ls $KTMP/boot/config-* | sed s/"-"/" "/g | awk '{printf $2}'`
    cp $KTMP/boot/config-* /boot
    update-initramfs -c -k $K_VERSION &>> $klog
    mkimage -A arm -O linux -T ramdisk -C none -a 0 -e 0 -n "uInitrd $K_VERSION" -d /boot/initrd.img-$K_VERSION /boot/uInitrd-$K_VERSION &>> $klog
    cp /boot/uInitrd-$K_VERSION /media/boot/uInitrd 
    
    if [ "$BOARD" = "odroidxu" ]; then
		axel -o $KTMP/hwc.tar -n 2 -q http://builder.mdrjr.net/tools/xubuntu_hwcomposer.tar &>> $klog
		(cd /usr && tar xf $KTMP/hwc.tar) &>> $klog
	fi

	if [ -f /etc/initramfs/post-update.d/flash-kernel ]; then
		echo "exit 0" > /etc/initramfs/post-update.d/flash-kernel
		chmod +x /etc/initramfs/post-update.d/flash-kernel
	fi
	
	if [ "$BOARD" != "odroidxu" ]; then
		update_hwclock
	fi

	if [ "$BOARD" = "odroidx" ] || [ "$BOARD" = "odroidx2" ]; then
		cp $KTMP/boot/zImage.lcdkit /media/boot
	fi
	
	msgbox "KERNEL-UPDATE: Done. Your kernel should be updated now.
	Check /root for the backup and log files.
	BACKUP: /root/kernel-backup-$DATE.tar.xz
	LOG: $klog"
	
	rm -fr $KTMP
}

do_debian_kernel_update() { 
	cd $KTMP
	
	echo "*** Installing new kernel. Please way. A backup and log will be saved on /root"
	export klog=/root/kernel_update-log-$DATE.txt
	
	tar -Jcf /root/kernel-backup-$DATE.tar.xz /lib/modules /boot &>> $klog
	xz -d $BOARD.tar.xz &>> $klog
	tar xf $BOARD.tar &>> $klog
	
	rm -fr /boot/exynos5422-odroidxu3.dtb /boot/zImage* /boot/uImage* /boot/uInitrd* /lib/modules/3.8.13* /lib/modules/3.4* &>> $klog
	
	cp -aRP boot/zImage /boot/zImage &>> $klog
	if [ "$BOARD" = "odroidxu3" ]; then
		cp -aRP boot/exynos5422-odroidxu3.dtb /boot/exynos5422-odroidxu3.dtb &>> $klog
	fi
	cp -aRP lib/modules/* /lib/modules &>> $klog
	
	if [ -f /etc/initramfs-tools/initramfs.conf ]; then
		cat /etc/initramfs-tools/initramfs.conf | sed s/"MODULES=most"/"MODULES=dep"/g > /tmp/a.conf
		mv /tmp/a.conf /etc/initramfs-tools/initramfs.conf
	fi

    export K_VERSION=`ls $KTMP/boot/config-* | sed s/"-"/" "/g | awk '{printf $2}'`
    cp $KTMP/boot/config-* /boot
    update-initramfs -c -k $K_VERSION &>> $klog
    mkimage -A arm -O linux -T ramdisk -C none -a 0 -e 0 -n "uInitrd $K_VERSION" -d /boot/initrd.img-$K_VERSION /boot/uInitrd-$K_VERSION &>> $klog
    cp /boot/uInitrd-$K_VERSION /boot/uInitrd 
    
    if [ "$BOARD" = "odroidxu" ]; then
		axel -o $KTMP/hwc.tar -n 2 -q http://builder.mdrjr.net/tools/xubuntu_hwcomposer.tar &>> $klog
		(cd /usr && tar xf $KTMP/hwc.tar) &>> $klog
	fi
	
	if [ "$BOARD" != "odroidxu" ]; then
		update_hwclock
	fi

	if [ "$BOARD" = "odroidx" ] || [ "$BOARD" = "odroidx2" ]; then
		cp $KTMP/boot/zImage.lcdkit /boot
	fi
	
	msgbox "KERNEL-UPDATE: Done. Your kernel should be updated now.
	Check /root for the backup and log files.
	BACKUP: /root/kernel-backup-$DATE.tar.xz
	LOG: $klog"
	
	rm -fr $KTMP
}

update_hwclock() {
        mv /sbin/hwclock /sbin/hwclock.orig
        axel -o /sbin/hwclock -q http://builder.mdrjr.net/tools/hwclock &>> $klog
        chmod 0755 /sbin/hwclock
}

install_headers() { 
        rm -rf /usr/src/linux-* 
        mv $KTMP/usr/src/linux* /usr/src
        rm -fr /lib/modules/$K_VERSION/build
        ln -s /usr/src/linux-$K_VERSION /lib/modules/$K_VERSION/build
}
