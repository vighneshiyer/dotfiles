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
