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
