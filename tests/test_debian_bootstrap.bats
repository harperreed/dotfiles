#!/usr/bin/env bats

load setup

@test "bootstrap_debian function exists" {
    # This will fail until we implement bootstrap_debian
    # Check if the function is defined in linux.sh
    grep -q "^bootstrap_debian()" "${BOOTSTRAP_D_DIR}/linux.sh"
}

@test "bootstrap_debian updates apt" {
    # This will fail until we refactor
    # Check if bootstrap_debian calls update_apt
    grep -A 20 "^bootstrap_debian()" "${BOOTSTRAP_D_DIR}/linux.sh" | grep -q "update_apt"
}
