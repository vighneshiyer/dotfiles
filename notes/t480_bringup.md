# T480 Specific Stuff

- Things that don't work
    - Fingerprint sensor
    - IR camera (can show image, but not usable)

## Bluetooth

- https://unix.stackexchange.com/questions/508221/bluetooth-service-running-but-bluetoothctl-says-org-bluez-error-notready
    - Run `power on` in bluetoothctl
- https://askubuntu.com/questions/475987/a2dp-on-pulseaudio-terrible-choppy-skipping-audio
    - Fix choppy audio that wasn't present on Ubuntu 16.04 by adding a buffer
- https://wiki.archlinux.org/index.php/Bluetooth_headset#Connecting_works,_but_there_are_sound_glitches_all_the_time
- https://wiki.archlinux.org/index.php/PulseAudio/Troubleshooting#Glitches,_skips_or_crackling

- `bluetoothctl`
    - scan
    - paired-devices
    - connect

## Performance Tuning

- Fix CPU throttling: https://github.com/erpalma/throttled
- t480 bringup notes: https://github.com/vesche/t480
- t480 freebsd thread: https://news.ycombinator.com/item?id=22269762
- https://monadical.com/posts/moving-to-linux-desktop.html
    - Review of power optimization, dpi scaling, mouse tweaks

## dmesg Audit Messages

```text
[795699.419970] audit: type=1105 audit(1610347171.978:1999): pid=2128033 uid=0 auid=1000 ses=11 subj==unconfined msg='op=PAM:session_open grantors=pam_limits,pam_unix,pam_permit acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/2 res=success'
[795699.421938] audit: type=1106 audit(1610347171.981:2000): pid=2128033 uid=0 auid=1000 ses=11 subj==unconfined msg='op=PAM:session_close grantors=pam_limits,pam_unix,pam_permit acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/2 res=success'
[795699.422014] audit: type=1104 audit(1610347171.981:2001): pid=2128033 uid=0 auid=1000 ses=11 subj==unconfined msg='op=PAM:setcred grantors=pam_faillock,pam_permit,pam_faillock acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/2 res=success'
```

- Run: `sudo systemctl auditd disable`
- Modify: `/etc/default/grub` to add `audit=0` to kernel params, re-run `update-grub`
- Run: `sudo auditctl -e 0` to disable audit for current session

## WiFi

- Use `nmtui` to setup network connections inside i3, avoid using nmcli directly except to do `nmcli con up <Con Name>`

I'm trying to use `nmcli` only. It works easily to connect to unsecured or WPA2 access points.

To list APs: `nmcli d wifi`

### Connecting to EECS-Secure

EECS-Secure is a WPA2 Enterprise (802.1X) secured network.

#### EECS-Secure Details from IRIS

These settings should be used to connect to EECS-Secure:

- Wireless Security: WPA2 Enterprise, AES encryption
- EAP Method: PEAP
- Key Type: Automatic
- Phase2 Type: MSCHAPV2
- Identity: Your EECS username
- Password: Your EECS Active Directory (Windows) Password

During the connection process, your wireless client may indicate that the server certificate for EECS-Secure is presented by clearpass.EECS.Berkeley.EDU and issued by InCommon Certification Authority (2048).

#### Setting up the connection

```
nmcli con # Check if a EECS-Secure connection already exists
nmcli d # Find your wifi device ifname (wlp3s0 on T480)
nmcli con add type wifi con-name "EECS-Secure" ifname wlp3s0 ssid "EECS-Secure"
nmcli con edit EECS-Secure # Enter interactive connection edit session
nmcli> set wifi-sec.key-mgmt wpa-eap
nmcli> set 802-1x.eap peap
nmcli> set 802-1x.identity "vighnesh.iyer"
nmcli> set 802-1x.phase2-auth mschapv2
nmcli> quit
```

#### One Shot

```shell
nmcli connection add
   type wifi con-name "EECS-Secure" ifname wlp3s0 ssid "EECS-Secure" -- \
   wifi-sec.key-mgmt wpa-eap 802-1x.eap peap \
   802-1x.phase2-auth mschapv2 802-1x.identity "vighnesh.iyer"
```

