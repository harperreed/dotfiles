# dotfiles

Personal dotfiles for macOS and Arch Linux, managed with [yadm](https://yadm.io).

## What's in here

- fish shell config (`.config/fish/`)
- git config and global hooks (`.gitconfig`, `.git_hooks/`)
- macOS defaults (`.config/macos/set-defaults.sh`) and Hammerspoon (`.hammerspoon/`)
- Hyprland/waybar for the Arch laptop (`.config/hypr/`, `.config/waybar/`)
- agent configs: Claude Code (`.claude/`) and Codex (`.codex/`)
- SSH client hardening (`.ssh/config`)

## Setup

```sh
yadm clone git@github.com:harperreed/dotfiles.git
yadm bootstrap
```

Bootstrap is platform-aware: `.config/yadm/bootstrap` dispatches to
`.config/yadm/bootstrap.d/{common,darwin,linux}.sh`.

## Note

These are one person's living configs, not a framework. Borrow whatever is
useful, but don't install them blind.

## License

MIT — see [LICENSE](LICENSE).
