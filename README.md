# Dotfiles

- Managed using [chezmoi](https://www.chezmoi.io/)
- Install with `sh -c "$(curl -fsLS get.chezmoi.io)"`
- If you're SSH-ing to the machine being configured, disable GUI-based GPG passphrase entry
    - Add this line (`pinentry-program /usr/bin/pinentry-curses`) to `~/.gnupg/gpg-agent.conf`
    - Run `gpg-connect-agent reloadagent /bye`
- On any machine run `chezmoi init https://github.com/vighneshiyer/dotfiles.git`
- Run `chezmoi diff` and if it looks good, `chezmoi apply -v`
- Check managed files with `chezmoi managed`
