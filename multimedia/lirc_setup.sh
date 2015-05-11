#!/bin/bash

default_remote() {
    cat>/etc/lirc/lircd.conf<<__EOF
begin remote
    name  lircd.conf
    bits           16
    flags SPACE_ENC|CONST_LENGTH
    eps            30
    aeps          100

    header       8964  4507
    one           544  1692
    zero          544   561
    ptrail        544
    pre_data_bits  16
    pre_data     0x4DB2
    gap          107872
    toggle_bit_mask 0x0

    begin codes
        KEY_LEFT        0x9966
        KEY_RIGHT       0x837C
        KEY_UP          0x53AC
        KEY_DOWN        0x4BB4
        KEY_ENTER       0x738C
        KEY_HOME        0x41BE
        KEY_MUTE        0x11EE
        KEY_MENU        0xA35C
        KEY_BACK        0x59A6
        KEY_VOLUMEDOWN  0x817E
        KEY_VOLUMEUP    0x01FE
        KEY_POWER       0x3BC4
    end codes
end remote
__EOF
}

lirc_setup() {

	# We can only install LIRC if kernel is > build#74
	KBUILD=`uname -r | cut -d "-" -f2`
	if [ $KBUILD -le 74 ]; then
		msgbox "You can only switch to LIRC if your kernel is updated."
		return
	fi


    apt-get -y purge odroid-remote
    apt-get -y purge lirc
    rm -fr /etc/lirc
    apt-get -y install lirc

    service lirc stop

    hwconf=/etc/lirc/hardware.conf
    sed -i "s/^REMOTE_MODULES=.*/REMOTE_MODULES=\"meson-ir\"/g" $hwconf
    sed -i "s/^REMOTE_DRIVER=.*/REMOTE_DRIVER=\"default\"/g" $hwconf
    sed -i s/^REMOTE_DEVICE=.*/REMOTE_DEVICE=\""\/dev\/lirc0"\"/g $hwconf
    sed -i "s/^START_LIRCD=.*/START_LIRCD=\"true\"/g" $hwconf
    sed -i "s/^REMOTE_LIRCD_ARGS=.*/REMOTE_LIRCD_ARGS=\"--uinput\"/g" $hwconf

    default_remote

    msgbox "Default remote controller is configured, now LIRC will be started."

    service lirc start
}
