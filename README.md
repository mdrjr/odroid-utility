ODROID UTILITY (UNOFFICIAL UPDATE)
==================================

This fork improves the structure of the original project and adds a lot of features, which are partly known from raspi-config.

**Sources :** https://github.com/mdrjr/odroid-utility

**How to Install :**

```
git clone https://github.com/api-walker/odroid-utility.git

cd odroid-utility

sudo -s

chmod +x updater.sh

updater.sh

odroid-utility.sh
```

**Usage :**

```
sudo odroid-utility.sh [--update]

--update = Update the internals
```

**What is supported :**
* Old :
  * Debian and Ubuntu.
  * Xorg on/off,
  * Change hostname,
  * Configure HDMI (x/x2/u2/u3/c1) only,
  * Kernel Update (all boards),
  * boot.scr's update (all boards) Oh yes. Updating the kernel doesn't replace your boot.scr's anymore. If you was using custom ones to boot from hdd then they should be safe now,
  * Rebuilds Xorg DDX , installs new Mali drivers when they are available and fixes ABI errors,
  * Filesystem resize.
* New :
  * Desktop Environments
  * Change password
  * Change locale
  * Change timezone
  * Change keyboard-layout
  * Changed kernel-update for odroid-c to direct update
  * Direct KODI installation on Odroid C1
  * Start without updating
  
**State :**
* BETA

**Disclaimer :**
* Some changes are based on raspi-config code.

**Todo :**
* full testing

Ideas and patches are welcome. Please submit a pull request on github.
