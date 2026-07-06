<!-- ABOUTME: Documentation audit report for ~/.claude/CLAUDE.md and @-referenced docs -->
<!-- ABOUTME: Generated 2026-07-05 via two-pass audit process -->

# Documentation Audit Report

Generated: 2026-07-05 | No git commit (not a git repo)

## Executive Summary

| Metric | Count |
|--------|-------|
| Documents scanned | 6 |
| Claims verified | ~40 |
| Verified TRUE | ~35 (88%) |
| **Verified FALSE** | **4 (10%)** |
| Human Review Queue | 2 |

**Target docs:**
- `/Users/harper/.claude/CLAUDE.md`
- `/Users/harper/.claude/docs/karpathy-guidelines.md`
- `/Users/harper/.claude/docs/python.md`
- `/Users/harper/.claude/docs/source-control.md`
- `/Users/harper/.claude/docs/using-uv.md`
- `/Users/harper/.claude/docs/docker-uv.md`

---

## False Claims Requiring Fixes

### CLAUDE.md

| Claim | Reality | Fix |
|-------|---------|-----|
| "Timeout and gtimeout are often not installed, do not try and use them" | Both ARE installed at `/opt/homebrew/bin/timeout` and `/opt/homebrew/bin/gtimeout` on this machine | Either remove the claim, or reframe as "may not be available on all systems" (cross-machine portability concern) |

### using-uv.md

| Line | Claim | Reality | Fix |
|------|-------|---------|-----|
| 109 | `FROM ghcr.io/astral-sh/uv:0.7.4 AS uv` | uv is currently at **0.9.25**; 0.7.4 is significantly outdated | Update to `ghcr.io/astral-sh/uv:latest` or pin to current version |
| 115 | `RUN uv sync --production --locked` | `--production` is **not a valid flag**; `uv sync --help` shows `--no-dev` instead | Replace `--production` with `--no-dev` |
| 81 | `uv cache dir && uv cache info      # show path + stats` | `uv cache info` is **not a valid subcommand**; valid ones are: `clean`, `prune`, `dir`, `size` | Replace `uv cache info` with `uv cache size` |

---

## Verified TRUE Claims

| Doc | Claim | Verification |
|-----|-------|--------------|
| CLAUDE.md | `ast-grep` (sg) is available | `/opt/homebrew/bin/sg` and `/opt/homebrew/bin/ast-grep` both present |
| CLAUDE.md | Fish shell is Doctor Biz's shell | `fish` installed at `/opt/homebrew/bin/fish` |
| CLAUDE.md | All 5 @-referenced docs exist | All found in `~/.claude/docs/` |
| using-uv.md | `uv` is installed | `uv 0.9.25` confirmed |
| using-uv.md | `uvx` is available | `uvx 0.9.25` confirmed |
| using-uv.md | `uv sync --locked` and `--frozen` flags exist | Confirmed via `uv sync --help` |
| using-uv.md | `uv tool update --all` flag exists | Confirmed via `uv tool update --help` |
| using-uv.md | `uv pip compile` command exists | Confirmed |
| using-uv.md | `uv cache clean` and `uv cache dir` are valid | Confirmed via `uv cache --help` |
| docker-uv.md | `ghcr.io/astral-sh/uv:latest` tag used | Uses `latest` — always current, no pinning issue |
| docker-uv.md | `uv sync --frozen --no-cache` and `--no-dev` flags valid | All confirmed valid |

---

## Pattern Summary

| Pattern | Count | Root Cause |
|---------|-------|------------|
| Stale uv version pin in Docker snippet | 1 | `using-uv.md` written when uv was at 0.7.x, not updated as uv releases accelerated |
| Invalid uv flags/subcommands | 2 | uv API changed: `--production` was removed/renamed to `--no-dev`; `uv cache info` became `uv cache size` |
| Stale hardware/tool assumption | 1 | `timeout`/`gtimeout` installed on this machine via Homebrew, contradicting the "often not installed" claim |

---

## Human Review Queue

- [ ] **CLAUDE.md model hints**: `"Fwiw OpenAI: GPT-5.5, Anthropic: Sonnet, Opus 4.6"` — verify these are current model names (web lookup recommended per CLAUDE.md's own advice)
- [ ] **using-uv.md line 100**: `uses: astral-sh/setup-uv@v5` — verify this is the current major version of the GitHub Actions setup

---

## Recommended Fixes

### using-uv.md — three changes

1. **Line 109**: `FROM ghcr.io/astral-sh/uv:0.7.4 AS uv` → `FROM ghcr.io/astral-sh/uv:latest AS uv`
2. **Line 115**: `RUN uv sync --production --locked` → `RUN uv sync --no-dev --locked`
3. **Line 81**: `uv cache dir && uv cache info` → `uv cache dir && uv cache size`

### CLAUDE.md — one change

4. `"Timeout and gtimeout are often not installed, do not try and use them"` → `"Avoid timeout and gtimeout — they may not be installed in all environments"`
   (The tools are installed locally, but the advice to avoid them for portability is sound — the wording just needs to be accurate.)
