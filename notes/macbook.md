# Macbook Setup

Update to latest version of Sequoia.
Don't bother updating to Tahoe.

## System Settings Setup

- Remap caps lock to escape in System Settings
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
  - `brew install fish btop zoxide neovim rsync git eza fd bat git-delta tmux ripgrep tlrc zellij tree rclone fdupes zola hyperfine restic uv python pipx tree-sitter tree-sitter-cli typst starship dust node openjdk` (CLI programs)
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
  - about:config -> uidensity -> set to 1 (for maximum compactness)
  - Settings -> Privacy & Security -> Passwords -> uncheck all boxes (disable Firefox password, payment, and address manager)
1. Logins: Email (+ Calendar + Keep), Github, Amazon, ChatGPT
1. Install: Signal, Slack, KKT (via app store)
1. Clone repos: website, notes, research-notes, sim-notes, pubs, backup, today
1. Install today with `pipx`
1. Install and configure VSCode
  - Extensions: vim, ssh, augment, c++, tokyo night, excalidraw
1. Install `rustup`
1. Install `mill` ([Install script](https://mill-build.org/mill/cli/installation-ide.html#_global_installation))

## Extras

- [x] Figure out how to center floating windows in the current workspace
  - Alacritty scratchpad windows
  - https://github.com/nikitabobko/AeroSpace/discussions/633
  - It seems the best way is to use a tiny Swift app that can be run whenever the window is detected
  - Write a swift app in ~/.local/bin, versioned by chezmoi. It should be called by aerospace when an Alacritty scratchpad is detected. It should resize the currently focused window  to the dimensions requested and center it. Make this dynamic based on the resolution + dpi scaling of the monitor the workspace is on.
  - This actually seems impossible, let's just not bother with it.
  - I tried various Swift approaches, but they all failed with Alacritty, perhaps due to its decoration-free windows. Or the accessibility permissions weren't enough. Or whatever. And Raycast requires a "Pro" membership to use its window manipulation functionality. Just no more, resize these windows by hand for now until aerospace supports floating window manipulation natively.
- [x] Firefox launch hotkeys
- [ ] Mount remote restic archives
  - Rclone mount + restic mount for regular filesystem
  - Direct Restic mount for cold filesystem
- [ ] Configure Sketchybar
  - https://nikitabobko.github.io/AeroSpace/goodies#show-aerospace-workspaces-in-sketchybar
- [ ] Add today (start) integration into SketchyBar
- [ ] Add timer integration into SketchyBar

## Caveats

- Homebrew's installation does not include the `mount` subcommand on macOS which depends on FUSE, use `nfsmount` instead.

## Mac Issues

I'll document things I encounter.

On 12/4/2025, when I opened the lid, the computer was off and actually ended up rebooting. It showed an error message "SOCD report detected (iBoot async abort)". Quite worrying that the uptime is so bad (only a few days). This could be a hardware fault, so I should keep watching.
