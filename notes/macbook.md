# Macbook Setup

Update to latest version of Sequoia.
Don't bother updating to Tahoe.

- `sudo scutil --set HostName <desired host name>` ([make sure your hostname is fixed](https://superuser.com/questions/639691/why-does-my-network-set-my-hostname-how-can-i-stop-this))

1. Remap caps lock to escape
1. Install Homebrew (it will also install xcode tools)
1. Install chezmoi
1. Unpack ssh keys via chezmoi
1. Install software via brew
  - `brew install fish btop zoxide neovim rsync git eza fd bat git-delta tmux ripgrep tlrc zellij tree rclone fdupes zola hyperfine restic uv python tree-sitter tree-sitter-cli typst starship` (CLI programs)
  - `brew install --cask font-sauce-code-pro-nerd-font font-noto-sans font-noto-sans-display font-noto-sans-math font-noto-sans-symbols font-noto-sans-symbols-2` (fonts)
  - `brew install --cask firefox gimp alacritty inkscape` (graphical programs)
  - `brew install --cask nikitabobko/tap/aerospace` (window manager)
  - `brew tap macos-fuse-t/homebrew-cask` (FUSE-T)
    - `brew install fuse-t fuse-t-sshfs`
  - `brew tap FelixKratz/formulae` ([JankyBorders](https://github.com/FelixKratz/JankyBorders))
    - `brew install borders`
1. Configure dotfiles for alacritty (TN colorscheme check, check other Alacritty options)
1. Configure dotfiles (colorscheme, cache) for bat
1. Configure dotfiles for fish (PATH, starship)
1. Configure dotfiles for neovim
1. Configure aerospace
    - [x] aerospace config
    - [x] Alan.App / JankyBorders
    - [ ] Scratchpads
1. Firefox plugins: Bitwarden, UBlock Origin, Vimium, ~~Sidebery~~ (no longer needed due to native vertical tab support in Firefox)
1. Logins: Email (+ Calendar + Keep), Github, Amazon
1. Install: Signal, Slack, KKT
1. Clone repos: website, notes, research-notes, sim-notes, pubs, backup
1. Today
1. Install VSCode
1. Adjust keyboard repeat rate + delay (https://apple.stackexchange.com/questions/10467/how-to-increase-keyboard-key-repeat-rate-on-os-x)

Caveats:

Homebrew's installation does not include the `mount` subcommand on macOS which depends on FUSE, use `nfsmount` instead.
