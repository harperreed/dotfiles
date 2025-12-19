---
name: releasing-software
description: Use when preparing a release, tagging a version, or when user says "release", "tag", "ship it", "push to production" - ensures all release artifacts are verified before tagging to avoid the retag-four-times failure pattern
---

# Releasing Software

## Overview

**Never tag until CI passes.** Every retag erodes trust and wastes time.

This skill prevents the "tag, watch CI fail, retag, repeat" anti-pattern by establishing a pre-flight checklist that catches issues BEFORE creating the tag.

## The Iron Law

```
NO TAG WITHOUT GREEN CI
```

Run the full verification locally. Fix everything. THEN tag. Not before.

## Pre-Release Checklist

**MANDATORY: Use TodoWrite to create todos for EACH item.**

### 1. Verify Build Paths

Check ALL places that reference your main package:

- [ ] `goreleaser.yml` - `main:` field (common: `./cmd/app` vs `.`)
- [ ] `.github/workflows/*.yml` - any `go build` commands
- [ ] `Makefile` - build targets
- [ ] `Dockerfile` - build commands

```bash
# Find all references to cmd/ or main package paths
grep -r "cmd/" . --include="*.yml" --include="*.yaml" --include="Makefile" --include="Dockerfile"
grep -r "go build" . --include="*.yml" --include="*.yaml" --include="Makefile"
```

### 2. Verify Tests Exist

Go 1.23+ coverage tool fails on packages without tests:

```bash
# Check for test files in each package
find . -name "*_test.go" | wc -l

# If zero, add placeholder tests to EVERY package
```

**Every package needs at least one test file** or CI coverage step fails with `no such tool "covdata"`.

### 3. Verify Local CI Passes

```bash
# Run what CI runs
make test          # or go test ./...
make lint          # or golangci-lint run
make build         # verify it compiles

# If using coverage
make test-coverage
```

### 4. Verify Documentation

- [ ] README.md exists and is current
- [ ] CHANGELOG.md updated (if maintained)
- [ ] Version references updated

### 5. Verify Release Config

- [ ] goreleaser description is correct (not template leftovers)
- [ ] goreleaser homepage URL is correct
- [ ] `.gitignore` includes build artifacts, coverage files

### 6. Verify Clean Git State

```bash
git status                    # Nothing unexpected staged
git diff --stat              # Review all changes
git log --oneline -5         # Verify recent history
```

## Release Procedure

**Only after ALL checks pass:**

```bash
# 1. Commit all changes
git add -A && git commit -m "release: prepare v0.0.X"

# 2. Wait for pre-commit hooks to pass
# If hooks fail, fix and re-commit

# 3. Push and wait for CI
git push origin main

# 4. WAIT FOR CI TO PASS - check status
gh run list --limit 2
# OR watch in browser

# 5. Only after CI is green, create tag
git tag -a v0.0.X -m "v0.0.X"
git push origin v0.0.X

# 6. Verify release workflow completes
gh run list --limit 2
```

## Red Flags - STOP

If you catch yourself doing any of these, STOP:

- Tagging before CI completes
- "CI will probably pass"
- "I'll fix it if it fails"
- Deleting and recreating tags
- Force-pushing tags
- "It's just a minor release"

**All of these mean: Wait for CI. Fix issues. Then tag.**

## Common Failures

| Symptom | Cause | Fix |
|---------|-------|-----|
| `couldn't find main file` | Wrong path in goreleaser | Set `main: .` if main.go at root |
| `no such tool "covdata"` | Package without tests | Add placeholder test to each package |
| Release succeeds but brew fails | Wrong description/homepage | Update goreleaser brews section |
| Had to retag | Tagged before CI passed | WAIT FOR GREEN CI |
| 504 errors in CI | GitHub infra issue | Retry workflow, not a code problem |

## Version Bumping

When incrementing version:

1. **Patch** (0.0.X): Bug fixes, no new features
2. **Minor** (0.X.0): New features, backwards compatible
3. **Major** (X.0.0): Breaking changes

Search codebase for version references:
```bash
grep -r "version" . --include="*.go" --include="*.yml" --include="*.json" | grep -v test | grep -v vendor
```

## Post-Release Verification

After tag is pushed:

```bash
# Watch release workflow
gh run watch

# Verify release assets
gh release view v0.0.X

# Test installation (if applicable)
go install github.com/user/repo@v0.0.X
```

## The Bottom Line

**Retagging is a symptom of rushing.**

The 5 minutes spent on pre-flight checks saves 30 minutes of retag cycles and preserves your release history integrity.

Every tag should be final. If you're deleting tags, you skipped the checklist.
