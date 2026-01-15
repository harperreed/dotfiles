# ABOUTME: Simple colorized fish prompt with git, execution time, and user@host
# ABOUTME: Shows user@host, collapsed directory, git branch, and command duration

function fish_prompt
    set -l last_status $status

    # Colorful user@hostname (§ for SSH, † for tmux, z for ZMX)
    set_color green
    echo -n $USER
    set_color yellow
    echo -n @
    if set -q SSH_CONNECTION; and not set -q TMUX
        set_color red
        echo -n (hostname -s)
        set_color white
        echo -n " ["
        set_color yellow
        echo -n "§"
        set_color white
        echo -n "]"
    else if set -q TMUX
        set_color blue
        echo -n (hostname -s)
        set_color white
        echo -n " ["
        set_color magenta
        echo -n "†"
        set_color white
        echo -n "]"
    else if set -q ZMX_SESSION
        set_color blue
        echo -n (hostname -s)
        set_color white
        echo -n " ["
        set_color cyan
        echo -n "z"
        set_color white
        echo -n "]"
    else
        set_color blue
        echo -n (hostname -s)
    end

    # Background jobs in yellow
    set -l job_count (jobs | count)
    if test $job_count -gt 0
        set_color white
        echo -n " ["
        set_color yellow
        echo -n $job_count
        set_color white
        echo -n "]"
    end

    # Cyan directory (collapsed: shorten path components to 1 char if path is long)
    set_color cyan
    set -l pwd_result (prompt_pwd --dir-length 1)
    echo -n " $pwd_result"

    # Git branch in magenta with dirty indicator
    set -l git_branch (git branch --show-current 2>/dev/null)
    if test -n "$git_branch"
        set_color magenta
        echo -n " ($git_branch"
        # Fast dirty check - just checks if there are any changes
        if not git diff --quiet HEAD 2>/dev/null
            set_color red
            echo -n "…"
            set_color magenta
        end
        echo -n ")"
    end

    # Execution time in yellow (only if > 1 second)
    if test $CMD_DURATION -gt 1000
        set_color yellow
        set -l seconds (math "$CMD_DURATION / 1000")
        if test $seconds -ge 60
            set -l mins (math -s0 "$seconds / 60")
            set -l secs (math -s0 "$seconds % 60")
            echo -n " "$mins"m"$secs"s"
        else
            echo -n " "$seconds"s"
        end
    end

    # Red or green prompt based on last command status
    if test $last_status -eq 0
        set_color green
    else
        set_color red
    end
    echo -n ' > '

    set_color normal
end
