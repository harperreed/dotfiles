---
description: Drive this repo to a known-good state — catalog every capability as e2e scenario cards, then loop test → fix → re-test until verified
argument-hint: [optional: areas or surfaces to limit scope]
---

Produce a verified, code-derived behavioral spec for this project, captured as e2e scenario cards plus one canonical status ledger that together carry every capability from spec'd → tested → fixed → verified.

Scope: $ARGUMENTS — if that names areas or surfaces, limit the inventory to them; if empty, cover the whole repo.

Why: we need a source of truth that maps every externally observable capability to its expected behavior *as the code implements it*, so gaps and bugs surface and you can drive the project to a known-good state. The cards are the spec; the ledger is the tracker. Both outlive the loop as the repo's regression suite — commit them.

Method: invoke the end-to-end scenario testing skill (installed as e2e-scenario-testing or superpowers:agentic-end-to-end-testing) before Phase 1, and follow it for card format, runner dispatch, interface recipes (web / CLI-TUI / desktop), evidence discipline, and honesty rules. This command adds the inventory, the ledger, and the loop.

Work on the current repo. Do Phase 0 and Phase 1, then move into the quality cycle. Keep going; stop only at a real checkpoint, defined below.

Definitions:

- "Capability" means any externally observable behavior the project exposes: CLI commands, library APIs, public functions/classes/modules, SDK methods, web routes/pages/components, API endpoints, background jobs, config behavior, auth flows, data import/export, file formats, integrations, migrations, scheduled tasks, plugins, build tools, or developer workflows — whatever this repo actually exposes.
- Derive expected behavior from the code, tests, fixtures, schemas, comments, and docs in the repo. Prefer code over docs when they conflict.
- Do not guess. Where behavior is ambiguous, underspecified, unreachable, or dependent on missing external state, log an open question in the ledger.

Artifacts:

- Scenario cards: one card per capability in `test/scenarios/`, named `<area>-<nnn>-<slug>.md` (e.g. `auth-001-email-login.md`). The filename stem is the stable ID; never renumber. Use the skill's card format, with harper's CSV columns mapped in:
  - The actor and story ("As a returning user I want to log in with email and password so I can reach my account") and the source refs (files/functions/tests that establish the behavior) go under **What this covers**.
  - The expected behavior from code goes in **## Expected**, one falsification condition per assertion — "if you see X instead, the test fails."
  - Ambiguities and footguns go in **Sharp edges**, plus a ledger note.
- Ledger: exactly one canonical file, `test/scenarios/LEDGER.md`, holding a markdown table:

  | ID | Card | Status | Test method | Defect type | Actual result | Notes / open questions |
  |---|---|---|---|---|---|---|

  Ledger rules: the main thread is the single writer. Runners keep their own per-run workdir ledgers per the skill; transcribe their results into the canonical ledger yourself. Never fork per-phase, per-area, or per-iteration copies. Preserve IDs once assigned.

Status flow: Spec'd → Tested-Pass | Tested-Fail → Fixed → Verified.

- A Tested-Pass row promotes to Verified at iteration end if the pass came from genuine execution (not static-only) and no defect was logged against it.
- A row touched by a fix reaches Verified only through a fresh post-fix run.

Phase 0 — Plan first:

Detect the project shape: language(s), framework(s), package managers, build/test tooling, runtime entrypoints, public interfaces, CLIs, library/module exports, web/API surfaces, background workers/jobs, persistence/config/state mechanisms, auth/permissions, integrations/external services, and existing test infrastructure (unit, integration, e2e/system, CLI tests, browser automation, fixtures/seeds, mocks/fakes, runnable local services, CI scripts).

Preflight per the skill: build fresh from the code under test; give the test instance its own HOME, port, and state directory; run a smoke check; confirm credentials and models are in place.

Propose:

(a) how you'll inventory capabilities across this repo
(b) the ID/area scheme for cards
(c) how you'll test each surface, naming the skill recipe you'll use for it
(d) what cannot be executed locally, if anything, and how you'll handle those cases without inventing results

Proceed once the plan holds.

Phase 1 — Catalog & cards:

- Fan out discovery subagents by area/interface to inventory capabilities from the code.
- Assign IDs and create a Spec'd ledger row per capability yourself.
- Dispatch card-author subagents to write the cards. Authors are cards-only: they never modify product code, test code, or existing cards' assertions; a failing card plus root cause is a deliverable, not a fix.
- Exit Phase 1 only when every discoverable capability has a card and a ledger row, a fresh-context reviewer has compared the card set and ledger against the discoverable code surface, and you have fixed what it found.

Test method: for each card choose the strongest practical method —

- end-to-end/system execution against the real project
- CLI invocation against built/local binaries
- public API/library calls through tests or small harnesses
- integration tests with real or local/fake dependencies
- existing unit tests
- targeted new tests/harnesses
- static checks only where execution is truly impossible; a static-only pass caps at Tested-Pass with a static-check note and never reaches Verified

Quality cycle — iterate test → fix → re-test until clean:

1. Test

- Run every card not yet Verified through disposable runner subagents dispatched with the skill's runner prompt: hermetic workdir, evidence captured and re-inspected, per-assertion verdicts, one flake retry. Batch cards per runner sequentially where sensible.
- No product or tool behavior changes during the Test step.
- Never weaken, skip, or reinterpret an assertion to make it pass.
- Transcribe each runner's results into the ledger: Status, Test method, Defect type, Actual result, Notes.
- Defect type is one of: Functional, Logistical, UX, Documentation, Testability, Environment, Unknown.

2. Fix

For every Functional, Logistical, and UX defect logged this iteration:

- find the root cause first — use the systematic-debugging skill
- fix the cause, not the symptom
- keep scope to the logged defects: no unrelated features, no unrelated refactors, no silent behavior changes
- update the ledger rows the fix touches

Fix Documentation, Testability, Environment, and Unknown defects only when the fix is clear and requires no product decision; otherwise leave them logged with notes.

Edit a card only when the card itself is wrong — executing the card tests the card. Justify the edit in the ledger. Never edit a card to make a failing assertion pass.

3. Re-test

- Re-run every card touched by a fix through fresh runners, same method where possible. Pass → Verified. Fail → Tested-Fail with root-cause notes.
- End each iteration with a fresh-context review verifying that the ledger matches the actual test/fix/re-test results; promote qualifying Tested-Pass rows to Verified; correct omissions and stale statuses.

Exit when every capability is Verified and no open Functional, Logistical, or UX defects remain.

Safety cap: if a capability still fails after 3 full test/fix/re-test iterations, stop looping on it. Leave it Tested-Fail; record in the ledger the root cause, attempted fixes, remaining evidence, and recommended next action; report it plainly.

Checkpoint only when one of these is true:

- a destructive or irreversible action is required
- a fix requires a genuine product decision
- required input is available only from the user
- credentials/secrets are required and no safe mock/fake/local alternative exists

Otherwise, keep going.

Agentic execution: you own the ledger and remain its single writer; delegate breadth — discovery, card authoring, runs, defect analysis, fresh-context review — to subagents. Verify by running, not claiming. Report real command output, test output, and exit codes. State skips, unknowns, missing dependencies, and untestable cases plainly.
