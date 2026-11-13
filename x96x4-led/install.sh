#!/bin/sh
# install.sh - install LED strip control for the X96 X4 Pro1 (S905X4/SC2)
# on a devmfc Debian/Ubuntu mainline image. Run as root ON THE BOX:
#
#   scp -r x96x4-led root@<box>:/root/
#   ssh root@<box> '/root/x96x4-led/install.sh'
#
# What it does:
#   1. backs up the stock DTB (once, to <dtb>.orig)
#   2. installs the patched DTB that muxes UARTA to pads D8/D9 (the strip)
#   3. installs /usr/local/bin/led and /usr/local/bin/led_verify
#
# A reboot is required for the new DTB to take effect.

set -e

DIR=$(cd "$(dirname "$0")" && pwd)
DT_DIR=/boot/dtb-$(uname -r)/amlogic
DTB=$DT_DIR/meson-sc2-x96x4.dtb

if [ ! -f "$DTB" ]; then
    echo "error: $DTB not found (is this an X96 X4 / SC2 box with a devmfc image?)" >&2
    exit 1
fi

# 1. back up the stock DTB once
if [ ! -f "$DTB.orig" ]; then
    cp -p "$DTB" "$DTB.orig"
    echo "backed up stock DTB to $DTB.orig"
else
    echo "stock DTB backup already present: $DTB.orig"
fi

# 2. install the patched DTB (UARTA -> D8/D9)
install -m 644 "$DIR/meson-sc2-x96x4.dtb" "$DTB"
echo "installed patched DTB: $DTB"

# 3. install the control scripts
install -m 755 "$DIR/led" /usr/local/bin/led
install -m 755 "$DIR/led_verify" /usr/local/bin/led_verify
echo "installed /usr/local/bin/led and /usr/local/bin/led_verify"

echo
echo "== done. Reboot the box, then test:"
echo "   led red          # should turn the strip solid red"
echo "   led_verify       # sweeps all 12 modes"
echo
echo "If the strip does not respond after a reboot, power-cycle it"
echo "(unplug/replug the box): its controller can hang and needs a reset."
