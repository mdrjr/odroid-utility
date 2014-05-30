#!/bin/bash

rebuild_armsoc() { 
	if [ "$DISTRO" = "ubuntu" ] || [ "$BOARD" != "odroidxu" ]; then
		armsoc_rebuild_ubuntu
	elif [ "$DISTRO" = "debian" ] || [ "$BOARD" != "odroidxu" ]; then
		armsoc_rebuild_debian
	else
		armsoc_err_not_supportted
	fi
}

armsoc_rebuild_ubuntu() { 
	root=/tmp/armsoc-update
	buildlog=/root/armsoc-update-$DATE.txt
	
	mkdir -p $root
	cd $root
	
	# Download the blobs
	dlf builder.mdrjr.net/tools/mali-r4p0.txz "Downloading Mali Binaries" $root/mali-r4p0.tar.xz
	
	# Download armsoc DDX from github
	dlf https://github.com/mdrjr/xf86-video-armsoc/archive/r4p0.zip "Downloading ARMSOC DDX Sources from Github" $root/ddx.zip
	
	echo "Building Mali DDX and Installing Binaries. Please wait"
	echo "Saving build logs to $buildlog"
	
	# Unpack
	xz -d mali-r4p0.tar.xz &>> $buildlog
	tar xf mali-r4p0.tar &>> $buildlog
	unzip -qq ddx.zip &>> $buildlog
	
	# Build DDX
	cd xf86-video-armsoc-r4p0
	./autogen.sh --with-drmmode=exynos --prefix=/usr &>> $buildlog
	make -j4 &>> $buildlog
	make install &>> $buildlog
	
	cd ..
	
	# Install new Binaries
	cd mali
	cp -aRP lib* /usr/lib
	ldconfig
	cp config/xorg.conf /etc/X11/xorg.conf
	
	cd /tmp && rm -fr $root
	sync
	
	msgbox "Mali is now updated. If something fails or isn't working report on the forums with the following file: $buildlog"
}	

armsoc_rebuild_debian() { 
	root=/tmp/armsoc-update
	buildlog=/root/armsoc-update-$DATE.txt
	
	mkdir -p $root
	cd $root
	
	echo "Debian requires some extra packages to build. We are installing it.. Please wait."
	
	# debian requires some extra packages to build the DDX. So.. lets install it
	apt-get -y build-dep xserver-xorg-video-modesetting xserver-xorg-video-nouveau &>> $buildlog
	apt-get -y install build-essential git xz-utils xserver-xorg-dev libudev-dev &>> $buildlog
	
	# Download the blobs
	dlf builder.mdrjr.net/tools/mali-r4p0.txz "Downloading Mali Binaries" $root/mali-r4p0.tar.xz
	
	# Download armsoc DDX from github
	dlf https://github.com/mdrjr/xf86-video-armsoc/archive/r4p0.zip "Downloading ARMSOC DDX Sources from Github" $root/ddx.zip
	
	echo "Building Mali DDX and Installing Binaries. Please wait"
	echo "Saving build logs to $buildlog"
	
	# Unpack
	xz -d mali-r4p0.tar.xz &>> $buildlog
	tar xf mali-r4p0.tar &>> $buildlog
	unzip -qq ddx.zip &>> $buildlog
	
	# Build DDX
	cd xf86-video-armsoc-r4p0
	./autogen.sh --with-drmmode=exynos --prefix=/usr &>> $buildlog
	make -j4 &>> $buildlog
	make install &>> $buildlog
	
	cd ..
	
	# Install new Binaries
	cd mali
	cp -aRP lib* /usr/lib
	ldconfig
	cp config/xorg.conf /etc/X11/xorg.conf
	
	cd /tmp && rm -fr $root
	sync
	
	msgbox "Mali is now updated. If something fails or isn't working report on the forums with the following file: $buildlog"
}

armsoc_err_not_supportted() {
	msgbox "ARMSOC: Your distro isn't supportted. Report this on the forums -> Distro $DISTRO and board $BOARD"
}
