---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, or applications. Generates creative, polished code that avoids generic AI aesthetics.
license: Complete terms in LICENSE.txt
---

This skill guides creation of distinctive, production-grade frontend interfaces that avoid generic "AI slop" aesthetics. Implement real working code with exceptional attention to aesthetic details and creative choices.

The user provides frontend requirements: a component, page, application, or interface to build. They may include context about the purpose, audience, or technical constraints.

## Vibe Discovery (Do This First)

**BEFORE writing any code, run the Vibe Discovery process.** Don't pick from a menu. Derive a unique aesthetic from the real world.

### Step 1: Conversational Dig (Ask the User)

**Do NOT skip this.** Have an actual back-and-forth with the user. Ask these questions one or two at a time, not as a wall of text. Use their answers to generate follow-ups. The goal is to extract something *specific and personal* — not a generic category.

**Opening questions (ask first):**

**Q1: What's the vibe of this project in non-design terms?**
Push them away from design language. "Fast and chaotic like a kitchen during dinner rush" is better than "modern and clean." If they say something generic ("professional", "sleek"), push back: *"Professional like a law firm lobby, or professional like a SpaceX launch room? Those are very different vibes."*

**Q2: Who is the actual human using this, and what are they doing right before they open it?**
Context matters more than demographics. "A tired nurse checking schedules at 6am" gives you more than "healthcare professionals aged 25-45."

**Follow-up questions (based on their answers, pick 2-3):**

