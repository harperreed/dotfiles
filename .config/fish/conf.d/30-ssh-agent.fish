# ABOUTME: Manages SSH agent initialization and key loading
# ABOUTME: Handles both local terminal and SSH forwarding scenarios
# 30-ssh-agent.fish
# Robust SSH agent setup for fish (macOS-aware). No universal vars. No races.
# Behavior:
#  - If a valid SSH_AUTH_SOCK exists, keep it.
#  - Else on macOS, try launchd's socket.
#  - Else start a local agent (fish-native parsing).
#  - Auto-add keys locally (not when connected over SSH).
#  - Keys come from $SSH_KEYS or default to id_ed25519/id_rsa if present.

function __ssh_agent__valid --description 'Return 0 if SSH_AUTH_SOCK is a valid socket'
    if set -q SSH_AUTH_SOCK; and test -S "$SSH_AUTH_SOCK"
        return 0
    end
    return 1
end

function __ssh_agent__from_launchd --description 'Try to adopt launchd-managed agent (macOS)'
    if test (uname) = "Darwin"
        set -l sock (launchctl getenv SSH_AUTH_SOCK)
        if test -n "$sock"; and test -S "$sock"
            set -gx SSH_AUTH_SOCK "$sock"
            # SSH_AGENT_PID is not needed with launchd; do not set it.
            return 0
        end
    end
    return 1
end

function __ssh_agent__start --description 'Start a fresh agent and export vars (fish-parse sh output)'
    for line in (ssh-agent -s | string split \n)
        if string match -rq 'SSH_AUTH_SOCK=' -- "$line"
            set -gx SSH_AUTH_SOCK (string replace -r '.*SSH_AUTH_SOCK=([^;]+);.*' '$1' -- "$line")
        else if string match -rq 'SSH_AGENT_PID=' -- "$line"
            set -gx SSH_AGENT_PID (string replace -r '.*SSH_AGENT_PID=([0-9]+);.*' '$1' -- "$line")
        end
    end
end

function __ssh_agent__ensure --description 'Ensure a valid agent socket is available'
    __ssh_agent__valid; and return 0
    __ssh_agent__from_launchd; and return 0
    __ssh_agent__start
end

function __ssh_agent__add_keys --description 'Add local keys to the agent (macOS keychain aware)'
    # Only add keys on a local TTY (don’t mess with forwarded remote sessions)
    if set -q SSH_CONNECTION
        return 0
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
    if test (uname) = "Darwin"
        for k in $keys
            ssh-add --apple-use-keychain $k ^/dev/null 2>/dev/null
        end
    else
        for k in $keys
            ssh-add $k ^/dev/null 2>/dev/null
        end
    end
end

# ---- Main flow ----
__ssh_agent__ensure
__ssh_agent__valid; and __ssh_agent__add_keys

