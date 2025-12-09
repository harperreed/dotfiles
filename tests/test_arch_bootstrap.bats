#!/usr/bin/env bats
# ABOUTME: Test suite for Arch Linux bootstrap functionality in linux.sh
# ABOUTME: Validates bootstrap_arch, update_pacman, install_packages_arch, and install_aur_packages functions

load setup

@test "bootstrap_arch function exists" {
    source "${BOOTSTRAP_D_DIR}/linux.sh"

    declare -f bootstrap_arch
}

@test "bootstrap_arch updates pacman" {
    source "${BOOTSTRAP_D_DIR}/linux.sh"

    run bootstrap_arch

    # Should see pacman update in output
    [[ "$output" =~ "pacman -Sy" ]]
}

@test "update_pacman runs pacman -Sy" {
    source "${BOOTSTRAP_D_DIR}/linux.sh"

    run update_pacman

    [[ "$output" =~ "pacman -Sy" ]]
}

@test "install_packages_arch installs packages" {
    source "${BOOTSTRAP_D_DIR}/linux.sh"

    run install_packages_arch "fish" "neovim"

    [[ "$output" =~ "pacman -S" ]]
    [[ "$output" =~ "fish" ]]
    [[ "$output" =~ "neovim" ]]
}

@test "install_aur_packages requires yay" {
    source "${BOOTSTRAP_D_DIR}/linux.sh"

    # Mock command_exists to return false for yay
    command_exists() {
        [[ "$1" != "yay" ]]
    }
    export -f command_exists

    run install_aur_packages

    # Should skip AUR packages
    [[ "$output" =~ "yay" ]]
}
