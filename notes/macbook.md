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
  - `brew install fish btop zoxide neovim rsync git eza fd bat git-delta tmux ripgrep tlrc zellij tree rclone fdupes zola hyperfine restic uv python pipx tree-sitter tree-sitter-cli typst starship dust node openjdk zig` (CLI programs)
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

## Caveats

- Homebrew's installation does not include the `mount` subcommand on macOS which depends on FUSE, use `nfsmount` instead.

## Mac Issues

I'll document things I encounter.

On 12/4/2025, when I opened the lid, the computer was off and actually ended up rebooting. It showed an error message "SOCD report detected (iBoot async abort)". Quite worrying that the uptime is so bad (only a few days). This could be a hardware fault, so I should keep watching.
