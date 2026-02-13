# SSH agent socket symlink for tmux persistence
# When SSH-forwarded, create a stable symlink so tmux sessions survive reconnects
if [[ -n "$SSH_CONNECTION" && -n "$SSH_AUTH_SOCK" && -S "$SSH_AUTH_SOCK" ]]; then
    _stable_sock="$HOME/.ssh/agent_sock"
    if [[ "$SSH_AUTH_SOCK" != "$_stable_sock" ]]; then
        ln -sf "$SSH_AUTH_SOCK" "$_stable_sock" 2>/dev/null
        export SSH_AUTH_SOCK="$_stable_sock"
    fi
    unset _stable_sock
fi

alias godot="/Applications/Godot.app/Contents/MacOS/Godot"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/harper/.lmstudio/bin"
# End of LM Studio CLI section


. "$HOME/.local/share/../bin/env"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"

# OpenClaw Completion
source <(openclaw completion --shell zsh)
export PATH="$HOME/.local/bin:$PATH"
