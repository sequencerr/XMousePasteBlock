# XMousePasteBlock

Listens for middle mouse click events and clears the primary X selection (and cut buffers) on detection to avoid accidentially pasting stuff all over the place.

## About

No need to disable your precious middle mouse button bindings, no clearing of visual selections nor performance losses because of emptying the primary X clipboard periodically.
With the utilization of XInput and Xlibs this has _no_ measurable impact on performance whatsoever.
No elevated privileges required. Just run within your regular users' X session.

## Installation

On Arch Linux you may simply use the [AUR package](https://aur.archlinux.org/packages/xmousepasteblock-git).

For all other distros, please follow the instructions below.

## Building

### Using Docker:
```
$ git clone --depth 1 https://github.com/sequencerr/XMousePasteBlock.git
$ sudo docker build --progress=plain -t xmousepasteblock --target export --output type=local,dest=. .
```

### Manually
### Acquiring the sourcecode

Clone the repository in whichever way you prefer. For example:
```
git clone https://github.com/milaq/XMousePasteBlock.git
```

### Dependencies

You will need to install the libev, Xlib and X11 Input extension headers in addition to `make`, `gcc` and `pkg-config` to build this repository. You can install them, plus several other "essential" libraries, with the `build-essential` library. Otherwise you can install them individually.

Debian and derivatives (e.g. Ubuntu):
```
sudo apt-get install make gcc pkg-config libev-dev libx11-dev libxi-dev
```
Fedora:
```
sudo dnf install make gcc pkgconfig libev-devel libX11-devel libXi-devel
```

Compile and install (from the directory in which you cloned the repository):
```
make
sudo make install
```

<details>
<summary>Note for OpenBSD users (click to expand)</summary>
Before running <code>make</code>, please uncomment the respective comments
inside the <code>Makefile</code><br>
<br>
</details>

## Running

Just add `xmousepasteblock` to your startup script/config or use the included systemd user service.

Note: If you're using any kind of clipboard manager, make sure it does not prevent clearing the PRIMARY selection. By default, Klipper (KDE's stock clipboard manager) *does* prevent this type of clearing. Klipper users, look below for additional instructions.

### KDE Plasma 5.25 and above

In `~/.config/klipperrc` (Klipper's config file), add the following line:
```
NoEmptyClipboard=false
```

### KDE Plasma 5.24 and below

Within Klipper's settings, make sure to disable `Prevent empty clipboard`.

## Configuration

### Mouse button remap handling

If you happen to remap the middle mouse button `2` (e.g. with `xinput set-button-map 10 1 3 2 4 5 6 7 8 9`) we need to watch all XInput slave devices instead of all XInput master devices in order for XmousePasteBlock to catch the correct remapped button.

To tell XmousePasteBlock to watch all XInput slave devices, set the following environment variable:
```
XMPB_WATCH_SLAVE_DEVICES=1
```

#### Why aren't we doing this by default?

Some users reported issues when using slave device reporting (which was the default in version 1.3 only).
Since version 1.4 the default is to watch master devices again (as with version <= 1.2) and make the slave device reporting configurable for those users who remap their mouse buttons.

## Debugging

In case you're having problems and _before_ opening an issue, please compile with
```
make debug
```
and execute the resulting binary
```
./xmousepasteblock
```

You should now see debug messages when pressing mouse buttons. This helps tremendously in pinning down your specific issue.

## Known issues

### Trackpoint scrolling

In case of devices which are configured with middle mouse button hold-to-scroll (e.g. Trackpoints), it may happen that the primary selection clear action gets fired too late on older and slower machines.
You can observe the behavior by building with the DEBUG flag set (`make debug`), running `xmousepasteblock` in a shell and watching the debug output as you long press and hold the mouse buttons.

This is due to the fact that the XI_RawButtonPress event only gets fired _after_ releasing the middle mouse button (in case the user wanted to execute a scroll action).
The only option to work around this is to disable the middle mouse button hold-to-scroll functionality on Trackpoint devices (which is often not desirable):
```
xinput set-prop <device id> 'libinput Button Scrolling Button' 0
```
