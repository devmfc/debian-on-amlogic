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
#   3. installs /usr/local/bin/led, led_verify and led_seq
#   4. installs sequence presets (party, night, alarm)
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
install -m 755 "$DIR/led_seq" /usr/local/bin/led_seq
echo "installed /usr/local/bin/led, led_verify and led_seq"

# 4. install the sequence presets
install -d -m 755 /usr/local/share/x96x4-led/sequences
cp -p "$DIR"/sequences/*.seq /usr/local/share/x96x4-led/sequences/
echo "installed sequence presets to /usr/local/share/x96x4-led/sequences/"

echo
echo "== done. Reboot the box, then test:"
echo "   led red          # should turn the strip solid red"
echo "   led_verify       # sweeps all 12 modes"
echo "   led_seq -l party # loops a custom sequence (Ctrl-C stops)"
echo
echo "If the strip does not respond after a reboot, power-cycle it"
echo "(unplug/replug the box): its controller can hang and needs a reset."
