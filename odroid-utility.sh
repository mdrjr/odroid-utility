#!/bin/bash

# ODROID Utility v2

# For debug uncomment
# set -x

# Global defines
_B="/usr/local/bin"

initialization() {

        # check what distro we are runnig.
        _R=`lsb_release -i -s`

        case "$_R" in
                "Ubuntu")
                        export DISTRO="ubuntu"
                        ;;
                *)
                        echo "I couldn't identify your distribution."
                        echo "Please report this error on the forums"
                        echo "http://forum.odroid.com"
                        echo "debug info: "
                        lsb_release -a
                        exit 0
                        ;;
                esac

        # now that we know what we are running, lets grab all the OS Packages that we need.

        install_bootstrap_packages
        
        update_internals

		if [ -f $_B/config.sh ]; then
			source $_B/config.sh
		else
			echo "Error. Couldn't start"
			exit 0
		fi
}

install_bootstrap_packages() {

        case "$DISTRO" in
                "ubuntu")
                        apt-get -y install axel build-essential git xz-utils whiptail unzip wget curl
                        apt-get -y build-dep xserver-xorg-video-armsoc
                        ;;
				*)
				echo "Shouldn't reach here! Please report this on the forums."
				exit 0
				;;
		esac
}

update_internals() {
	echo "Performing scripts updates"
	baseurl="https://raw.githubusercontent.com/mdrjr/odroid-utility/master"
	
	FILES=`curl -s $baseurl/files.txt`
	APP_REV=`curl -s https://api.github.com/repos/mdrjr/odroid-utility/git/refs/heads/master | awk '{ if ($1 == "\"sha\":") { print substr($2, 2, 40) } }'`
	
	for fu in $FILES; do
		echo "Updating: $fu"
		rm -fr $_B/$fu
		curl -s $baseurl/$fu > $_B/$fu
	done
	
	sed s/"_REV=\"1\""/"_REV=\"$APP_REV\""/g $_B/config.sh > $_B/tmpfile
	mv $_B/tmpfile $_B/config.sh
	
	chmod +x $_B/odroid-utility.sh
}

# Start the script
initialization
