#define installation location
_B="/usr/local/bin"

if [ `whoami` != "root" ]; then
			sudo $0 $*
			exit $?
fi

if ! whiptail --yesno "This updater will remove the prevoius version and update to the newest! Do you agree?" 0 0; then
	echo "User canceled update."
	exit 0
else
	old_files=('armsoc.sh' 'change_hostname.sh' 'config.sh' 'config.sh' 'extras.sh' 'files.txt')

	for i in "$(old_files[@])"
	do
		echo i
	done

	#rm $_B/

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
