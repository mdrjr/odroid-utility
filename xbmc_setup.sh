#!/bin/bash

xbmc_setup() {
	
	get_board
	
	do_5422_1504_apt_update
	
	if [ "$BOARD" = "odroidc" ]; then
		msgbox "Use apt-get install kodi   or   apt-get update && apt-get dist-upgrade"
		return
	fi

	if [ "$BOARD" = "odroidu2" ]; then
		4412_xbmc_update
		return
	fi	

	msgbox "Not supported yet"
}


4412_xbmc_update() {
	
	if [ "$DISTRO" != "ubuntu" ]; then
		msgbox "Only Ubuntu is supported"
		return
	fi
	
	# Big list of dependencies
	apt-get install -y libelf1 libaacs0 libasound2-data libasound2 libasyncns0 libavahi-common-data libavahi-common3 libavahi-client3 libavutil52 libgsm1 libmp3lame0 libopenjpeg2 libopus0 liborc-0.4-0 libschroedinger-1.0-0 libspeex1 libogg0 libtheora0 libva1 libvorbis0a libvorbisenc2 libvpx1 libx264-142 libxvidcore4 libavcodec54 libavformat54 libavresample1 libfreetype6 libswscale2 libavfilter3 libbluetooth3 libbluray1 libcaca0 libcups2 libdrm-nouveau2 libdrm-radeon1 libllvm3.4 libxcb-dri2-0 libgbm1 libx11-xcb1 libxcb-xfixes0 libxfixes3 libenca0 libflac8 fonts-dejavu-core fontconfig-config libfontconfig1 libfontenc1 libxcb-dri3-0 libxcb-glx0 libxcb-present0 libxcb-sync1 libxdamage1 libxshmfence1 libxxf86vm1 x11-common libice6 libjpeg-turbo8 liblcms2-2 libtalloc2 libtdb1 libtevent0 libldb1 liblzo2-2 libmad0 libmicrohttpd10 libmpeg2-4 mysql-common libmysqlclient18 libnfs1 libntdb1 libpcrecpp0 libplist1 libsndfile1 libpulse0 libpython2.7 libsamplerate0 libsdl1.2debian libshairport1 libsm6 libssh-4 libtag1-vanilla libjbig0 libjpeg8 libtiff5 libtinyxml2.6.2 libvdpau1 libvorbisfile3 libwbclient0 libxt6 libxmu6 libxpm4 libxaw7 libxcb-shape0 libxcomposite1 libxrender1 libxft2 libxi6 libxinerama1 libxrandr2 libxtst6 libxv1 libxxf86dga1 python-talloc samba-libs libass4 libsmbclient libtxc-dxtn-s2tc0 libwebp5 libwebpmux1 libyajl2 fonts-liberation libcdio13 libmodplug1 libpostproc52 libtag1c2a python-pil python-imaging python-support x11-utils libxslt1.1
	
	# Remove XBMC
	apt-get remove -y --force-yes xbmc
	
	bd="20150219"
	rev="1"
	kodi_file=kodi_"$bd"-"$rev"_armhf.deb
	
	cec_version="2.2.0"
	cec_rev="1"
	cec_file=libcec_"$cec_version"-"$cec_rev"_armhf.deb

	td=/tmp/kodi_update
	rm -fr $td
	mkdir -p $td
	
	cd $td
	
	dlf_fast http://builder.mdrjr.net/tools/u3/$kodi_file "Downloading Kodi Helix. Build Date: $bd Revision: $rev" $td/$kodi_file
	dlf_fast http://builder.mdrjr.net/tools/u3/$cec_file "Download libcec. Version: $cec_version Revision $cec_rev" $td/$cec_file
	
	dpkg --force-all -i $td/$cec_file
	dpkg --force-all -i $td/$kodi_file
	
	msgbox "Kodi/XBMC Updated"
	
}
