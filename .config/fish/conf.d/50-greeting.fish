# ABOUTME: Custom greeting function for fish shell
# ABOUTME: Displays hostname with figlet and fortune on startup

# Custom greeting
function fish_greeting
    # Minimal greeting in tmux
    if set -q TMUX
        command fortune | lolcat
        # Check keychain status in SSH sessions (macOS only)
        if test (uname) = "Darwin"
            if set -q SSH_CONNECTION; or set -q SSH_TTY
                _check_keychain_status
            end
        end
        return
    end

    set -l hostname_cmd (command -v hostname)
    set -l figlet_cmd (command -v figlet)
    set -l lolcat_cmd (command -v lolcat)

    if test -n "$hostname_cmd" -a -n "$figlet_cmd" -a -n "$lolcat_cmd"
        # Use command to bypass any GRC wrappers
        command $hostname_cmd -s | command $figlet_cmd -w 100 -f ~/.config/fonts/Bloody.flf | $lolcat_cmd
        command fortune | $lolcat_cmd
    else
        echo "Welcome!"
    end

    # Check keychain status in SSH sessions (macOS only)
    if test (uname) = "Darwin"
        if set -q SSH_CONNECTION; or set -q SSH_TTY
            _check_keychain_status
        end
    end

    echo
end

# Helper function to check keychain status
function _check_keychain_status
    # Use gtimeout if available, fallback to timeout, or just security command
    set -l timeout_cmd ""
    if command -v gtimeout >/dev/null 2>&1
        set timeout_cmd "gtimeout 1"
    else if command -v timeout >/dev/null 2>&1
        set timeout_cmd "timeout 1"
    end

    if test -n "$timeout_cmd"
        if eval $timeout_cmd security show-keychain-info >/dev/null 2>&1
            echo (set_color green)"🔓 ✨ Keychain unlocked"(set_color normal)
        else
            echo (set_color red)"🔒 ⚠️  WARNING: Keychain is locked!"(set_color normal)
            echo (set_color yellow)"   💡 Run 'unlock.sh' to unlock it"(set_color normal)
        end
    else
        # Fallback without timeout - use a quick check
        if security show-keychain-info >/dev/null 2>&1
            echo (set_color green)"🔓 ✨ Keychain unlocked"(set_color normal)
        else
            echo (set_color red)"🔒 ⚠️  WARNING: Keychain might be locked!"(set_color normal)
            echo (set_color yellow)"   💡 Run 'unlock.sh' to check"(set_color normal)
        end
    end
end