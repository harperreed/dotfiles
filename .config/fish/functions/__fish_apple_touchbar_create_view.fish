function __fish_apple_touchbar_create_view --argument-names state bind_keys_function
    __fish_apple_touchbar_reset_bindings
    __fish_apple_touchbar_set_state $state
    eval $bind_keys_function
end
