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

# blink_fast function is now defined globally in 60-prompt.fish

### COMPACT PROMPT FOR BLINK ###

# Prompt is now defined globally in 60-prompt.fish
# No Blink-specific overrides needed

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
