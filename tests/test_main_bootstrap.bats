#!/usr/bin/env bats
# ABOUTME: Integration tests for main bootstrap dispatcher
# ABOUTME: Verifies platform detection, command-line arguments, and dry-run mode functionality

load setup

@test "main bootstrap script exists and is executable" {
    [ -x "${BOOTSTRAP_DIR}/bootstrap" ]
}

@test "bootstrap detects Darwin platform" {
    run "${BOOTSTRAP_DIR}/bootstrap" --dry-run --platform darwin

    [ "$status" -eq 0 ]
    [[ "$output" =~ "darwin" ]]
}

@test "bootstrap detects Linux platform" {
    run "${BOOTSTRAP_DIR}/bootstrap" --dry-run --platform linux

    [ "$status" -eq 0 ]
    [[ "$output" =~ "linux" ]]
}

@test "bootstrap shows help" {
    run "${BOOTSTRAP_DIR}/bootstrap" --help

    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "bootstrap dry-run mode works" {
    run "${BOOTSTRAP_DIR}/bootstrap" --dry-run

    [ "$status" -eq 0 ]
    [[ "$output" =~ "DRY RUN" ]]
}

@test "bootstrap fails on unsupported platform" {
    run "${BOOTSTRAP_DIR}/bootstrap" --dry-run --platform windows

    # Should fail because windows script doesn't exist
    [ "$status" -ne 0 ]
}
