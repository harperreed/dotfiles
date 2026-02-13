# ABOUTME: Custom greeting function for fish shell
# ABOUTME: Displays hostname with figlet and fortune on startup

# Custom greeting
function fish_greeting
    echo
    # Minimal greeting in tmux
    if set -q TMUX
        command fortune | lolcat
        # Check keychain status in SSH sessions (macOS only)
        if test (uname) = "Darwin"
            if set -q SSH_CONNECTION; or set -q SSH_TTY
                _check_keychain_status
            end
        end
	echo
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
    echo
    # show-keychain-info returns immediately (no timeout needed) and outputs to stderr
    if security show-keychain-info login.keychain-db 2>/dev/null
        echo (set_color green)"🔓 ✨ Keychain unlocked ✨"(set_color normal)
    else
        echo (set_color red)"🔒 ⚠️  WARNING: Keychain is locked!  ⚠️"(set_color normal)
        echo (set_color yellow)"   💡 Run 'unlock.sh' to unlock it"(set_color normal)
    end
end
