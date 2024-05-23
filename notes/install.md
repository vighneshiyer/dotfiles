# Installing From a Fresh Machine

## Utilities

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
sudo pacman -S fish neovim eza fd ripgrep tldr bat git-delta tmux xsel alacritty rclone zathura nsxiv mpv hyperfine fdupes lazygit zathura-pdf-mupdf rsync xdg-desktop-portal xdg-desktop-portal-wlr python-jinja borg usbutils python-pipx wlsunset texlive sshfs wev tree i3status dmenu wmenu unzip npm reflector man git firefox mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver mesa-vdpau age bolt ddcutil wl-clipboard libnotify mako powertop libreoffice-fresh noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra dmidecode rustup cups cups-pdf cups-pk-helper system-config-printer linux-lts zola remmina freerdp inkscape yt-dlp jdk-openjdk openjdk-src udftools lsof python-joblib tree-sitter-cli obs-studio dart-sass lld sshuttle kicad
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
