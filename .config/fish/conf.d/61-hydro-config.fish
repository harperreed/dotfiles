# ABOUTME: Hydro prompt configuration and right prompt for environment indicators
# ABOUTME: Shows tmux/blink/SSH status on right side, configures hydro symbols

# Right-hand side status bar to complement Hydro
function fish_right_prompt
    set -l segments

    # Inside tmux?
    if set -q TMUX
        set segments $segments "⧉ tmux"
    end

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
set -g hydro_multiline true
set -g hydro_fetch false
set -g hydro_cmd_duration_threshold 500

# Change start symbol depending on tmux
if set -q TMUX
    set -g hydro_symbol_start "⧉"
    set -g hydro_color_start brcyan
else
    set -g hydro_symbol_start "~"
    set -g hydro_color_start normal
end
