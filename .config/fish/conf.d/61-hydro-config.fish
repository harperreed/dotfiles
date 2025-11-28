# ABOUTME: Hydro prompt configuration and right prompt for environment indicators
# ABOUTME: Shows tmux/blink/SSH status on right side, configures hydro symbols

# Right-hand side status bar to complement Hydro
function fish_right_prompt
    set -l segments

    # Blink Shell (iOS) detection
    if test "$TERM_PROGRAM" = "BlinkShell"
        set segments $segments "⚡ blink"
    end

    # SSH session?
    if set -q SSH_TTY
        set segments $segments (prompt_hostname)
    end

    # Join all active segments with spaces
    string join " " $segments
end

# Basic hydro configuration
# One line in tmux, multiline outside
if set -q TMUX
    set -g hydro_multiline false
else
    set -g hydro_multiline true
end
set -g hydro_fetch false
set -g hydro_cmd_duration_threshold 500

# Show more of the path (default is 1 char per segment)
set -g fish_prompt_pwd_dir_length 4

# Git branch color
set -g hydro_color_git green
