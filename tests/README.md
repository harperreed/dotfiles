# YADM Bootstrap Tests

This directory contains tests for the yadm bootstrap scripts.

## Running Tests

### Install bats-core

**Ubuntu/Debian:**
```bash
sudo apt-get install bats
```

**Arch:**
```bash
sudo pacman -S bats
```

**macOS:**
```bash
brew install bats-core
```

### Run all tests

```bash
bats tests/
```

### Run specific test file

```bash
bats tests/test_common.bats
```

## Test Structure

- `setup.bash` - Common setup and mocking utilities
- `test_common.bats` - Tests for common.sh functions
- `test_debian_bootstrap.bats` - Tests for Debian/Ubuntu bootstrap
- `test_arch_bootstrap.bats` - Tests for Arch Linux bootstrap
- `test_main_bootstrap.bats` - Tests for main bootstrap dispatcher

## Test Coverage

### test_common.bats
- Distribution detection (Debian, Ubuntu, Arch)
- Helper functions (is_debian_based, is_arch_based)
- Package installation detection for apt and pacman

### test_debian_bootstrap.bats
- Debian/Ubuntu bootstrap entry point
- APT package management
- GUI vs headless detection
- Repository setup

### test_arch_bootstrap.bats
- Arch Linux bootstrap entry point
- Pacman package management
- AUR package support via yay
- GUI vs headless detection

### test_main_bootstrap.bats
- Main bootstrap dispatcher
- Platform detection
- Command-line argument parsing
- Dry-run mode

## Continuous Testing

Run tests automatically with:

```bash
./tests/run-tests.sh
```

## Test Philosophy

We follow TDD:
1. Write failing test
2. Implement minimal code to pass
3. Refactor while keeping tests green
4. Commit frequently
