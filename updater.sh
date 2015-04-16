#define installation location
_B="/usr/local/bin"

if [ `whoami` != "root" ]; then
			echo "You must run the app as root."
			echo "sudo $0"
			exit 0
fi
if ! whiptail --yesno "This updater will remove the prevoius version and update to the newest! Do you agree?" 0 0; then
	echo "User canceled update."
	exit 0
else
	#remove old files
	rm $_B/armsoc.sh
	rm $_B/change_hostname.sh
	rm $_B/config.sh
	rm $_B/extras.sh
	rm $_B/files.txt
	rm $_B/fs_resize.sh
	rm $_B/hdmi.sh
	rm $_B/kernel_update.sh
	rm $_B/mainmenu.sh
	rm $_B/odroid-utility.sh
	rm $_B/xbmc_setup.sh
	rm $_B/xorg_config.sh
	rm $_B/lirc_setup.sh
	rm $_B/odroidc_hdmipass.sh
	rm $_B/pulseaudio_control.sh
	
	#copy new content
	cp -r ./administration $_B
	cp -r ./config $_B
	cp -r ./menu $_B
	cp -r ./multimedia $_B
	cp ./files.txt $_B/files.txt
	cp ./odroid-utility.sh $_B/odroid-utility.sh
	chmod +x $_B/odroid-utility.sh
	clear
	whiptail --msgbox "odroid-utility was updated!" 0 0 0
fi
