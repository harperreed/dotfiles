# ABOUTME: Plugin initialization and configuration
# ABOUTME: Loads atuin and other shell enhancements with lazy loading for performance

if status is-interactive
    # Atuin shell history
    if type -q atuin
        atuin init fish | source
    end

    # Lazy-load done.fish plugin (notification on long-running commands)
    # Only loads on first prompt to avoid startup delay
    function __load_done_plugin --on-event fish_prompt
        if test -f /Users/harper/.config/fish/conf.d/done.fish.disabled
            source /Users/harper/.config/fish/conf.d/done.fish.disabled
        end
        functions -e __load_done_plugin
    end

    # Lazy-load grc (generic colourizer)
    # Creates a wrapper that loads the real grc on first use
    function grc --description 'Generic colourizer' --wraps grc
        if test -f /Users/harper/.config/fish/conf.d/grc.fish.disabled
            source /Users/harper/.config/fish/conf.d/grc.fish.disabled
        end
        # Call the real grc with the same arguments
        if type -q grc
            command grc $argv
        end
    end
end

# Load custom functions
# Note: Fish automatically loads functions from ~/.config/fish/functions/
# This is just for any additional function files if needed
