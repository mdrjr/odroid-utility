#!/bin/bash

fs_resize() { 
	
	AC=$(whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --yesno "Before running this, you must be sure that /dev/mmcblk0p2 is your root partition.
		To do this make sure you are booting the eMMC or the microSD ALONE!.
		
		DO YOU WANT TO CONTINUE?" 0 0 3>&1 1>&2 2>&3)
	
	rets=$?
	if [ $rets -eq 0 ]; then
		do_resize
	elif [ $rets -eq 1 ]; then
		return 0
	fi	
	
	return 0		
}

do_resize() {
	case "$DISTRO" in
		"ubuntu")
			resize_p2 ;;
		"debian")
			resize_p2 ;;
		"ubuntu-server")
			resize_p2 ;;
		*)
			msgbox "FS_RESIZE: Sorry your distro $DISTRO isn't supported yet. Please report on the forums"
			;;
	esac
}

resize_p2() {
	# this takes in consideration /dev/mmcblk0p2 as the rootfs! 
	rsflog=/root/resize-$DATE-log.txt
	echo "Saving the log to $rsflog"
	sleep 4
	
	p2_start=`fdisk -l /dev/mmcblk0 | grep mmcblk0p2 | awk '{print $2}'`
	p2_finish=$((`fdisk -l /dev/mmcblk0 | grep total | grep sectors | awk '{printf $8}'` - 1024))
	
	fdisk /dev/mmcblk0 <<EOF &>> $rsflog
p
d
2
n
p
2
$p2_start
$p2_finish
p
w
EOF

	cat <<\EOF > /etc/init.d/resize2fs_once
#!/bin/sh
### BEGIN INIT INFO
# Provides:          resize2fs_once
# Required-Start:
# Required-Stop: 
# Default-Start: 2 3 4 5 S
# Default-Stop:
# Short-Description: Resize the root filesystem to fill partition
# Description:
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
  start)
    log_daemon_msg "Starting resize2fs_once" &&
    resize2fs /dev/mmcblk0p2 &&
    rm /etc/init.d/resize2fs_once &&
    update-rc.d resize2fs_once remove &&
    log_end_msg $?
    ;;
  *)  
    echo "Usage: $0 start" >&2
    exit 3
    ;;
esac  
EOF

  chmod +x /etc/init.d/resize2fs_once
  update-rc.d resize2fs_once defaults
  REBOOT=1
  
  msgbox "Rootfs Extended. Please reboot to take effect"
  return 0
}
