# ABOUTME: Manages SSH agent initialization and key loading
# ABOUTME: Handles both local terminal and SSH forwarding scenarios
# 30-ssh-agent.fish
# Robust SSH agent setup for fish (macOS-aware).
# Uses a stable socket path (~/.ssh/agent_sock) so all fish processes
# share one agent. Only spawns a new agent when the stable socket is dead.
# Behavior:
#  - If SSH_AUTH_SOCK is already valid, keep it (forwarded sessions, etc.)
#  - Else check the stable socket (~/.ssh/agent_sock) for a running agent
#  - Else on macOS, try launchd's socket
#  - Else start a local agent, writing its socket to the stable path
#  - Auto-add keys locally (not when connected over SSH)
#  - Keys come from $SSH_KEYS or default to id_ed25519/id_rsa if present

set -g __ssh_agent_stable_sock "$HOME/.ssh/agent_sock"

function __ssh_agent__valid --description 'Return 0 if SSH_AUTH_SOCK is a valid socket'
    if set -q SSH_AUTH_SOCK; and test -S "$SSH_AUTH_SOCK"
        return 0
    end
    return 1
end

function __ssh_agent__from_stable --description 'Try to adopt the shared stable socket'
    if test -S "$__ssh_agent_stable_sock"
        set -gx SSH_AUTH_SOCK "$__ssh_agent_stable_sock"
        # Verify the agent behind the socket is alive
        # ssh-add -l exits 0 (keys listed) or 1 (no keys) when agent is reachable,
        # exits 2 when the agent is not reachable
        ssh-add -l >/dev/null 2>&1
        set -l agent_status $status
        if test $agent_status -le 1
            return 0
        end
        # Socket exists but agent is dead — clean it up
        rm -f "$__ssh_agent_stable_sock"
        set -e SSH_AUTH_SOCK
    end
    return 1
end

function __ssh_agent__symlink --description 'Create stable symlink for tmux persistence'
    # Only do this for forwarded SSH sessions (where socket path changes on reconnect)
    if not set -q SSH_CONNECTION
        return 0
    end

    # If already using the stable path, nothing to do
    if test "$SSH_AUTH_SOCK" = "$__ssh_agent_stable_sock"
        return 0
    end

    # If we have a valid socket, symlink it to the stable path
    if test -S "$SSH_AUTH_SOCK"
        ln -sf "$SSH_AUTH_SOCK" "$__ssh_agent_stable_sock" 2>/dev/null
        set -gx SSH_AUTH_SOCK "$__ssh_agent_stable_sock"
    end
end

function __ssh_agent__from_launchd --description 'Try to adopt launchd-managed agent (macOS)'
    if test (uname) = "Darwin"
        set -l sock (launchctl getenv SSH_AUTH_SOCK)
        if test -n "$sock"; and test -S "$sock"
            set -gx SSH_AUTH_SOCK "$sock"
            # Point the stable socket here too so other shells find it
            ln -sf "$sock" "$__ssh_agent_stable_sock" 2>/dev/null
            return 0
        end
    end
    return 1
end

function __ssh_agent__start --description 'Start a fresh agent and point stable socket to it'
    for line in (ssh-agent -s | string split \n)
        if string match -rq 'SSH_AUTH_SOCK=' -- "$line"
            set -gx SSH_AUTH_SOCK (string replace -r '.*SSH_AUTH_SOCK=([^;]+);.*' '$1' -- "$line")
        else if string match -rq 'SSH_AGENT_PID=' -- "$line"
            set -gx SSH_AGENT_PID (string replace -r '.*SSH_AGENT_PID=([0-9]+);.*' '$1' -- "$line")
        end
    end
    # Point stable socket to the new agent so other shells reuse it
    if test -S "$SSH_AUTH_SOCK"
        ln -sf "$SSH_AUTH_SOCK" "$__ssh_agent_stable_sock" 2>/dev/null
        set -gx SSH_AUTH_SOCK "$__ssh_agent_stable_sock"
    end
end

function __ssh_agent__ensure --description 'Ensure a valid agent socket is available'
    __ssh_agent__valid; and return 0
    __ssh_agent__from_stable; and return 0
    __ssh_agent__from_launchd; and return 0
    __ssh_agent__start
end

function __ssh_agent__add_keys --description 'Add local keys to the agent (macOS keychain aware)'
    # Only add keys on a local TTY (don't mess with forwarded remote sessions)
    if set -q SSH_CONNECTION
        return 0
    end

    # Get list of fingerprints already in the agent (field 2 of ssh-add -l output)
    set -l loaded
    for line in (ssh-add -l 2>/dev/null)
        set -a loaded (string split ' ' -- $line)[2]
    end

    # Build key list: $SSH_KEYS takes precedence, else common defaults if they exist.
    set -l keys
    if set -q SSH_KEYS
        set keys $SSH_KEYS
    else
        for cand in ~/.ssh/id_ed25519 ~/.ssh/id_rsa
            test -f $cand; and set -a keys $cand
        end
    end
    test (count $keys) -eq 0; and return 0

    # Add each key; on macOS use Keychain integration.
    # Skip keys already loaded in the agent.
    for k in $keys
        # Get the public key fingerprint to compare
        set -l pubkey "$k.pub"
        if test -f "$pubkey"
            set -l fp (ssh-keygen -lf "$pubkey" 2>/dev/null | string split ' ')[2]
            if contains -- "$fp" $loaded
                continue
            end
        end

        if test (uname) = "Darwin"
            ssh-add --apple-use-keychain $k 2>/dev/null
        else
            ssh-add $k 2>/dev/null
        end
    end
end

# ---- Main flow ----
__ssh_agent__ensure
__ssh_agent__symlink
__ssh_agent__valid; and __ssh_agent__add_keys

