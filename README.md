TOOL - ODROID UTILITY
=====================
**UNOFFICIAL UPDATE**

I've started to write this script to replace kernel-update. It does WAY more then the current kernel-update is doing. I plan to replace kernel-update with this tool very soon.

**Sources:** https://github.com/mdrjr/odroid-utility

**How to Install :**

```
git clone https://github.com/api-walker/odroid-utility.git

cd odroid-utility

sudo -s

chmod +x updater.sh

odroid-utility.sh
```

Don't worry about the extra files. The script self-updates itself everytime its started.

**What is supported :**

* Debian and Ubuntu.
* Xorg on/off,
* Change hostname,
* Configure HDMI (x/x2/u2/u3/c1) only,
* Kernel Update (all boards),
* boot.scr's update (all boards) Oh yes. Updating the kernel doesn't replace your boot.scr's anymore. If you was using custom ones to boot from hdd then they should be safe now,
* Rebuilds Xorg DDX , installs new Mali drivers when they are available and fixes ABI errors,
* Filesystem resize.

**New features :**
* Desktop Environments
* Change password
* Change locale
* Change timezone
* Change keyboard-layout
* Changed kernel-update for odroid-c to direct update
* Direct KODI installation on Odroid C1
* Start without updating
* Some fixes

**Disclaimer**
* Some changes are based on raspi-config code

**TODO :**
* full testing

**State :**
* BETA


Ideas and patchs are welcome. Either post a diff with your e-mail and name or submit a PR on github.
