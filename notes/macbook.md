# Macbook Setup

Update to latest version of Sequoia.
Don't bother updating to Tahoe.

- `sudo scutil --set HostName <desired host name>` ([make sure your hostname is fixed](https://superuser.com/questions/639691/why-does-my-network-set-my-hostname-how-can-i-stop-this))
- `defaults write org.alacritty AppleFontSmoothing -int 0` ([improve font rendering on Alacritty](https://github.com/alacritty/alacritty/issues/7333))
- `defaults write -g NSWindowShouldDragOnGesture -bool true` ([move windows by dragging with Cmd+Ctrl](https://nikitabobko.github.io/AeroSpace/goodies#move-by-dragging-any-part-of-the-window))
- `defaults write -g NSAutomaticWindowAnimationsEnabled -bool false` ([disable window open animations](https://nikitabobko.github.io/AeroSpace/goodies#disable-open-animations))
- Toggle on "Reduce Motion" in System Settings
- `defaults write -g InitialKeyRepeat -float 10.0` (key repeat initial delay)
- `defaults write -g KeyRepeat -float 1.0` (key repeat frequency)

1. Remap caps lock to escape
1. Install Homebrew (it will also install xcode tools)
1. Install chezmoi
1. Unpack ssh keys via chezmoi
1. Install software via brew
  - `brew install fish btop zoxide neovim rsync git eza fd bat git-delta tmux ripgrep tlrc zellij tree rclone fdupes zola hyperfine restic uv python pipx tree-sitter tree-sitter-cli typst starship dust` (CLI programs)
  - `brew install --cask font-sauce-code-pro-nerd-font font-noto-sans font-noto-sans-display font-noto-sans-math font-noto-sans-symbols font-noto-sans-symbols-2` (fonts)
  - `brew install --cask firefox gimp alacritty inkscape` (graphical programs)
  - `brew install --cask nikitabobko/tap/aerospace` (window manager)
  - `brew tap macos-fuse-t/homebrew-cask` (FUSE-T)
    - `brew install fuse-t fuse-t-sshfs`
  - `brew tap FelixKratz/formulae` ([JankyBorders](https://github.com/FelixKratz/JankyBorders))
    - `brew install borders`
  - `brew install cristianoliveira/tap/aerospace-scratchpad` ([aerospace-scratchpad](https://github.com/cristianoliveira/aerospace-scratchpad))
  - `brew install --cask signal slack` (communication programs)
1. Configure dotfiles for alacritty (TN colorscheme check, check other Alacritty options)
1. Configure dotfiles (colorscheme, cache) for bat
1. Configure dotfiles for fish (PATH, starship)
1. Configure dotfiles for neovim
1. Configure aerospace
    - [x] aerospace config
    - [x] Alan.App / JankyBorders
    - [x] Scratchpads
    - [x] Open shell from PWD
1. Firefox plugins: Bitwarden, UBlock Origin, Vimium, ~~Sidebery~~ (no longer needed due to native vertical tab support in Firefox)
  - about:config -> uidensity -> set to 1 (for maximum compactness)
  - Settings -> Privacy & Security -> Passwords -> uncheck all boxes (disable Firefox password, payment, and address manager)
1. Logins: Email (+ Calendar + Keep), Github, Amazon, ChatGPT
1. Install: Signal, Slack, KKT (via app store)
1. Clone repos: website, notes, research-notes, sim-notes, pubs, backup
1. Cursor agent
1. Today (use Cursor)
  - Need to ignore missing symlinks instead of failing
  - Need to patch dost task symlink for the time being
1. Install VSCode
1. Configure Sketchybar
  - https://nikitabobko.github.io/AeroSpace/goodies#show-aerospace-workspaces-in-sketchybar
1. Mount remote restic archives
  - Rclone mount + restic mount for regular filesystem
  - Direct Restic mount for cold filesystem

Caveats:

Homebrew's installation does not include the `mount` subcommand on macOS which depends on FUSE, use `nfsmount` instead.
