# Debian Linux image for Android TV boxes with Amlogic SOC's.
Minimal Debian and Ubuntu Linux images for Amlogic based OTT TV-boxes with mainline Linux LTS kernel. Boots the kernel with vendor u-boot, so without the use of a chain loaded u-boot.

## Current images:
- Debian Bookworm (v12) with Linux kernel 6.6.16
- Ubuntu Mantic (v23.10)  with Linux kernel 6.6.16

## New boxes since this release:
- X96 Max (S905X2 1000M)
- H96 Max W2 (S905W2, thus **experimental**)
 
## Tested TV-boxes with box specific DTB (bluetooth / leds / vfd display)
- A95X (S905)
- A95X F2 (S905X2)
- Beelink GT King (S922X)
- H96 Max W2 (**EXPERIMENTAL** S905W2, 100M ethernet)
- H96 Max X3 (S905X3, 1000M ethernet)
- H96 Pro Plus (S912, 1000M ethernet)
- HK1 X3 (S905X3, 1000M ethernet)
- KM8 Pro (S912, 1000M ethernet)
- Tanix TX3 (S905X3, 1000M ethernet)
- Tanix W2 (**EXPERIMENTAL** S905W2, 100M ethernet)
- TOX1 (S905X3, 1000M ethernet)
- Vontar X4 (**EXPERIMENTAL** S905X4, 1000M ethernet)
- X88 Pro X3 (S905X3, 1000M ethernet)
- X96 (S905X, 100M ethernet))
- X96 Air A100 (S905X3, 100M ethernet)
- X96 Air P2 (S905X3, 1000M ethernet)
- X96 Air P3 (S905X3, 1000M ethernet)
- X96 Max (S905X2, 1000M ethernet)
- X96 Max Plus 2 (S905X3, 1000M ethernet)
- X96 Max Plus 2101W (S905X3, 1000M ethernet)
- X96 Max Plus 2T (S905X3, 1000M ethernet)
- X96 Max Plus Q2 (S905X3, 1000M ethernet)
- X96 Mini (S905W, 100M ethernet)
- x96 X4 (**EXPERIMENTAL** S905X4, 1000M ethernet)


## Current supported SOC's via generic DTB's (device trees)
- S905 (Meson GXBB)
- S905W (Meson GXL)
- S905X (Meson GXL)
- S905X2 (Meson G12A), 100M and 1000M ethernet
- S905X3 (Meson SM1), 100M and 1000M ethernet
- S912 (Meson GXM), 1000M ethernet
- S922X (Meson G12B), 1000M ethernet
- Experimental: S905X4 (Meson SC2)
- Experimental: S905W2 (Meson S4)

## Install
1. Burn the image to a USB flash disk (or sdcard, but USB is more reliable) with some image burner like Balena Etcher, Win32Diskimager, dd or something
2. Open **boot.config** on the first FAT-partition with an editor
3. Uncomment the **box=** line for your box.
5. Save the config file. 

## Start
3. put the disk in the box
4. hold the reset/update button (in most cases this button is hidden in the av-port, get a toothpick or cotton tip and push the button with that) 
5. power on the box
6. hold the reset/update button for about 7 seconds (longer does not hurt)
7. it should now boot to Debian / Ubuntu

## login
1. Login via console or SSH (at first boot it can take a bit more time before SSH is available, because all encryption keys are regenerated)
1. you can login with user **root**, password: **tvbox**
2. Have fun

## Boot process
- The boot script uses the vendor bootloader on the box, so there is no bootloader in the image
- The boot script does not use a "chain loaded" bootloader
- The boot script will NOT install 'multiboot' or modify the bootloader environment with its boot procedure. This in contrary of most other images for Amlogic boxes. This means that it is almost impossible to damage/brick your device while trying to boot with this image. This also means that you have to push the reset button every time you want to boot with this image. However, you can install 'multiboot' by running **./aml-multiboot-setup.sh** in the */root* directory when booted into Linux. That script WILL change your bootloader's environment, so there is a chance (very small, but still) this can 'brick' your box. If you don't have the tools, images or knowledge to unbrick your box: be warned and don't blame me or ask me for help. 

## What does work
In most cases:
- HDMI
- HDMI sound
- USB 2 and 3
- eMMC
- SDCARD
- Ethernet (100M and Gigabit)
- Wifi
- Bluetooth
- VFD Led Display

### Exceptions
**A95X F2:** bluetooth (MT7668) will not work, wifi does work  
**X96 Max Plus Q2:** Wifi (qca6174) is slow/lagging for small transfers  
**X96 Max Plus 2101W:** Wifi does not work (aml_w1) 
**X96 Mini** Wifi does not work  
**X96 X4:** HDMI does not really work, but with the use of simpleframebuffer there is a console.  
**Tanxix W2:** HDMI does not really work, but with the use of simpleframebuffer there is a console, wifi does not work  
**H96 Max W2:** HDMI does not really work, but with the use of simpleframebuffer there is a console, wifi does not work  


### Not tested but will probably work
- cec
- ir

### Not tested and probably won't work:
- S/PDiff port
- av-port

## What is the purpose of these images
These images are the images I use myself for various projects and small server tasks like email, pi-hole, nextcloud, NAS, webserver etc.  
For these tasks I want to run a mainline LTS kernel (so not an older and sometimes buggy/insecure vendor kernel). The downside of this is that not all hardware is fully supported. If you are looking for better hardware support, take a look at the Coreelec images or Khadas Fenix images. I want a standard and clean Debian or Ubuntu distribution without unknown/untrusted APT repositories.  
It is just a hobby to tinker with some of these cheap Android TVBoxes for fun when I have some time to spare, not for any serious purpose.  
I publish them here in case someone wants to do the same and is looking for a basic image. You might get lucky and it just boots on your TVBox as well. If not... sorry, don't expect support from me. And how much I would like to do so, I simply don't have the time to be someones Linux teacher... 

## What are these images NOT
- Not suitable for media players like Kodi (Use Coreelec or Libreelec for that)
- Athough once in a while I test Linux desktop installation and there is a simple install script, these TVBoxes are (without hardware accelaration present in vendor kernels) IMHO waay to slow for desktop usage.
- This is not an attempt to become some kind of Linux distribution. it is just Debian / Ubuntu. So no support other than the gazillion support sources for Debian / Ubuntu already on the internet.
- They are NOT Armbian and are NOT Armbian based

## Sources
Sorry no sources at this moment. Not that I don't want to share, but because they are messy and I don't have the time to clean them up. However, most of the sources for the images are just Bash scripts, so feel free to reuse them. Also the bootscripts, box configs and DTB's are all there. When I have some time to spare I will try to upload the sources. 
- The kernel is based on the mainline kernel source (kernel.org), only SC2 and S4 support needs some extra patches.
- Some work for S4 is already in my Linux repository
- Wifi MT7688 modifications for mainline Linux and for G12a boxes are in my repo
