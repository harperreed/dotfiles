---
name: scenario-to-tiktok
description: Use when a completed Shell scenario planning exercise needs to be converted into a TikTok script. Triggers when user says "make a tiktok", "tiktok script", "generate tiktok", or "content from scenario". Requires a completed scenario with narratives, findings, and worldview integration.
---

# Scenario to TikTok

Generate a production-ready TikTok script from a completed Shell scenario planning exercise, with meme integration and visual direction.

## When to Use

- Completed scenario with 4+ narratives exists
- User wants short-form video content from the analysis
- Scenario has a clear thesis and counterintuitive findings

## When NOT to Use

- Scenario is incomplete (no narratives yet)
- User wants long-form content (blog, report, documentary) — different format
- No comedic or irreverent angle exists

## Required Inputs

Read these scenario files to build the script:

1. **worldview_model.md** — The user's original beliefs (this is your HOOK)
2. **worldview_integration.md** — Where beliefs were confirmed/challenged (this is your TWIST)
3. **predetermined_elements.md** — Hard facts and numbers (this is your EVIDENCE)
4. **critical_uncertainties.md** — The 2x2 matrix and axes (this is your STRUCTURE)
5. **Scenario narratives** — Character names and story beats (this is your COLOR)
6. **strategy_analysis.md** — The meta-strategy (this is your CLOSER)

## Script Structure

TikTok scripts from scenarios follow a 5-section arc:

```
HOOK → COMMON BELIEF → COUNTERINTUITIVE FINDING → THE TWIST → CALLBACK + SEQUEL TEASE
```

### Section Breakdown

| Section | Source | Purpose | Duration |
|---------|--------|---------|----------|
| **HOOK** | worldview_model.md | State the question using the user's original framing | 5-10s |
| **COMMON BELIEF** | predetermined_elements.md | Present what most people assume (and what's right about it) | 15-25s |
| **BODY GOES OFFLINE** | context_packet.md, predetermined | The visceral details — numbers, timelines, consequences | 20-30s |
| **THE TWIST** | critical_uncertainties.md | The single variable that changes everything | 15-20s |
| **SOCIAL CONSEQUENCES** | worldview_integration.md | The human/social angle people don't think about | 10-15s |
| **CLOSER** | strategy_analysis.md | The meta-strategy as a one-liner. Sequel tease with scenario names. | 10-15s |

**Target total: 2:00-3:00**

### Writing the Hook

The hook comes from the GAP between what the user originally believed and what the scenario process revealed. Read worldview_model.md and worldview_integration.md together.

Pattern: "Important question. [State the question]. Would you [optimistic extreme] or [pessimistic extreme]?"

### Writing the Twist

The twist is ALWAYS the scenario's primary axis — the single variable that matters most. In a good scenario, this is counterintuitive. Frame it as a conspiratorial lean-in: "BUT. If by [term] you mean [expanded definition]..."

### Text-on-Screen Moments

Every good TikTok script needs 2-3 text-on-screen moments. These come from the scenario's most quotable findings. Look for:

- Phrases that are funny out of context ("STARVING, BUT WET")
- The thesis condensed to 3-4 words ("WEIRD, BUT SURVIVABLE")
- Specialist one-liners that hit hard

### The Sequel Tease

Always end by naming the four scenarios. Scenario names are designed to be memorable and intriguing — they function as sequel bait.

Pattern: "Next I'll do the even more deranged version: **[Scenario 1], [Scenario 2], [Scenario 3], and [Scenario 4].**"

## Meme Integration

After writing the base script, embellish with memes using the meme-rodeo MCP tools.

### Sourcing Memes

1. Search meme-rodeo for topic-relevant terms (the scenario subject, key themes)
2. Search for emotional/tonal terms (chaos, conspiracy, confusion, existential)
3. If rate-limited on search, use `random_memes` or `list_recent` and filter manually
4. Aim for 12-18 memes total across a 2-3 minute script

### Meme Placement Rules

| Placement Type | Duration | When to Use |
|----------------|----------|-------------|
| **Flash** (0.5s) | Subliminal comedy beat | Punctuate a punchline, no caption needed |
| **Hold** (1-1.5s) | Let audience read caption | When meme + caption overlay = the joke |
| **Long Hold** (2s) | Biggest laugh, most shareable frame | Max 2-3 per script, save for best moments |
| **Callback** | Same meme, bookend | Open and close with same meme for structural closure |

### Meme Mapping

Map each meme to a specific scenario or finding:

```markdown
> **[MEME INSERT: Name]** — description of meme. Caption overlay: "text"
> ![](image_url)
```

Every meme insert needs:
- Which line it follows
- Duration (flash/hold/long hold)
- Caption overlay text (if any)
- Why it works for this moment

### Meme Selection Criteria

Pick memes that work through JUXTAPOSITION with the script content, not literal illustration:

- A jogger past a burning house + "day 18: I feel amazing" (ironic contrast)
- Batman at a dinner table + "you at thanksgiving now" (absurd reframing)
- Tiny cocktail + "this is 15 calories" (scale visualization)

Avoid memes that just illustrate what's being said. The meme should add a layer.

## Output Files

Write two files to the scenario's exports directory:

1. **`exports/tiktok_script.md`** — Base script without memes (for reading/editing)
2. **`exports/tiktok_script_with_memes.md`** — Full script with meme inserts, timing cues, and production notes

Include a **Meme Placement Summary** table at the end:

```markdown
| Timestamp | Meme | Duration | Caption Overlay |
|-----------|------|----------|-----------------|
| Hook | [name] | 0.5s flash | — |
| ... | ... | ... | ... |
```

And **Production Notes** covering:
- Recommended total video length
- Flash vs hold guidance
- Which meme placement is most important
- Which frame is most shareable

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Script sounds like a report | Rewrite in spoken cadence. Short sentences. Fragments are fine. |
| No visual direction | Add [close-up], [pacing], [sit down], [lean in] cues |
| Memes are literal illustrations | Pick memes that contrast or reframe, not illustrate |
| Missing the twist | The twist is the primary scenario axis. Find it in critical_uncertainties.md |
| Too long | 3 minutes max. Cut the least surprising section. |
| No text-on-screen moments | Find 2-3 quotable phrases from specialist consultations |
| Generic tone | Match the user's voice from the worldview elicitation. Mirror their humor. |
| No sequel hook | Always name the four scenarios at the end |

## Tone Calibration

Read the worldview_model.md elicitation notes for the user's communication style. The script should sound like THEM, not like a narrator. If they're irreverent, be irreverent. If they're dry, be dry. The scenario process is serious; the TikTok should be fun.
