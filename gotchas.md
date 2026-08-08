# gotchas

Shared knowledge for every agent and collaborator on Harper's stuff. Claude Code renders its private memory down into entries here; agents without a memory system write entries directly. Update entries in place — never regenerate the file.

## Working with Harper
- **Rules bind by intent.** Hard rules need a discriminator separating the feared case from the routine case; blanket ALL-CAPS gates teach agents to over-ask, and an unnecessary permission stop is also a failure. Plain words from Harper count — no magic phrases.
- **Context-loaded files pay token rent.** Never put documentation or comment headers in CLAUDE.md/AGENTS.md/skill prompts — every line loads into every session forever. System docs go in an on-disk README next to the tooling.
- **Advisors don't gate builders.** Reviewer/architect roles give opinions with evidence; never instruct a peer agent to halt. An identical instruction broadcast to several agents is a ruling (location, decision), not a per-agent reassignment.
- **Sequence the prerequisite fix before the risky action.** Once a structural risk is diagnosed (STP loops, migrations, schema changes), any recommendation that touches it must lead with the precondition, state the failure mode, and give the rollback. A casual "wire a Port or two" without the STP fix took down all six Sonos players.
- **Verify before shipping another agent's work.** Self-reported "all checks green" can be wrong — run the repo's own pre-commit gate yourself (standalone `go vet` catches what golangci-lint misses).
- **Harness built-ins are invisible in skills lists.** /goal, /loop, /clear exist even though no list shows them. "Make a /X" from Harper means "give me the /X invocation", not "build a new command".
- **When Harper asks "why", he wants root causes** — he thinks in systems, not band-aids.

## This machine (dotfiles, ssh)
- **yadm remotes:** `origin` fetches GitHub, pushes to GitHub + sr.ht mirror; branch is `master` (a stale `main` lingers on GitHub). History rewritten Jul 2026, old lineage at `archive/pre-rewrite-2026-07`. If sr.ht diverges, pushes half-fail non-fast-forward — force-push master to sr.ht.
- **yadm pull can freeze via git-lfs hooks.** The global `core.hooksPath` LFS post-checkout hook deadlocks inside the yadm repo; fixed locally by pointing the yadm repo at its own empty hooks dir (Jul 2026). If it wedges: `ps -ax | grep git_hooks`, kill hung chains. Run `yadm status` before committing — never commit mid-rebase.
- **yadm autostash hazards.** Machine-mutated tracked files (.codex/config.toml, .claude/settings.json, fish_variables) keep the worktree dirty, so pulls autostash constantly and conflicted pops park stashes silently. Interrupted pull = sequencer limbo: `yadm rebase --continue` with a clean worktree; never `--abort` with uncommitted edits.
- **SSH IdentityFile accumulates across all matching stanzas,** and agent-loaded keys are tried first regardless of `-i`/`IdentitiesOnly`. Pin per-host keys by negating those hosts in the `Host *` stanza. exe.dev: account = first key offered; personal uses `id_ed25519`, 2389 uses `~/.ssh/exe-2389`; new 2389 VM goes in both the 2389 stanza and the personal negation list.

## Fleet & multi-agent
- **herdr `idle` does not mean parked** — it usually means "finished the turn, waiting on Harper's decision". Always `herdr agent read <pane>` before triaging; never infer from status alone. ~13 codex/claude sessions, one per repo under `~/Public/src/`.
- **palace_ops `messages`/`events --limit N` returns the OLDEST page,** not the newest. Observe current state with a high limit + tail or `events --after <id>`, and cite the last observed event id so peers can spot staleness.

## Sonos & office network
- **Topology:** six-unit single S2 household on IoT VLAN `192.168.24.0/23`; controllers on `192.168.23.0/24`. UniFi reflects mDNS but not SSDP, so the app keeps "losing" players; double NAT behind the AT&T gateway. Group coordinator: Sonos Connect "2389 Radio" (`.40`) — oldest, 2.4 GHz-only, most likely failure point.
- **Different firmware builds ≠ different households.** Sonos ships per-hardware builds of one release; verify membership via `GetZoneGroupState` (port 1400 SOAP) or the mDNS `hhid`, never version strings.
- **Before wiring a speaker on a VLAN'd network,** confirm the switch port carries the Sonos VLAN — otherwise it lands on the wrong subnet and shows as `VanishedDevices` split-brain (happened 2026-05-15). Say this before recommending "wire it".
- **Dropout playbook: probe, don't speculate.** `dns-sd` for discovery, port-1400 HTTP/SOAP for topology and coordinator, continuous ping p50/p95 per AP, UniFi airtime/retries, and hunt 802.11b clients ("WiFi 1" — one b-client wrecks the whole AP). Fix order: wire the coordinator → raise minimum data rate → replace legacy hardware.

## Projects & practices
- **Claw migration:** Harper is reverting his agent stack Hermes → NanoClaw v2 (he prefers the Claude Code backend) and executing it himself. Proposals in `~/Public/claw-migration/`. Landmine: one WhatsApp number — unload the Hermes WA gateway before NanoClaw reconnects.
- **Instruction-file editing:** cutting soft-label preambles before self-contained rules is safe; never cut the setup of a setup-punchline pair; judge voice in sequence, not per line; LLM judge scores carry ±0.2–0.3 noise — adopt edits you can defend, not score deltas.
- **Skill design:** abstract creative instructions ("be bold") lose to training-data bias — concrete anchors (specific fonts, hex codes, CSS) and real-world references win. Anti-pattern aesthetics become their own cliche.
