# ABOUTME: Ultra-compact single-line prompt optimized for efficiency
# ABOUTME: Shows only essential info: [env:]host:dir branch >

# Turn off the prompt for virtualenv (we handle it ourselves)
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

# Performance toggle for git checks
if not set -q BLINK_FAST_MODE
    set -g BLINK_FAST_MODE 0
end

# Toggle fast mode
function blink_fast
    if test $BLINK_FAST_MODE -eq 0
        set -g BLINK_FAST_MODE 1
        echo "⚡ Fast mode enabled - git checks disabled"
    else
        set -g BLINK_FAST_MODE 0
        echo "🐢 Normal mode - all features enabled"
    end
end

# Ultra-compact single-line prompt
function fish_prompt
    set -l last_status $status

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

# Disable vi mode indicator
function fish_mode_prompt
end

# Disable right prompt
function fish_right_prompt
end