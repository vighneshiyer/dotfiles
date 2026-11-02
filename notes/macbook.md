# Macbook Setup

Update to latest version of Sequoia.
Don't bother updating to Tahoe.

## System Settings Setup

- System Settings -> Spotlight search categories -> Uncheck all boxes except "Applications" and "System Settings" -> Uncheck "Help Apple Improve Search"
- System Settings -> Show spotlight in menu bar -> Don't show
- System Settings -> Customize modifier keys -> Set Caps Lock to Escape
- System Settings -> Keyboard shortcuts -> App Shortcuts -> "Find in Page..." -> Ctrl-F
- System Settings -> Keyboard shortcuts -> App Shortcuts -> "Find..." -> Ctrl-F
- System Settings -> Time and Date -> Use 24 hour clock on menubar
- System Settings -> Control Center -> Don't show Wifi / Now Playing on menubar + don't show day of week
- `sudo scutil --set HostName <desired host name>` ([make sure your hostname is fixed](https://superuser.com/questions/639691/why-does-my-network-set-my-hostname-how-can-i-stop-this))
- `defaults write org.alacritty AppleFontSmoothing -int 0` ([improve font rendering on Alacritty](https://github.com/alacritty/alacritty/issues/7333))
- `defaults write -g NSWindowShouldDragOnGesture -bool true` ([move windows by dragging with Cmd+Ctrl](https://nikitabobko.github.io/AeroSpace/goodies#move-by-dragging-any-part-of-the-window))
- `defaults write -g NSAutomaticWindowAnimationsEnabled -bool false` ([disable window open animations](https://nikitabobko.github.io/AeroSpace/goodies#disable-open-animations))
- Toggle on "Reduce Motion" in System Settings
- `defaults write -g InitialKeyRepeat -float 10.0` (key repeat initial delay)
- `defaults write -g KeyRepeat -float 1.0` (key repeat frequency)
- `defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false` (disable press and hold nonsense)

## Software Installation

1. Install Homebrew (it will also install xcode tools)
1. Install chezmoi
1. Unpack ssh keys via chezmoi
1. Install software via brew
  - `brew install fish btop zoxide neovim rsync git eza fd bat git-delta tmux ripgrep tlrc zellij tree rclone fdupes zola hyperfine restic uv python pipx tree-sitter tree-sitter-cli typst starship dust node openjdk zig go yt-dlp` (CLI programs)
  - `brew install --cask font-sauce-code-pro-nerd-font font-noto-sans font-noto-sans-display font-noto-sans-math font-noto-sans-symbols font-noto-sans-symbols-2` (fonts)
  - `brew install --cask firefox gimp alacritty inkscape spotify` (GUI programs)
  - `brew install --cask nikitabobko/tap/aerospace` (window manager)
  - `brew tap macos-fuse-t/homebrew-cask` (FUSE-T) +  `brew install fuse-t fuse-t-sshfs`
  - `brew tap FelixKratz/formulae` ([JankyBorders](https://github.com/FelixKratz/JankyBorders)) + `brew install borders`
  - `brew install cristianoliveira/tap/aerospace-scratchpad` ([aerospace-scratchpad](https://github.com/cristianoliveira/aerospace-scratchpad))
  - `brew install --cask signal slack` (communication programs)
  - `brew install --cask cursor-cli visual-studio-code` (programming tools)
1. Configure dotfiles for alacritty
1. Configure dotfiles for bat (rebuild colorscheme cache)
1. Configure dotfiles for fish
1. Configure dotfiles for neovim
1. Configure aerospace (`aerospace.toml`, Alan.App / JankyBorders, aerospace-scratchpad, open shell from PWD)
1. Firefox plugins: Bitwarden, UBlock Origin, Vimium, ~~Sidebery~~ (no longer needed due to native vertical tab support in Firefox)
  - about:config -> `uidensity` -> set to 1 (for maximum compactness)
  - about:config -> `media.videocontrols.picture-in-picture.video-toggle.enabled` -> set to false (disable PIP popup)
  - about:config -> `browser.download.open_pdf_attachments_inline` -> set to true (enable opening PDFs in Firefox from the CLI)
  - Settings -> Privacy & Security -> Passwords -> uncheck all boxes (disable Firefox password, payment, and address manager)
1. Logins: Email (+ Calendar + Keep), Github, Amazon, ChatGPT
1. Install: Signal, Slack, KKT (via app store)
1. Clone repos: website, notes, research-notes, sim-notes, pubs, backup, today
1. Install today with `pipx`
1. Install and configure VSCode
  - Extensions: vim, ssh, augment, c++, tokyo night, excalidraw
1. Install `rustup`
1. Install `mill` ([Install script](https://mill-build.org/mill/cli/installation-ide.html#_global_installation))
1. Configure SwiftBar
  - `brew install swiftbar`. Launch SwiftBar. Set plugin folder to `~/.config/swiftbar` (use Cmd+Shift+Period to show hidden files in Finder).
1. System Settings -> Privacy & Security -> Developer Tools -> add Alacritty and Aerospace

## Caveats

- Homebrew's installation does not include the `mount` subcommand on macOS which depends on FUSE, use `nfsmount` instead.

## Mac Issues

I'll document things I encounter.

On 12/4/2025, when I opened the lid, the computer was off and actually ended up rebooting. It showed an error message "SOCD report detected (iBoot async abort)". Quite worrying that the uptime is so bad (only a few days). This could be a hardware fault, so I should keep watching.

## Remote Dev Box (vighnesh-macbook-pax)

Accessed over Tailscale + SSH (Remote Login on). chezmoi handles most of it, gated on this hostname:

- `~/.local/bin/devstate` + `~/Library/LaunchAgents/local.devstate.snapshot.plist`: snapshots terminals (cwd, foreground job), AeroSpace workspaces/windows, tmux, Claude Code sessions every 5 min to `~/.local/state/devstate/`
  - `devstate` (live), `devstate recover` (last snapshot before this boot), `devstate restore` (script to rebuild tmux/terminals/claude sessions), `devstate history`, `devstate show --at 14:00`
- `run_onchange_after_devbox-system.sh` (sudo, on `chezmoi apply`): `pmset` never-sleep + autorestart, and the `netwatch` LaunchDaemon (`devbox/netwatch.sh` → `/usr/local/sbin/netwatch`, log in `/var/log/netwatch.log`)
  - netwatch pings every 2 min; if the gateway is unreachable it power-cycles Wi-Fi with backoff; it only reboots after 30 min down + 3 failed fixes, at most once per 12h, and never while FileVault is on

Manual steps:

- Tailscale admin console → this machine → Disable key expiry (otherwise remote access dies when the node key expires)
- Tailscale app → Settings → Launch at login
- Plug in the USB 2.5G Ethernet adapter (en7) and keep Wi-Fi as the fallback; Ethernet should sit above Wi-Fi in Network → Service Order
- System Settings → Battery → Options → Prevent automatic sleeping on power adapter when the display is off
- Keep the lid open (clamshell needs an external display + power)
- FileVault: while it is on, any panic/reboot leaves the Mac at the pre-boot unlock screen until someone types the password. Planned reboots: `sudo fdesetup authrestart`.

On 10/28/2026 ~02:00 it kernel panicked ("AOP crash of unknown type 0x9") and auto-rebooted, then sat at the FileVault screen until ~14:20.
