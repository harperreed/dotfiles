<!-- ABOUTME: The design principles behind the agent policy — how to write and edit rules without recreating pedantry. -->
<!-- ABOUTME: Read before editing AGENTS.md. Learned the hard way during the July 2026 de-pedanticization. -->

# Policy design principles

The policy file is a prompt, not a legal code. Every rule costs tokens, attention, and — if badly scoped — agent autonomy. These principles come from the July 2026 rewrite, when uniform maximal enforcement had agents stopping mid-task to request permission for textbook-routine work.

## Rules bind by intent

Every hard rule needs a discriminator that separates the feared case from the routine case ("public contract preserved + blast radius bounded → go; wholesale discard → ask"). A rule without a discriminator becomes a blanket gate, and blanket gates teach agents to over-ask.

## Caps are a budget

ALL-CAPS / NEVER / MUST is reserved for true absolutes: bypassing hooks, data loss, lying. When every rule is DEFCON-1, the register stops carrying information — agents can't tell hook-bypassing from a style preference.

## No incantations

Never require exact phrases ("unless I say the magic words X"). Plain words from Doctor Biz count. Exact-phrase gates make agents lawyer the transcript instead of reading intent.

## Asking has a cost too

Wrong action isn't the only failure mode; an unnecessary permission stop wastes a turn and hands back a decision that was already delegated. The Proactiveness section enumerates the few real ask-first cases — everything else proceeds.

## Format rules become tics

Any rule that prescribes a framing or template ("present both views: perfectionist and pragmatist") leaks outside its trigger and becomes a stylistic habit. Prefer outcome rules ("report weaknesses honestly, ranked by severity") over format rules.

## Fun is a permission, not a mandate

Culture bits are written as "may", not "MUST". Mandated fun becomes ritual — the naming ceremony needed an explicit "record the names once" clause for exactly this reason.

## Scope personal conventions

ABOUTME headers, gotchas.md, journal commits: "my projects" only. Team and third-party repos follow house conventions — the religion doesn't leak into shared codebases.

## One policy, boring duplication

The record and both deployed copies are byte-identical real files — no imports, symlinks, or generation (see README, decided 2026-07-16). The cost is drift; the tool is `./reconcile`; the docs you're reading are the rest of the mitigation.
