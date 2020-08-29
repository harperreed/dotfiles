function __fish_apple_touchbar_print_key --argument-names cmd
    set template "\e]1337;%s\a"
    if test -n "$TMUX"; or string match "tmux*" "$TERM"
        set template "\ePtmux;\e$template\e\\"
    end
    printf $template "$cmd"
end