#### Using the connection

```
nmcli con up EECS-Secure --ask # Enter your password once and nmcli will store it without it showing up in shell history
```

### Connecting to eduroam

```
nmcli connection add \
        type wifi con-name "eduroam" ifname wlp3s0 ssid "eduroam" -- \
        wifi-sec.key-mgmt wpa-eap 802-1x.eap ttls \
        802-1x.phase2-auth mschapv2 802-1x.identity "vighnesh.iyer@berkeley.edu"
nmcli con up "eduroam" --ask
# Enter the password
# Now you're good to go, password saved in NetworkManager keychain
```

### Connecting to the BSSID with the highest power

- https://unix.stackexchange.com/questions/612290/nmcli-select-bssid-when-two-access-points-have-the-same-ssid
- Connect to the SSID you want `nmcli con up eduroam`
- Search for the BSSID with the best connection `nmcli d wifi list` - keep it in mind
- `sudo wpa_cli -i wlp3s0 list_networks` - find our connection
- `sudo wpa_cli -i wlp3s0 bssid 0 <the best bssid>`
- `sudo wpa_cli reassociate`
- `sudo wpa_cli list_networks` - make sure we're connected to the right bssid
- `nmcli d wifi list` - make sure again using NetworkManager

## Trackpoint

- Install the latest libinput, maybe from source

```bash
sudo apt-get build-dep libinput
sudo apt-get install libgtk-3-dev check valgrind libsystemd-dev
git clone https://gitlab.freedesktop.org/libinput/libinput
cd libinput
meson --prefix=/usr builddir/ -Ddocumentation=false
ninja -C builddir/
sudo ninja -C builddir/ install
```

Make sure to install any dependencies that `meson` complains about before running `ninja`. Reboot after installing libinput.

To push the trackpoint speed even higher than possible with DE settings:

```bash
cd /sys/devices/platform/i8042/serio1/serio2/
cd /sys/devices/platform/i8042/serio1/driver/serio2 # for manjaro 20+
echo 255 | sudo tee sensitivity
echo 200 | sudo tee speed
```

## NVIDIA Driver / Optimus

Using the GNOME drivers dialog, enable all repo sources (including closed-source stuff) and install the stable NVIDIA proprietary driver (nvidia-390). Reboot.

If you want to use NVIDIA graphics, `sudo prime-select nvidia` and reboot. Use `lspci -k` and `glxinfo | grep NVIDIA` to check the NVIDIA card is active.

If you want to switch to Intel to save battery, `sudo prime-select intel` and reboot. Due to a bug in something... the NVIDIA card isn't actually powered down, which sucks away 7-10W extra.

Use `sudo powertop` to see the power consumption which should be 7W idle with Intel only and around 15-20W with the NVIDIA card active.

