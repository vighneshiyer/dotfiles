# Installing From a Fresh Machine

## Utilities

- https://news.ycombinator.com/item?id=44620623
  - `btop` and `zoxide` seem nice
  - I can add local static binaries using chezmoi to avoid constant setup repacking
  - Replace my hacked together fish prompt (https://starship.rs/)

### Critical

- [chezmoi](https://www.chezmoi.io/) (dotfile manager, superior to `stow`)
- [fish](https://fishshell.com/) (a better `bash`, the best shell, no compat issues if only used as interactive shell and NOT as login/POSIX shell)
- [neovim](https://github.com/neovim/neovim) (a better `vim`)
- [eza](https://github.com/eza-community/eza) (a better `ls`)
- [fd](https://github.com/sharkdp/fd) (a better `find`)
- [rg](https://github.com/BurntSushi/ripgrep) (a better `ack`/`grep`)
- [tldr](https://github.com/tldr-pages/tldr) (a better `man`)
- [bat](https://github.com/sharkdp/bat) (a better `cat`/`less`)
- [delta](https://github.com/dandavison/delta) (a better `diff`)
- [tmux](https://github.com/tmux/tmux) (terminal multiplexer, most useful for remote persistence)
- [xsel](https://github.com/kfish/xsel) (clipboard manager)
- [i3](https://i3wm.org/) (tiling window manager)
- [btop](https://github.com/aristocratos/btop) (`htop` alternative)

### Others

- [alacritty](https://github.com/alacritty/alacritty) (terminal emulator)
- [rclone](https://rclone.org/install/) (mount remote filesystems + Google Drive / Backblaze B2 sync)
- [zathura](https://github.com/pwmt/zathura) (PDF/DJVU/epub reader)
- [nsxiv](https://github.com/nsxiv/nsxiv) (image/gif viewer)
- [mpv](https://github.com/mpv-player/mpv) (video + audio player)
- [flameshot](https://github.com/flameshot-org/flameshot) / [scrot](https://github.com/resurrecting-open-source-projects/scrot) (screenshot tool)
- [dunst](https://github.com/dunst-project/dunst) (notification daemon)
- [hyperfine](https://github.com/sharkdp/hyperfine) (CLI benchmarking tool)
- [fdupes](https://github.com/adrianlopezroche/fdupes) (duplicate file finder and remover)
- [Patched Source Sans 3](https://www.nerdfonts.com/font-downloads) (terminal font)
- [lazygit](https://github.com/jesseduffield/lazygit) (git TUI)

## z16 Setup

- From a base Arch install, install these packages

```bash
sudo pacman -S fish neovim eza fd ripgrep tldr bat git-delta tmux xsel alacritty rclone zathura nsxiv mpv hyperfine fdupes lazygit zathura-pdf-mupdf rsync xdg-desktop-portal xdg-desktop-portal-wlr python-jinja borg usbutils python-pipx wlsunset texlive sshfs wev tree i3status dmenu wmenu unzip npm reflector man git firefox mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver mesa-vdpau age bolt ddcutil wl-clipboard libnotify mako powertop libreoffice-fresh noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra dmidecode rustup cups cups-pdf cups-pk-helper system-config-printer linux-lts zola remmina freerdp inkscape yt-dlp jdk-openjdk openjdk-src udftools lsof python-joblib tree-sitter-cli obs-studio dart-sass lld sshuttle kicad ripgrep-all cmake lz4 iverilog yosys time lua53 pinta libc++ extra/perf lsb-release riscv64-elf-gcc vlc biber
sudo pacman -Syu --asdeps kicad-library kicad-library-3d

# https://wiki.archlinux.org/title/CUPS
systemctl enable --now cups.socket
sudo vim /etc/polkit-1/rules.d/49-allow-passwordless-printer-admin.rules

polkit.addRule(function(action, subject) {
    if (action.id == "org.opensuse.cupspkhelper.mechanism.all-edit" &&
        subject.isInGroup("wheel")){
        return polkit.Result.YES;
    }
});

system-config-printer # set up network printers

systemctl --user enable --now mako
systemctl --user enable --now wlsunset.service
```

- `paru` AUR helper

```bash
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

```bash
paru -S
paru -S snapd
systemctl restart apparmor.service
systemctl restart snapd.service
systemctl enable --now snapd.apparmor.service
systemctl enable --now snapd.socket
sudo snap install spotify

paru -S x2goclient
paru -S ttf-ms-win11-auto
```

- Install [mill](https://mill-build.com/mill/Installation_IDE_Support.html), [scala-cli](https://scala-cli.virtuslab.org/install/), and [coursier](https://get-coursier.io/docs/cli-installation) to `~/.local/bin`
  - `curl -L https://github.com/com-lihaoyi/mill/releases/download/0.11.7/0.11.7 > mill && chmod +x mill`
  - `curl -fL https://github.com/Virtuslab/scala-cli/releases/latest/download/scala-cli-x86_64-pc-linux.gz | gzip -d > scala-cli`
  - `curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d > cs`

- https://blog.aktsbot.in/no-more-blurry-fonts.html
  - Add this to `/etc/environment`

- https://linuxblog.io/boost-battery-life-on-linux-laptop-tlp/
  - Use TLP to improve battery life

### Switch to linux-lts as default kernel

- Add a file to `/boot/loader/entries` (`2024-02-28_03-43-03_linux-lts.conf`)

```
title   Arch Linux (linux)
linux   /vmlinuz-linux-lts
initrd  /amd-ucode.img
initrd  /initramfs-linux-lts.img
options root=PARTUUID=4582d8e9-773e-4eeb-ac4a-c76ea768ff79 zswap.enabled=0 rw rootfstype=ext4
```

- `sudo bootctl set-default 2024-02-28_03-43-03_linux-lts.conf`
- Check `bootctl status`, `bootctl list`, then reboot

## Millennium Machine Setup

I have a custom sysroot in `/nscratch/vighneshiyer/sysroot`.
The `~/.bashrc` contains:

```bash
# interactive prompt
PS1="${BBlu}\H:\w > ${RCol}"
PS2='> '

source /ecad/tools/vlsi.bashrc

export PATH=/nscratch/vighneshiyer/sysroot/bin:$HOME/.local/bin:${PATH}
export PYTHON_KEYRING_BACKEND="keyring.backends.null.Keyring"
export N_PREFIX=/nscratch/vighneshiyer/sysroot
```

Then I manually install programs I want into the sysroot by building from source or placing static binaries in `sysroot/bin`.

- Here are the programs I've installed:
  - `bat`
  - `delta`
  - `eza`
  - `fd`
  - `fish`, `fish_indent`, `fish_key_reader`
  - `hyperfine`
  - `n`, `node`, `npm`, `npx`, `corepack`
  - `nvim`
  - `rg`
  - `tmux`
  - `tree`
  - `xsel` (optional)
  - `poetry` is installed in `/scratch/vighneshiyer/poetry` (due to `poetry` installs not being truly portable across Millennium machines)
  - `miniforge3` is installed in `scratch/vighneshiyer/miniforge3` (due to `conda` not performing well unless on local disk)

## AMDGPU Crashes

```text
Sep 04 12:05:26 vighnesh-z16 kernel: [drm:amdgpu_job_timedout [amdgpu]] *ERROR* ring gfx_0.0.0 timeout, signaled seq=35864446, emitted seq=35864448
Sep 04 12:05:26 vighnesh-z16 kernel: [drm:amdgpu_job_timedout [amdgpu]] *ERROR* Process information: process firefox pid 725026 thread firefox:cs0 pid 725104
Sep 04 12:05:26 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: GPU reset begin!
Sep 04 12:05:26 vighnesh-z16 kernel: [drm] DMUB HPD IRQ callback: link_index=4
Sep 04 12:05:27 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Sep 04 12:05:27 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Sep 04 12:05:27 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Sep 04 12:05:27 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Sep 04 12:05:27 vighnesh-z16 kernel: [drm] DMUB HPD IRQ callback: link_index=4
Sep 04 12:05:28 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Sep 04 12:05:28 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Sep 04 12:05:28 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Sep 04 12:05:28 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Sep 04 12:05:28 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Sep 04 12:05:28 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Sep 04 12:05:28 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Sep 04 12:05:28 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Sep 04 12:05:28 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Sep 04 12:05:28 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Sep 04 12:05:28 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Sep 04 12:05:28 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Sep 04 12:05:28 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Sep 04 12:05:28 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Sep 04 12:05:29 vighnesh-z16 kernel: [drm:gfx_v11_0_hw_fini [amdgpu]] *ERROR* failed to halt cp gfx
Sep 04 12:05:29 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: MODE2 reset
Sep 04 12:05:34 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: SMU: I'm not done with your previous command: SMN_C2PMSG_66:0x00000011 SMN_C2PMSG_82:0x00000002
Sep 04 12:05:34 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: Mode2 reset failed!
Sep 04 12:05:34 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: ASIC reset failed with error, -62 for drm dev, 0000:c4:00.0
Sep 04 12:05:34 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: GPU reset succeeded, trying to resume
Sep 04 12:05:34 vighnesh-z16 kernel: [drm] PCIE GART of 512M enabled (table at 0x000000803FD00000).
Sep 04 12:05:34 vighnesh-z16 kernel: [drm] VRAM is lost due to GPU reset!
Sep 04 12:05:34 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: SMU is resuming...
Sep 04 12:05:39 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: SMU: I'm not done with your previous command: SMN_C2PMSG_66:0x00000011 SMN_C2PMSG_82:0x00000002
Sep 04 12:05:39 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: Failed to SetDriverDramAddr!
Sep 04 12:05:39 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: Failed to setup smc hw!
Sep 04 12:05:39 vighnesh-z16 kernel: [drm:amdgpu_device_ip_resume_phase2 [amdgpu]] *ERROR* resume of IP block <smu> failed -62
-- Boot ab2d56e9c14242f4917b0e9a94bb5b04 --
Sep 04 12:06:27 vighnesh-z16 kernel: Linux version 6.6.48-1-lts (linux-lts@archlinux) (gcc (GCC) 14.2.1 20240805, GNU ld (GNU Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Thu, 29 Aug 2024 17:56:14 +0000
```

```
Oct 31 15:24:34 vighnesh-z16 kernel: [drm:amdgpu_job_timedout [amdgpu]] *ERROR* ring gfx_0.0.0 timeout, signaled seq=21433650, emitted seq=21433652
Oct 31 15:24:34 vighnesh-z16 kernel: [drm:amdgpu_job_timedout [amdgpu]] *ERROR* Process information: process firefox pid 500806 thread firefox:cs0 pid 500885
Oct 31 15:24:34 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: GPU reset begin!
Oct 31 15:24:34 vighnesh-z16 kernel: [drm] DMUB HPD IRQ callback: link_index=4
Oct 31 15:24:35 vighnesh-z16 pipewire[844]: pw.node: (alsa_input.usb-Lenovo_ThinkPad_Thunderbolt_3_Dock_USB_Audio_000000000000-00.pro-input-0-111) graph xrun not-triggered (0 suppressed)
Oct 31 15:24:35 vighnesh-z16 pipewire[844]: pw.node: (alsa_input.usb-Lenovo_ThinkPad_Thunderbolt_3_Dock_USB_Audio_000000000000-00.pro-input-0-111) xrun state:0x78756cdfe008 pending:2/3 s:286361872244411 a:2863618>
Oct 31 15:24:35 vighnesh-z16 pipewire[844]: pw.node: (Firefox-126) xrun state:0x78756e779008 pending:0/1 s:286361882169303 a:286361872302691 f:286361872319503 waiting:18446744073699685004 process:16812 status:tri>
Oct 31 15:24:35 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Oct 31 15:24:35 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Oct 31 15:24:35 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Oct 31 15:24:35 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Oct 31 15:24:35 vighnesh-z16 kernel: [drm] DMUB HPD IRQ callback: link_index=4
Oct 31 15:24:36 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Oct 31 15:24:36 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Oct 31 15:24:36 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Oct 31 15:24:36 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Oct 31 15:24:36 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Oct 31 15:24:36 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Oct 31 15:24:36 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Oct 31 15:24:36 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Oct 31 15:24:36 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Oct 31 15:24:36 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Oct 31 15:24:36 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Oct 31 15:24:36 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Oct 31 15:24:36 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Oct 31 15:24:36 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Oct 31 15:24:37 vighnesh-z16 kernel: [drm:gfx_v11_0_hw_fini [amdgpu]] *ERROR* failed to halt cp gfx
Oct 31 15:24:37 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: MODE2 reset
Oct 31 15:24:41 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: SMU: I'm not done with your previous command: SMN_C2PMSG_66:0x00000011 SMN_C2PMSG_82:0x00000002
Oct 31 15:24:41 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: Mode2 reset failed!
Oct 31 15:24:41 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: ASIC reset failed with error, -62 for drm dev, 0000:c4:00.0
Oct 31 15:24:41 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: GPU reset succeeded, trying to resume
Oct 31 15:24:41 vighnesh-z16 kernel: [drm] PCIE GART of 512M enabled (table at 0x000000803FD00000).
Oct 31 15:24:41 vighnesh-z16 kernel: [drm] VRAM is lost due to GPU reset!
Oct 31 15:24:41 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: SMU is resuming...
Oct 31 15:24:46 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: SMU: I'm not done with your previous command: SMN_C2PMSG_66:0x00000011 SMN_C2PMSG_82:0x00000002
Oct 31 15:24:46 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: Failed to SetDriverDramAddr!
Oct 31 15:24:46 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: Failed to setup smc hw!
Oct 31 15:24:46 vighnesh-z16 kernel: [drm:amdgpu_device_ip_resume_phase2 [amdgpu]] *ERROR* resume of IP block <smu> failed -62
-- Boot 80fb03bcb0ba46e18734e3e44af7c4bf --
Oct 31 15:26:57 vighnesh-z16 kernel: Linux version 6.6.58-1-lts (linux-lts@archlinux) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Wed, 23 Oct 2024 17:28:15 +0000
Oct 31 15:26:57 vighnesh-z16 kernel: Command line: initrd=\amd-ucode.img initrd=\initramfs-linux-lts.img root=PARTUUID=4582d8e9-773e-4eeb-ac4a-c76ea768ff79 zswap.enabled=0 rw rootfstype=ext4
Oct 31 15:26:57 vighnesh-z16 kernel: BIOS-provided physical RAM map:
Oct 31 15:26:57 vighnesh-z16 kernel: BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
Oct 31 15:26:57 vighnesh-z16 kernel: BIOS-e820: [mem 0x0000000000100000-0x0000000009bfffff] usable
```

```
Dec 03 16:08:13 vighnesh-z16 kernel: [drm:amdgpu_job_timedout [amdgpu]] *ERROR* ring gfx_0.0.0 timeout, signaled seq=3485545, emitted seq=3485547
Dec 03 16:08:13 vighnesh-z16 kernel: [drm:amdgpu_job_timedout [amdgpu]] *ERROR* Process information: process firefox pid 1298 thread firefox:cs0 pid 1370
Dec 03 16:08:13 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: GPU reset begin!
Dec 03 16:08:13 vighnesh-z16 kernel: [drm] DMUB HPD IRQ callback: link_index=4
Dec 03 16:08:14 vighnesh-z16 kernel: [drm:amdgpu_dm_atomic_check [amdgpu]] *ERROR* [CRTC:83:crtc-1] hw_done or flip_done timed out
Dec 03 16:08:14 vighnesh-z16 kernel: [drm] DMUB HPD IRQ callback: link_index=4
Dec 03 16:08:14 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Dec 03 16:08:14 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Dec 03 16:08:14 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Dec 03 16:08:14 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Dec 03 16:08:14 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Dec 03 16:08:14 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Dec 03 16:08:15 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Dec 03 16:08:15 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Dec 03 16:08:15 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Dec 03 16:08:15 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Dec 03 16:08:15 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Dec 03 16:08:15 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Dec 03 16:08:15 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Dec 03 16:08:15 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Dec 03 16:08:15 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Dec 03 16:08:15 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Dec 03 16:08:15 vighnesh-z16 kernel: [drm:mes_v11_0_submit_pkt_and_poll_completion.constprop.0 [amdgpu]] *ERROR* MES failed to response msg=3
Dec 03 16:08:15 vighnesh-z16 kernel: [drm:amdgpu_mes_unmap_legacy_queue [amdgpu]] *ERROR* failed to unmap legacy queue
Dec 03 16:08:15 vighnesh-z16 kernel: [drm:gfx_v11_0_hw_fini [amdgpu]] *ERROR* failed to halt cp gfx
Dec 03 16:08:15 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: MODE2 reset
Dec 03 16:08:20 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: SMU: I'm not done with your previous command: SMN_C2PMSG_66:0x00000011 SMN_C2PMSG_82:0x00000002
Dec 03 16:08:20 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: Mode2 reset failed!
Dec 03 16:08:20 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: ASIC reset failed with error, -62 for drm dev, 0000:c4:00.0
Dec 03 16:08:20 vighnesh-z16 kernel: amdgpu 0000:c4:00.0: amdgpu: GPU reset succeeded, trying to resume
Dec 03 16:08:20 vighnesh-z16 kernel: [drm] PCIE GART of 512M enabled (table at 0x000000803FD00000).
Dec 03 16:08:20 vighnesh-z16 kernel: [drm] VRAM is lost due to GPU reset!
-- Boot f3d88401526b4d808e2a3d9af9520016 --
```
