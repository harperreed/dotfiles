# ABOUTME: Blink Shell specific optimizations for mobile terminal experience
# ABOUTME: Handles environment detection, compact prompts, and performance toggles

### BLINK SHELL DETECTION ###

# Detect if we're running in Blink Shell
function is_blink
    # Blink sets TERM_PROGRAM=Blink
    test "$TERM_PROGRAM" = "Blink"
end

# Detect if we're on iOS (Blink's platform)
function is_ios
    test (uname) = "Darwin"; and test (uname -m) = "arm64"; and is_blink
end

### PERFORMANCE TOGGLES ###

# Global variable to control heavy operations (git status, etc)
set -g BLINK_FAST_MODE 0

# Toggle fast mode for slow connections
function blink_fast
    if test $BLINK_FAST_MODE -eq 0
        set -g BLINK_FAST_MODE 1
        echo "⚡ Fast mode enabled - git checks disabled"
    else
        set -g BLINK_FAST_MODE 0
        echo "🐢 Normal mode - all features enabled"
    end
end

# Auto-enable fast mode if connection is slow (optional)
function blink_auto_fast
    # Could check SSH_CONNECTION latency here
    # For now, manual toggle only
end

### COMPACT PROMPT FOR BLINK ###

# Ultra-compact single-line prompt optimized for mobile
if is_blink
    function fish_prompt
        set -l last_status $status

        # Build prompt in one line: [env] [user@]host:dir [git] >
        set -l prompt_parts ""

        # Virtual env (ultra compact)
        if set -q VIRTUAL_ENV
            set_color blue
            echo -n (basename "$VIRTUAL_ENV" | string sub -l 8)":"
            set_color normal
        end

        # User@host (only in SSH, ultra short)
        if set -q SSH_CLIENT; or set -q SSH_TTY
            set_color yellow
            echo -n (hostname -s | string sub -l 8)":"
            set_color normal
        end

        # Current directory (just basename, with ~ for home)
        set_color cyan
        set -l cwd (pwd)
        if test "$cwd" = "$HOME"
            echo -n "~"
        else
            echo -n (basename $cwd)
        end
        set_color normal

        # Git branch (only if not in fast mode, ultra compact)
        if test $BLINK_FAST_MODE -eq 0
            if command -q git; and git rev-parse --is-inside-work-tree >/dev/null 2>&1
                set -l branch (git symbolic-ref --short HEAD 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null)
                # Quick dirty check
                if not git diff-index --quiet HEAD -- 2>/dev/null
                    set_color yellow
                    echo -n " "(string sub -l 8 $branch)"*"
                else
                    set_color magenta
                    echo -n " "(string sub -l 8 $branch)
                end
                set_color normal
            end
        end

        # Prompt symbol (red on error, green on success)
        if test $last_status -eq 0
            set_color green
            echo -n " > "
        else
            set_color red
            echo -n " [$last_status] > "
        end
        set_color normal
    end

    # Disable right prompt completely
    function fish_right_prompt
    end
end

### BLINK-SPECIFIC ALIASES & ABBREVIATIONS ###

if is_blink
    # Quick tmux session management
    abbr -a t 'tmux attach -t'
    abbr -a tn 'tmux new -s'
    abbr -a tl 'tmux list-sessions'

    # Shorter mosh command
    abbr -a m 'mosh'

    # Quick reconnect to last host (stored in a variable)
    function mlast
        if set -q BLINK_LAST_HOST
            echo "Reconnecting to $BLINK_LAST_HOST..."
            mosh $BLINK_LAST_HOST -- tmux attach
        else
            echo "No previous host stored. Use 'msave hostname' first."
        end
    end

    function msave
        if test (count $argv) -lt 1
            echo "usage: msave <hostname>"
            return 1
        end
        set -Ux BLINK_LAST_HOST $argv[1]
        echo "Saved $argv[1] as last host"
    end
end

### TOUCH-FRIENDLY HELPERS ###

if is_blink
    # Larger history for better search
    set -g fish_history_size 50000

    # More aggressive completion caching
    set -g fish_complete_cache_enabled 1

    # Disable greeting on mobile (save space)
    set -g fish_greeting
end

### CLIPBOARD INTEGRATION ###

if is_blink
    # Blink has pasteboard integration via pbcopy/pbpaste
    function copy
        if test (count $argv) -eq 0
            # Copy from stdin
            pbcopy
        else
            # Copy file contents
            cat $argv | pbcopy
            echo "Copied $argv to clipboard"
        end
    end

    function paste
        pbpaste
    end
end

### AUTO-SETUP MESSAGE ###

if is_blink
    # Show helpful hint on first load
    if not set -q BLINK_SETUP_SHOWN
        set -Ux BLINK_SETUP_SHOWN 1
        echo "📱 Blink Shell optimizations loaded!"
        echo "   • Use 'blink_fast' to toggle performance mode"
        echo "   • Compact prompt enabled"
        echo "   • Try 'msave hostname' then 'mlast' for quick reconnects"
    end
end