- "What's a physical space that has the same energy as what you're describing?" *(derive from THEIR words, don't suggest options)*
- "What would make someone screenshot this and send it to a friend?"
- "Is there a movie, album, restaurant, or store that has the feel you want?"
- "What's something you've seen recently that made you think 'yes, THAT energy'?"
- "What's the worst version of this? What would make you cringe?"

**If the user says "just pick something" or gives minimal input:**
Don't fall back on a static list. Instead, derive a reference from the *project itself*:
- What does the product DO? Find an unexpected real-world analog for that action.
- Who uses it? Imagine their world. What textures, colors, sounds exist there?
- What era or subculture would claim this product as their own?

### Step 2: Invent a Vibe (Don't Retrieve One)

**You must CREATE a new aesthetic direction every time.** Do not pattern-match to categories you've seen before. Do not mentally scan a list of "aesthetic styles" and pick the closest one.

**The Collision Method:**
Take TWO things from the user's answers that don't obviously go together and smash them:
1. Pick a **physical texture or material** from their world (concrete, linen, chrome, cardboard, velvet, terracotta, acrylic, denim)
2. Pick an **energy or movement quality** from their description (frenetic, glacial, bouncy, surgical, tidal, flickering, heavy, weightless)
3. Combine them into something that doesn't exist yet: "Velvet Frenetic", "Cardboard Surgical", "Chrome Tidal"

This is your vibe seed. Everything else derives from it.

**Q3 (internal — don't ask the user): What should this NEVER be mistaken for?**
Based on the conversation, identify 2-3 anti-patterns. Use these as guardrails, not the user's problem to solve.

### Step 3: Derive the Aesthetic From the Vibe Seed

Take your invented vibe and derive EACH element from it. Do NOT consult the Aesthetic Reference Library yet — that's for implementation details later, not for direction-setting.

- **Colors**: Close your eyes (metaphorically). What colors exist in the collision you invented? "Velvet Frenetic" → deep burgundy meeting electric yellow. "Cardboard Surgical" → kraft brown meeting clinical white with a sharp teal accent. Extract 3-4 colors. Invent fresh hex codes. Name the palette after the vibe, not a generic mood ("Scrubbed Kraft", "Bruised Neon", "Soft Concrete").
- **Typography**: What does text FEEL like in this vibe? Heavy and planted? Thin and nervous? Hand-drawn and loose? Search Google Fonts with the vibe's energy, not with a category. If your first instinct is a font you've used before, discard it and keep looking.
- **Layout**: How does the vibe's material organize space? Velvet drapes — layered, overlapping. Cardboard — flat, stacked, visible edges. Chrome — reflective, minimal, precise. Let the material metaphor drive layout choices.
- **Motion**: How does the vibe's energy quality move? Frenetic = jittery micro-movements. Glacial = slow parallax. Surgical = precise snap-to. Tidal = rhythmic ease-in-out. Pick ONE signature motion that embodies the energy word.

### Step 4: Write a Vibe Spec

Before coding, write this out:

```
VIBE NAME: [your invented collision name, e.g. "Velvet Frenetic"]
MATERIAL: [the physical texture/material driving the visual language]
ENERGY: [the movement quality driving interaction and motion]
USER CONTEXT: [who they are, what they were doing 5 minutes ago]
ANTI-PATTERNS: [what this must never be confused with]

COLORS: [hex codes + why each color, named palette derived from the material/energy]
TYPOGRAPHY: [specific font names + why they fit THIS vibe, not a category]
LAYOUT: [how the material organizes space — one signature structural choice]
MOTION: [how the energy moves — one signature animation]
WILDCARD: [one unexpected detail that doesn't "match" but makes it memorable]
```

### Step 5: Freshness Check

Before proceeding, verify:
- [ ] My vibe name is something I've NEVER used before
- [ ] I did NOT reuse hex codes from previous projects
- [ ] I did NOT default to my comfortable fonts (Inter? Space Grotesk? JetBrains Mono? Monospace-on-dark? Start over.)
- [ ] The material + energy collision is actually visible in my design choices
- [ ] Someone could NOT mistake this for previous work
- [ ] I included a wildcard that surprises even me
- [ ] The user's actual words and context are driving the aesthetic, not a category I pattern-matched to
- [ ] I did NOT mentally scan a list of "aesthetic styles" and pick the closest one

### When Context Is Minimal

If the user just says "build me a page" with no specifics, you STILL do the conversational dig. Ask:
1. "What's this for? Even one sentence helps."
2. "What's the energy — fast and loud, or slow and quiet, or something else entirely?"
3. "What would make you hate it?"

If they truly refuse to engage, derive from the PROJECT CONTENT itself — what the thing does, who it serves, what world it lives in. Never fall back on a preset list of vibes.

### Generating Fresh References (When You Need Physical-World Anchors)

**Do NOT use a static list.** Instead, use this generative process:
1. Take the user's domain/product and think: "What's a surprising real-world analog for this ACTION?"
   - A task manager → an air traffic control tower? a short-order cook's ticket rail? a librarian's card catalog?
2. Think about the USER's physical context: "Where are they when they use this? What does that space smell/sound/feel like?"
3. Think about TIME: "When in the day/week/year does this get used? What's the light like? The mood?"
4. Combine the most interesting answers into your material + energy collision.

---

Then implement working code (HTML/CSS/JS, React, Vue, etc.) that is:
- Production-grade and functional
- Visually striking and memorable
- Cohesive with a clear aesthetic point-of-view
- Meticulously refined in every detail

## Frontend Aesthetics Guidelines

Focus on:
- **Typography**: Choose fonts that are beautiful, unique, and interesting. Avoid generic fonts like Arial and Inter; opt instead for distinctive choices that elevate the frontend's aesthetics; unexpected, characterful font choices. Pair a distinctive display font with a refined body font.
- **Color & Theme**: Commit to a cohesive aesthetic. Use CSS variables for consistency. Dominant colors with sharp accents outperform timid, evenly-distributed palettes.
- **Motion**: Use animations for effects and micro-interactions. Prioritize CSS-only solutions for HTML. Use Motion library for React when available. Focus on high-impact moments: one well-orchestrated page load with staggered reveals (animation-delay) creates more delight than scattered micro-interactions. Use scroll-triggering and hover states that surprise.
- **Spatial Composition**: Unexpected layouts. Asymmetry. Overlap. Diagonal flow. Grid-breaking elements. Generous negative space OR controlled density.
- **Backgrounds & Visual Details**: Create atmosphere and depth rather than defaulting to solid colors. Add contextual effects and textures that match the overall aesthetic. Apply creative forms like gradient meshes, noise textures, geometric patterns, layered transparencies, dramatic shadows, decorative borders, custom cursors, and grain overlays.

NEVER use generic AI-generated aesthetics like overused font families (Inter, Roboto, Arial, system fonts), cliched color schemes (particularly purple gradients on white backgrounds), predictable layouts and component patterns, and cookie-cutter design that lacks context-specific character. ALSO avoid the "anti-slop" cliche: dark backgrounds with monospace fonts and neon green/cyan/magenta accents (terminal/hacker aesthetic) is just as overplayed and lazy as purple-on-white. It is not edgy or distinctive - it is the default fallback when trying too hard to avoid looking generic.

Interpret creatively and make unexpected choices that feel genuinely designed for the context. No design should be the same. Vary between light and dark themes, different fonts, different aesthetics. NEVER converge on common choices (Space Grotesk, JetBrains Mono, Fira Code, for example) across generations.

## Aesthetic Reference Library (Implementation Raw Materials ONLY)

**STOP. If you haven't completed Vibe Discovery above, go back.** This library is NOT a menu of vibes to pick from. It is a parts bin — font names, hex codes, and CSS techniques you can cannibalize AFTER you've invented your own direction.

**Rules for using this library:**
- You MUST have a completed Vibe Spec before looking here
- Cherry-pick individual techniques or font pairings that serve YOUR vibe
- NEVER adopt a whole section as your aesthetic — that's the exact problem this skill exists to prevent
- If your final design maps cleanly to one of these categories, you failed the Vibe Discovery process. Start over.

### Warm / Organic
Think: bakery website, ceramics studio, wellness brand, farm-to-table restaurant
- **Fonts**: Fraunces (display) + Libre Baskerville (body), or Playfair Display + Source Serif Pro
- **Palette**: `#D4A373` warm sand, `#FAEDCD` cream, `#CCD5AE` sage, `#E9EDC9` soft olive, `#3D405B` deep slate
- **Layout**: Flowing, asymmetric sections with generous whitespace. Overlapping rounded images. Text wrapping around organic shapes.
- **CSS techniques**: `border-radius: 40% 60% 55% 45% / 60% 40% 45% 55%` for blob shapes, subtle `backdrop-filter: blur()`, warm `box-shadow` with brown tones, `mix-blend-mode: multiply` on overlapping photos

### Luxury / Refined
Think: high-end hotel, jewelry brand, architecture firm, premium spirits
- **Fonts**: Cormorant Garamond (display) + Montserrat 300-weight (body), or Bodoni Moda + DM Sans
- **Palette**: `#1A1A1A` near-black, `#F5F0EB` warm white, `#C9A96E` muted gold, `#4A4A4A` charcoal, `#8B7355` bronze
- **Layout**: Extreme whitespace. Full-bleed hero images. Text set very large and very light-weight. Horizontal scroll sections. Elements placed with mathematical precision.
- **CSS techniques**: `letter-spacing: 0.3em` on uppercase labels, `font-weight: 200`, hairline borders (`0.5px`), smooth `scroll-snap-type`, images with `aspect-ratio: 3/4`, `mix-blend-mode: luminosity`

### Playful / Toy-like
Think: children's app, party supply store, casual mobile game, snack brand
- **Fonts**: Baloo 2 (display) + Nunito (body), or Fredoka One + Quicksand
- **Palette**: `#FF6B6B` coral, `#4ECDC4` teal, `#FFE66D` sunny yellow, `#F7FFF7` mint white, `#2C3E50` grounding navy
- **Layout**: Tilted cards (`transform: rotate(-2deg)`), stacked/overlapping elements, big chunky buttons with visible borders, intentional "messiness."
- **CSS techniques**: `border: 3px solid`, thick `box-shadow: 6px 6px 0 #000` for pop-out effect, `border-radius: 1rem`, bouncy `cubic-bezier(0.34, 1.56, 0.64, 1)` transitions, wiggle `@keyframes` on hover, hand-drawn SVG borders

### Art Deco / Geometric
Think: cocktail bar, jazz venue, museum exhibition, luxury stationery
- **Fonts**: Poiret One (display) + Raleway (body), or Josefin Sans + Lato
- **Palette**: `#0D1B2A` midnight blue, `#D4AF37` true gold, `#1B2838` dark teal, `#F0E6D3` parchment, `#C41E3A` ruby accent
- **Layout**: Strong symmetry. Geometric dividers (chevrons, fan shapes). Layered borders and frames around content. Centered, formal composition.
- **CSS techniques**: Repeating SVG patterns as backgrounds, `clip-path: polygon()` for angular sections, `linear-gradient` used for geometric stripes, gold `border-image`, CSS `columns` for text, ornamental `::before`/`::after` pseudo-elements

### Soft / Pastel / Dreamy
Think: skincare brand, meditation app, baby products, stationery shop
- **Fonts**: Outfit (display) + Karla (body), or Sora + IBM Plex Sans
- **Palette**: `#E8D5F5` lavender, `#F5E6CC` peach, `#D4E8E0` mint, `#FFF5F5` blush white, `#5C5470` muted purple
- **Layout**: Rounded everything. Floating cards with soft shadows. Generous padding. Content feels like it's resting on clouds.
- **CSS techniques**: `box-shadow: 0 20px 60px rgba(0,0,0,0.05)`, large `border-radius: 2rem`, subtle `background: linear-gradient(135deg, ...)` behind sections, `backdrop-filter: blur(20px)` glassmorphism but with pastel tints not dark glass, `filter: saturate(0.9)` for softness

### Retro-Futuristic / Sci-Fi
Think: space tourism, vintage tech revival, synth music, concept car reveal
- **Fonts**: Orbitron (display) + Exo 2 (body), or Audiowide + Rajdhani
- **Palette**: `#0A0E27` void blue, `#FF6F61` retro coral, `#E8D44D` signal yellow, `#2DE2E6` electric cyan, `#F5E6CA` analog cream
- **Layout**: Asymmetric grid with angled dividers. Data-viz inspired decorative elements (arcs, circles, grid overlays). Split-screen compositions.
- **CSS techniques**: `conic-gradient()` for radar/dial effects, animated `stroke-dashoffset` on SVG circles, `clip-path` angled sections, scanline overlay with repeating-linear-gradient, `text-shadow` glow with theme accent, CSS `counter()` for numbering sections

### Editorial / Magazine
Think: longform journalism, fashion lookbook, photo essay, cultural review
- **Fonts**: Playfair Display (headlines) + Charter or Lora (body), or DM Serif Display + Atkinson Hyperlegible
- **Palette**: `#1A1A1A` rich black, `#FAFAF7` warm off-white, `#C41E3A` editorial red, `#6B705C` olive grey, `#E8E0D5` newsprint
- **Layout**: Multi-column text. Pull quotes in oversized italic. Full-bleed images breaking the grid. Drop caps. Sidebar annotations.
- **CSS techniques**: CSS `columns: 2` with `column-rule`, `float` for pull quotes with `shape-outside`, `initial-letter: 3` for drop caps, large `font-size: clamp(3rem, 8vw, 7rem)` headlines, `mix-blend-mode: difference` for text over images, `hyphens: auto`

### Maximalist / Eclectic
Think: street festival, record store, zine, independent fashion label
- **Fonts**: Unbounded (display) + Space Mono (body), or Rubik Glitch + Work Sans
- **Palette**: `#FF3366` hot pink, `#33FF57` electric green, `#FFD700` gold, `#1A1A2E` deep purple-black, `#FF6B35` tangerine — use ALL of them boldly
- **Layout**: Overlapping layers. Rotated elements. Mixed grid sizes. Collage-like composition. Things intentionally "breaking" out of containers.
- **CSS techniques**: `mix-blend-mode: screen` and `difference` on overlapping elements, `transform: rotate()` scattered, CSS `mask-image` for cutout effects, layered `position: absolute` compositions, `animation` running perpetually on decorative elements, clashing `font-size` contrasts (12px next to 120px)

### Industrial / Utilitarian
Think: construction company, warehouse sale, municipal service, maker space
- **Fonts**: IBM Plex Mono (labels) + IBM Plex Sans (body), or Overpass Mono + Overpass
- **Palette**: `#F5F5F0` concrete, `#333333` asphalt, `#FFB800` caution yellow, `#E63946` safety red, `#457B9D` steel blue
- **Layout**: Visible grid structure. Labels and metadata exposed. Numbered sections. Dense but organized information hierarchy.
- **CSS techniques**: Visible `outline: 1px dashed` on grid cells, `text-transform: uppercase` with wide `letter-spacing` on labels, `font-variant-numeric: tabular-nums`, `border-left: 4px solid` accent bars, monochrome photos with `filter: grayscale(1)`, data-attribute-driven `::before` content labels

**IMPORTANT**: Match implementation complexity to the aesthetic vision. Maximalist designs need elaborate code with extensive animations and effects. Minimalist or refined designs need restraint, precision, and careful attention to spacing, typography, and subtle details. Elegance comes from executing the vision well.

## Choosing an Aesthetic

When selecting a direction, consider **what the content actually is**. A restaurant doesn't need to look like a SaaS dashboard. A personal blog doesn't need to look like a developer portfolio. Let the subject matter drive the aesthetic, not your default comfort zone.

**Roll the dice.** If your instinct says "dark background," go light. If you reach for monospace, pick a serif. If you're about to use a card grid, try a magazine layout. Fight your own patterns.

Remember: Claude is capable of extraordinary creative work. Don't hold back, show what can truly be created when thinking outside the box and committing fully to a distinctive vision.