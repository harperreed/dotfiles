# ABOUTME: Manages SSH agent initialization and key loading
# ABOUTME: Handles both local terminal and SSH forwarding scenarios

# Function to add SSH keys on Darwin/macOS
function add_ssh_keys_darwin --on-variable SSH_AUTH_SOCK
    set -l lolcat_cmd (command -v lolcat)
    if test -n "$SSH_TTY"
        # Connected via SSH
        echo
        echo "🔒 Connected via SSH. Using SSH agent forwarding." | $lolcat_cmd
        echo
    else if test -n "$SSH_CONNECTION"
        # Connected via SSH but without a TTY (e.g., in a script)
        # Silent mode - no output
    else
        # On a physical terminal
        echo
        echo "💻 On physical terminal. Adding local SSH keys." | $lolcat_cmd
        echo
        ssh-add --apple-use-keychain ~/.ssh/id_rsa 2>/dev/null
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
    end
end

# Start ssh-agent if it's not already running
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

# Platform-specific SSH key loading
switch (uname)
    case Darwin
        add_ssh_keys_darwin
end