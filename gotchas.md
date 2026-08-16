# gotchas

Hard-won facts about this $HOME / dotfiles setup. Add entries; don't regenerate the file.

- **Fish config is fleet-shared; target fish 3.7.** yadm syncs `~/.config/fish` to the exe.dev VM (`harper.exe.xyz`), which runs fish 3.7.0 from Ubuntu 24.04 — the Mac's Homebrew fish (4.7+) accepts flags 3.7 doesn't (e.g. `argparse -S/--strict-longopts`, added in fish 4.1). Check `/opt/homebrew/Cellar/fish/<ver>/CHANGELOG.rst` before using shiny argparse/string features in shared functions.
