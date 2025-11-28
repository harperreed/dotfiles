if not contains "$HOME/.atuin/bin" $PATH
    # Prepending path in case a system-installed binary needs to be overridden
    set -x PATH "$HOME/.atuin/bin" $PATH
end
