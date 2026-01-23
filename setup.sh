#!/usr/bin/env bash
set -euo pipefail
set -x

# Setting up an EC2 instance with things

DOWNLOAD_DIR=$(mktemp -d)
echo "The download dir is $DOWNLOAD_DIR"

# tree-sitter for neovim
sudo rm -f /usr/local/bin/tree-sitter
curl -L https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.3/tree-sitter-linux-x64.gz >$DOWNLOAD_DIR/tree-sitter-linux-x64.gz
gunzip $DOWNLOAD_DIR/tree-sitter-linux-x64.gz
sudo mv $DOWNLOAD_DIR/tree-sitter-linux-x64 /usr/local/bin/tree-sitter
sudo chmod +x /usr/local/bin/tree-sitter

# neovim
sudo rm -f /usr/local/bin/nvim
sudo rm -rf /opt/nvim-linux-x86_64
curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz >$DOWNLOAD_DIR/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf $DOWNLOAD_DIR/nvim-linux-x86_64.tar.gz
sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

# chezmoi
sudo rm -f /usr/local/bin/chezmoi
curl -fsLS get.chezmoi.io >$DOWNLOAD_DIR/chezmoi.sh
sudo bash $DOWNLOAD_DIR/chezmoi.sh -b /usr/local/bin

# tmux
sudo rm -f /usr/local/bin/tmux
curl -L https://github.com/tmux/tmux-builds/releases/download/v3.6a/tmux-3.6a-linux-x86_64.tar.gz >$DOWNLOAD_DIR/tmux-3.6a-linux-x86_64.tar.gz
cd $DOWNLOAD_DIR && tar -xzf tmux-3.6a-linux-x86_64.tar.gz
sudo mv $DOWNLOAD_DIR/tmux /usr/local/bin/tmux

# fd
sudo rm -f /usr/local/bin/fd
curl -L https://github.com/sharkdp/fd/releases/download/v10.3.0/fd-v10.3.0-x86_64-unknown-linux-musl.tar.gz >$DOWNLOAD_DIR/fd.tar.gz
tar -xzf $DOWNLOAD_DIR/fd.tar.gz
sudo mv $DOWNLOAD_DIR/fd-v10.3.0-x86_64-unknown-linux-musl/fd /usr/local/bin/fd

# rg
sudo rm -f /usr/local/bin/rg
curl -L https://github.com/BurntSushi/ripgrep/releases/download/15.1.0/ripgrep-15.1.0-x86_64-unknown-linux-musl.tar.gz >$DOWNLOAD_DIR/rg.tar.gz
tar -xzf $DOWNLOAD_DIR/rg.tar.gz
sudo mv $DOWNLOAD_DIR/ripgrep-15.1.0-x86_64-unknown-linux-musl/rg /usr/local/bin/rg

# eza
sudo rm -f /usr/local/bin/eza
curl -L https://github.com/eza-community/eza/releases/download/v0.23.4/eza_x86_64-unknown-linux-musl.tar.gz >$DOWNLOAD_DIR/eza.tar.gz
cd $DOWNLOAD_DIR && tar -xzf eza.tar.gz
sudo mv $DOWNLOAD_DIR/eza /usr/local/bin/eza

# bat
sudo rm -f /usr/local/bin/bat
curl -L https://github.com/sharkdp/bat/releases/download/v0.26.1/bat-v0.26.1-x86_64-unknown-linux-musl.tar.gz >$DOWNLOAD_DIR/bat.tar.gz
tar -xzf $DOWNLOAD_DIR/bat.tar.gz
sudo mv $DOWNLOAD_DIR/bat-v0.26.1-x86_64-unknown-linux-musl/bat /usr/local/bin/bat

# delta
sudo rm -f /usr/local/bin/delta
curl -L https://github.com/dandavison/delta/releases/download/0.18.2/delta-0.18.2-x86_64-unknown-linux-musl.tar.gz >$DOWNLOAD_DIR/delta.tar.gz
tar -xzf $DOWNLOAD_DIR/delta.tar.gz
sudo mv $DOWNLOAD_DIR/delta-0.18.2-x86_64-unknown-linux-musl/delta /usr/local/bin/delta

# btop
sudo rm -f /usr/local/bin/btop
curl -L https://github.com/aristocratos/btop/releases/download/v1.4.6/btop-x86_64-unknown-linux-musl.tbz >$DOWNLOAD_DIR/btop.tbz
tar -xjf $DOWNLOAD_DIR/btop.tbz
sudo mv $DOWNLOAD_DIR/btop/bin/btop /usr/local/bin/btop

# fish
sudo rm -f /usr/local/bin/fish
curl -L https://github.com/fish-shell/fish-shell/releases/download/4.3.3/fish-4.3.3-linux-x86_64.tar.xz >$DOWNLOAD_DIR/fish.tar.xz
cd $DOWNLOAD_DIR && tar -xf fish.tar.xz
sudo mv $DOWNLOAD_DIR/fish /usr/local/bin/fish

# starship
sudo rm -f /usr/local/bin/starship
curl -sS https://starship.rs/install.sh >$DOWNLOAD_DIR/starship.sh
chmod +x $DOWNLOAD_DIR/starship.sh
sudo sh $DOWNLOAD_DIR/starship.sh --force

# claude code
sudo rm -f /usr/local/bin/claude
sudo rm -f /home/ubuntu/.local/bin/claude
curl -fsSL https://claude.ai/install.sh >$DOWNLOAD_DIR/install.sh
bash $DOWNLOAD_DIR/install.sh
sudo ln -s /home/ubuntu/.local/bin/claude /usr/local/bin/claude

# Install dotfiles
chezmoi purge --force
chezmoi init git@github.com:vighneshiyer/dotfiles.git
chezmoi apply -v

# Post setup
bat cache --build
curl -L https://github.com/alacritty/alacritty/releases/download/v0.16.1/alacritty.info >$DOWNLOAD_DIR/alacritty.info
tic -x $DOWNLOAD_DIR/alacritty.info
