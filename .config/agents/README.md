<!-- ABOUTME: Map of ~/.config/agents — the copy of record for the global agent policy and its reconciliation flow. -->
<!-- ABOUTME: Start here when the policy files look out of sync or you're about to edit them. -->

# ~/.config/agents

One policy governs every coding agent on this machine (Claude Code, Codex, whatever comes next). Each tool reads its own real file — no imports between them, no symlinks, no generation step. This directory holds the canonical copy, the tooling, and the thinking.

## Layout

| Path | Role |
|---|---|
| `AGENTS.md` (here) | **Copy of record.** Edit this one. |
| `~/.claude/CLAUDE.md` | Deployed copy read by Claude Code |
| `~/.codex/AGENTS.md` | Deployed copy read by Codex |
| `reconcile` | Drift check + deploy script (`./reconcile help`) |
| `PRINCIPLES.md` | How to write policy rules without recreating pedantry |
| `~/.codex/docs/local.md` | Machine-local facts — per-machine, deliberately NOT synced or tracked. The policy's last line imports it (Claude) / instructs reading it (Codex). |

All three policy files stay **byte-identical**. This directory and both deployed copies are yadm-tracked; `local.md` is not.

## Editing the policy

1. Read `PRINCIPLES.md`, then edit `AGENTS.md` here.
2. `./reconcile deploy` (add `--force` if the copies already differ — review first).
3. `yadm add ~/.config/agents/AGENTS.md ~/.claude/CLAUDE.md ~/.codex/AGENTS.md && yadm commit`

## When things drift

A session edited a deployed copy directly? Expected, not a crime — that's the cost we chose. Reconcile it:

1. `./reconcile` — see what's out of sync.
2. `./reconcile diff` — read the drift.
3. Fold what you want to keep into the record: edit it by hand, or `./reconcile adopt claude|codex` when one copy is wholesale right.
4. `./reconcile deploy --force` — the flag is your "I reviewed what's being overwritten" attestation.
5. Commit record + copies together.

## New machine

`yadm clone` brings this directory and both deployed copies. Create `~/.codex/docs/local.md` by hand (OS, shell, paths, installed tools, network, MCP servers) — it is per-machine on purpose.

## Why duplication instead of something clever

We tried an import wrapper (CLAUDE.md importing ~/.codex/AGENTS.md). It worked, but the policy for all agents lived in one vendor's dotdir and the mechanism stack (wrapper + import) obscured what any tool actually read. Symlinks and generated copies were considered and rejected as more moving parts. Boring real files won; drift is the accepted cost and this directory is the mitigation. Decided 2026-07-16.
