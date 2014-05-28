#!/bin/bash

# ODROID Utility v2

# Global defines
_B="/root/odroid-utility"

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

        # install_bootstrap_packages
        
        # update_internals

		# self_update
		
		source $_B/config.sh        
}

install_bootstrap_packages() {

        case "$DISTRO" in
                "ubuntu")
                        apt-get -y install axel build-essential git xz-utils whiptail
                        apt-get -y build-dep xserver-xorg-video-armsoc
                        ;;
				*)
				echo "Shouldn't reach here!"
				exit 0
				;;
		esac
}


# Start the script
initialization
