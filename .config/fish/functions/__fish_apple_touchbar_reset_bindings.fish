function __fish_apple_touchbar_reset_bindings
    function __fish_apple_touchbar_unbind_keys
        for n in (seq 12)
            bind --erase --key f$n
        end
    end

    __fish_apple_touchbar_print_key "PopKeyLabels"
    __fish_apple_touchbar_unbind_keys
end
