# Debian image for Amlogic SOC's.
Minimal Debian and Ubuntu images for Amlogic based OTT TV-boxes with mainline LTS kernel. Boots the kernel with vendor u-boot, so without chainloading of u-boot.

## Current images:
- Debian Bullseye (v11) with kernel 5.15.50
- Ubuntu Jammy (v22.04 LTS) with kernel 5.15.50
- Armbian 22.05 Jammy with DEVMFC boot config and kernel 5.15.50. (**unofficial**, so **no** support from the Armbian team)

## Current supported SOC's via generic DTB's (device tree's)
- S905X (Meson GXL)
- S905X2 (Meson G12A), 100M and 1000M ethernet
- S905X3 (Meson SM1), 100M and 1000M ethernet
- S922X (Meson G12B), 1000M ethernet
- Experimental: S905X4 (Meson SC2)

## Tested TV-boxes with specific DTB (bluetooth / leds / vfd display)
- A95X F2 (S905X2)
- Beelink GT King (S922X)
- H96 Max X3 (S905X3, 1000M ethernet)
- HK1 X3 (S905X3, 1000M ethernet)
- Tanix TX3 (S905X3, 1000M ethernet)
- TOX1 (S905X3, 1000M ethernet)
- X88 Pro X3 (S905X3, 1000M ethernet)
- X96 (S905X3)
- X96 Air A100 (S905X3, 100M ethernet)
- X96 Air P2 (S905X3, 1000M ethernet)
- X96 Air P3 (S905X3, 1000M ethernet)
- X96 Max Plus 2 (S905X3, 1000M ethernet)
- X96 Max Plus 2T (S905X3, 1000M ethernet)
- X96 Max Plus Q2 (S905X3, 1000M ethernet)
- x96 X4 Gigabit (**EXPERIMENTAL** S905X4, 1000M ethernet)

## Install
1. Burn the image to a USB flash disk (or sdcard) with some image burner like Balena Etcher, Win32Diskimager, dd or something
2. Open **boot.config** on the first FAT-partition with an editor
3. Uncomment the **box=** line for your box.
4. If you want to boot from sdcard: uncomment the line **root=/dev/mmcblk0p1**
5. Save the config file. 

## Start
3. put the disk in the box
4. hold the reset/update button (in most cases this button is hidden in the av-port, get a toothpick or cotton tip and push the button with that) 
5. power on the box
6. hold the reset/update button for about 7 seconds (longer does not hurt)
7. it should now boot to Debian / Ubuntu
8. you can login with user **root**, password: **tvbox**
12. Have fun

## Boot process
- The boot script uses the vendor bootloader on the box, so there is no bootloader in the image
- The boot script does not use a "chain loaded" bootloader
- The boot script will NOT install 'multiboot' or modify the bootloader environment with its boot procedure. This in contrary of most other images for Amlogic boxes. This means that it is almost impossible to damage/brick your device while trying to boot with this image. This also means that you have to push the reset button every time you want to boot with this image. However, you can install 'multiboot' by running **./aml-multiboot-setup.sh** in the */root* directory when booted into Linux. That script WILL change your bootloader's environment, so there is a chance (very small, but still) this can 'brick' your box. If you don't have the tools, images or knowledge to unbrick your box: be warned and don't blame me or ask me for help. 

## What does work
In most cases:
[x] HDMI
[x]  HDMI sound
[x]  USB 2 and 3
[x]  eMMC
[x]  SDCARD
[x]  Ethernet (100M and Gigabit)
[x]  Wifi
[x]  Bluetooth
[x]  VFD Led Display

### Exceptions
**A95XF2:** bluetooth (MT7668) will not work, wifi does work  
**X96 Max Plus Q2:** Wifi (qca6174) is slow/lagging for small transfers  
**X96X4:** wifi sometimes will not come up (seems to be some power issue with the box itself). HDMI does not really work, but with the use of simpleframebuffer there is a console. 

### Not tested but will probably work
- cec
- ir

### Not tested and probably won't work:
- S/PDiff port
- av-port

## Sources
Sorry no sources at this moment. Not that I don't want to share, but because they are messy and I don't have the time to clean them up.   However, most of the sources for the images are just shell scripts, so feel free to reuse them. Also the bootscripts, box configs and DTB's are all there. When I have some time to spare I will try to upload the sources.