The workaround documented here (https://github.com/stockmind/dell-xps-9560-ubuntu-respin/issues/8) works great!

```
echo auto | sudo tee /sys/bus/pci/devices/0000:01:00.0/power/control
```

Where the PCI device identifier of the NVIDIA card can be found with `lspci | grep 3D`. After running this, the NVIDIA card is actually powered off. Verify with `sudo powertop` which should report 7W consumption. You need to be on battery power for `powertop` to display power consumption.

### Manjaro

- I installed the PRIME properietary NVIDIA driver using the Manjaro hardware utilities
- I also installed optimus-manager with pacman and rebooted
    - Worked out of the box to switch to nvidia, play csgo, and back to intel
    - However switching back to intel requires 2-3 minutes and hangs the display during that time, but it eventually worked
- Haven't messed with power management since enabling all powertop PM settings and using the nvidia driver for PM seems OK when the laptop is plugged in, but ovbiously it doesn't disable the nvidia card entirely (nvidia-smi still works)
    - Revisit this once I need to work on battery power again

### Screen Brightness

I had to add a file in `/etc/X11/xorg.conf` with the following:

```
Section "Device"
Identifier "Card0"
Driver "intel"
Option "Backlight" "/sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight/brightness"
EndSection
```

and then `xbacklight` works after logout and back in.

## Displays

The DPI for the T480 laptop display should be around 184.

### Calculation

Internal display: (31x17 cm) (2560x1440)
    - divide by 2.54 to get inches
    x_dpi = 2560 / x_in = 209.75
    y_dpi = 1440 / y_in = 215.15
    Using DPI = 212 which divides by 2 and 4 seems to be a good fit

External display: (52x33 cm) (1920x1200)
    x_dpi = 1920 / x_in = 93.78
    y_dpi = 1200 / y_in = 92.36

The best match seems to be a native DPI of 184, and scaling by 2x2 for the external monitor.

### Implementation

To set the DPI for Xorg apps and most Gtk+ apps, add this line in `~/.Xresources` (should be multiple of 96)

```
Xft.dpi: 192
```

Then add an exec line in your i3 config to set it also using `xrandr`:

```
exec --no-startup-id "xrandr --dpi 192"
```

Logout and back in and verify the DPI is set correctly:

```
xrdb -query
xdpyinfo | grep -B 1 resolution
```

- In Firefox, adjust the setting `layout.css.devPixelsPerPx` to further refine the scaling

Now when I added an external monitor which wasn't HiDPI, I had to scale up its internal framebuffer resolution, and then scale down the framebuffer delivered to the output. The issue is that the resampling uses bilinear filtering: see `xrandr --verbose` (look for transforms). This causes slightly blurry text.

Recently a nearest neighbor interpolation scheme was added to `xrandr`'s master, so going to try and build it from source.

```
git clone git://anongit.freedesktop.org/xorg/app/xrandr
sudo apt install xutils-dev
./autogen.sh
sudo make install
xrandr --output DP1 --filter nearest
```

OK, so this doesn't help my situation since this is for upscaling interpolation (not for downscaling). It looks very bad when used to downscale.

### External Monitor Dimming

- Install ddcutil (pacman -S ddcutil)
- Install i2c-tools (pacman -S i2c-tools)
- Use `sudo ddcutil environment` to figure out issues
- Manually load the driver for now
    - `sudo modprobe i2c-dev`
    - Check it's loaded: `lsmod | grep i2c`
- Create `/etc/modules-load.d/i2c-dev.conf`
    - Should have one line with `i2c_dev`
    - This will load the kernel module on boot
- Check with `sudo ddcutil detect`
- Avoid using root
    - `sudo groupadd --system i2c`
    - `sudo usermod -G i2c -a vighnesh`
    - Then log out and back in
- `ddcutil getvcp known`
    - Lists vcps that can be modified
    - 0x10 = brightness
    - 0x12 = contrast
- `sudo ddcutil setvcp --model "DELL U2515HX" 0x10 30`
    - set brightness level to 30/100

- Creating a group i2c and adding myself to it didn't fix the permissions on the i2c devices... (this only works on Debian/Ubuntu)
- Instead add a file to `/etc/udev/rules.d` with the following:

```udev
SUBSYSTEM=="i2c-dev",KERNEL=="i2c-[0-9]*", MODE="0666"
```

Run:

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

to apply the new permissions without rebooting.

## Redshift

Use `stow redshift` to place the redshift config file and a systemd user unit file in the right `~/.config` place.

```
systemctl --user start redshift # to start
systemctl --user enable redshift # to enable autostart on boot
```

## Colors

- https://wiki.archlinux.org/index.php/Color_output_in_console
- Uncomment the Color line in `/etc/pacman.conf`

## VPN

- For the 'new' Berkeley VPN (GlobalProtect, Cisco has been decomsissioned)
- The 'official' GlobalProtect client from PaloAltoNetworks is garbage
- Instead `yay globalprotect-openconnect`
- Run `gpclient`
- Use `vpn.berkeley.edu`
- Enter credentials and 2FA as usual in the popup browser
- Connected, ignore the error message

## Systemd DBUS issues

- `systemctl start user@1000.service`
- `systemctl --user import-environment DISPLAY`
- `systemctl --user start redshift`
