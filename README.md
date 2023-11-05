# Dotfiles

- Managed using [chezmoi](https://www.chezmoi.io/)
- Install with `sh -c "$(curl -fsLS get.chezmoi.io)"`
- Configure `~/.config/chezmoi/chezmoi.toml` as:

```toml
encryption = "gpg"
[gpg]
    symmetric = true
```

- On any machine run `chezmoi init https://github.com/vighneshiyer/dotfiles.git`
