# ABOUTME: Sources prek environment setup if available
# ABOUTME: Only loads if the env file exists on this system
if test -f "$HOME/.local/bin/env.fish"
    source "$HOME/.local/bin/env.fish"
end
