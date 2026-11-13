# X96 X4 Pro1 — LED strip control

Control the addressable LED strip PCB found in the Droidlogic **X96 X4 Pro1**
(S905X4 / Meson SC2) from a devmfc Debian/Ubuntu mainline image.

The stock image boots fine but leaves the strip uncontrolled (it stays on its
last state, usually solid red). This directory contains everything needed to
drive it from Linux:

| File | Purpose |
|---|---|
| `led` | control script (12 modes + raw frames), installed to `/usr/local/bin/led` |
| `led_verify` | diagnostic that sweeps all 12 modes, installed to `/usr/local/bin/led_verify` |
| `meson-sc2-x96x4.dtb` | patched device tree: muxes UARTA to the strip pads (D8/D9) |
| `meson-sc2-x96x4.dts` | source of the DTB (decompiled stock DTB + pinctrl patch) |
| `install.sh` | one-shot installer, run on the box |

## How it works

The strip PCB is wired to **UARTA** (MMIO `fe078000`) on pads **D8/D9**. The
stock devmfc DTB for this board does not enable a pinctrl state for
`serial@78000`, so the UART controller's TX pin never reaches the strip. The
patched DTB adds:

```dts
pinctrl-0 = <&uart_a_pins2>;   /* D8/D9 */
pinctrl-names = "default";
```

to the `serial@78000` node (the `uart_a_pins2` group of the SC2 pinctrl
driver). After that, writing frames to the UART at 9600 baud, 8N1 controls
the strip.

Protocol (reverse-engineered from the stock Android "LED Control" app):

```
Frame (7 bytes): 23 04 1E | P1 P2 P3 | CHK
CHK = (P1 + P2 + P3 + 0x45) mod 256
One-way: the PCB never transmits back (no ACK).
```

## Install (on the box, as root)

```sh
scp -r x96x4-led root@<box-ip>:/root/
ssh root@<box-ip> '/root/x96x4-led/install.sh'
reboot
```

The installer backs up the stock DTB to `meson-sc2-x96x4.dtb.orig` before
replacing it. Reverting is a single copy of that backup plus a reboot.

## Usage

```sh
led <mode>       # off auto flash rainbow fade runwater flow color1 color2 red green blue
led raw 1410ff   # arbitrary payload (checksum computed)
led raw 23041e14100059   # full 7-byte frame, sent as-is
led port         # show which /dev/ttySN is currently used
led list         # help
```

Mode payloads:

| mode | payload | mode | payload |
|---|---|---|---|
| off | `140000` | fade | `23f000` |
| auto | `23e000` | runwater | `23b001` |
| flash | `25c800` | flow | `234800` |
| rainbow | `14d000` | color1 | `142800` |
| red | `141000` | color2 | `143000` |
| green | `141011` | blue | `141001` |

### From a PC over SSH

```sh
ssh root@<box-ip> 'led red'
```

or wrap it in your favourite alias/script. The tty port is auto-detected from
the kernel log on every invocation; override with `LED_PORT=/dev/ttySN` if
needed.

## Troubleshooting

- **Strip ignores all commands after a reboot** — power-cycle the box
  (unplug/replug). The strip's own controller can hang and only a full power
  reset clears it. This is a PCB quirk, not a Linux problem.
- **Wrong port** — the ttyS number assigned to `fe078000` can change between
  boots. `led port` shows the detected one; `dmesg | grep fe078000` shows the
  kernel's mapping.
- **Revert to stock behaviour** — copy the `.orig` DTB backup back over
  `/boot/dtb-$(uname -r)/amlogic/meson-sc2-x96x4.dtb` and reboot.

## Provenance / license

`meson-sc2-x96x4.dts/.dtb` are derived from the device tree shipped in the
devmfc Debian image for this board (kernel DT content, GPL-2.0-only), patched
with the pinctrl change described above. The scripts are original work,
GPL-2.0-only, matching this repository's license.
