# Art style demos — build brief

Scaffold + **construction rules** for comparing presentation approaches. An agent with no prior chat context should be able to implement from this file and the per-approach READMEs.

Theme: forge fire / long night / ember. Design: [`docs/design/theme.md`](../docs/design/theme.md). Visual lock: [`docs/tech/art-style.md`](../docs/tech/art-style.md).

## Goal

Ship **runnable** Godot 4.7 scenes under `art_style_demo/` so a human can open each approach and compare look. These are **look-dev demos**, not gameplay.

## Locked visual rules (all approaches)

| Rule | Value |
|------|--------|
| Viewport | **1280×720**, stretch mode already project-wide (`canvas_items` / `expand`) |
| Aspect | Compose for **16:9** |
| Art language | **Two tracks** — see below |
| Palette | Cool “long night” blues/greys outside; **warm ember** oranges/ambers on forge and night windows |
| Workshop camera | **First-person at the bench**: locked, looking at forge + anvil (see references). No free look. Optional tiny idle sway only (pixel track: prefer pixel-snap, no blurry sway). |
| Street camera | **Fixed shop-front framing** (same camera day and night) |
| Street time | **0–10 s day**, **10–20 s night**, then loop or stop; transition ≤0.5 s fade OK |
| Fair compare | Same prop *set* and same *composition intent* across approaches; only the presentation / art language changes |

### Art-language tracks

| Track | Approaches | Language |
|-------|------------|----------|
| A — Soft illustrative | `01`–`05` | Stylized hand-painted / soft illustrative — **not** photoreal |
| B — Pixel | `06_pixel_2d` | Chunky pixel art, nearest filter, integer scale — **not** smooth painted |

### Required props (workshop)

Forge/hearth, anvil, bellows, tool rack (hammers/tongs), quench barrel, ore or ingots, hanging horseshoes, dim rafters/beams. Optional: small cold window.

### Required read (street)

Smithy facade + door, simple hanging sign, a few street props (barrels/crates), cobbles or dirt road, neighboring building masses. Night must read via **light/palette**, not a different camera.

## Reference images (mood only — not game art)

### Track A (illustrative)

| File | Use as |
|------|--------|
| [`references/workshop_fp_ref.png`](references/workshop_fp_ref.png) | Workshop FP composition + forge/anvil mood |
| [`references/street_day_ref.png`](references/street_day_ref.png) | Street day framing / palette |
| [`references/street_night_ref.png`](references/street_night_ref.png) | Street night framing / warm spill |

### Track B (pixel)

| File | Use as |
|------|--------|
| [`references/workshop_fp_pixel_ref.png`](references/workshop_fp_pixel_ref.png) | Pixel workshop FP mood |
| [`references/street_day_pixel_ref.png`](references/street_day_pixel_ref.png) | Pixel street day |
| [`references/street_night_pixel_ref.png`](references/street_night_pixel_ref.png) | Pixel street night |

These PNGs are **AI-generated framing/mood guides**. They are **not** shippable assets: do not import them into scenes, do not trace them into production art, do not treat them as license-cleared pack art.

Match silhouette placement and warm/cool split more than brushwork. For `06`, prefer real pixel packs over chasing the AI pixel refs’ exact look.

## Asset sourcing (mandatory for demo art)

All textures, sprites, tilesets, meshes, and audio used in `art_style_demo/` scenes must come from **free store / free library packs that are non-AI and openly licensed** (e.g. CC0, CC-BY with credit, MIT/similar asset licenses).

| Allowed | Forbidden |
|---------|-----------|
| Human-authored free packs from stores/libraries (Kenney, OpenGameArt, itch.io free non-AI, Poly Haven, Godot Asset Library free packs, etc.) | AI-generated images/models as scene art (including the files under `references/`) |
| Engine primitives / solid-color placeholders while blocking | Paid packs unless the project explicitly clears them later |
| Clear license + credit recorded under `shared/imported/` | Scraped web images; “free” packs with unclear or AI-only provenance |

When importing a pack:

1. Put files under `art_style_demo/shared/imported/<pack_name>/`.
2. Add `LICENSE.txt` or a short credit blurb (author, license, URL, non-AI / human-authored note if the store states it).
3. Prefer packs that state they are **not AI-generated**; if provenance is unclear, skip and pick another pack.

## Approaches

| Dir | Technique | Depends on |
|-----|-----------|------------|
| [`01_pseudo_perspective_2d/`](01_pseudo_perspective_2d/) | 2D layers, parallax, Y-sort / z-index | — |
| [`02_2d_lighting/`](02_2d_lighting/) | 01 spatial language + Light2D + particles | **Must reuse 01 plates/layout** |
| [`03_isometric/`](03_isometric/) | Iso tilemap / diamond grid | Own layout; same props |
| [`04_locked_3d_camera/`](04_locked_3d_camera/) | 3D meshes, locked FP / tripod cam | Own greybox→art |
| [`05_hybrid_2d_3d/`](05_hybrid_2d_3d/) | 2D shell + 3D hero props | Prefer 01/02 plates + 3D anvil/forge |
| [`06_pixel_2d/`](06_pixel_2d/) | Pixel-art 2D (nearest, integer scale) | Own pixel packs; parallel track |

**Out of scope:** Mode7 ground projection.

## File & scene conventions

For each approach `NN_name/`:

```text
NN_name/
  README.md                 # technique notes (already present; keep in sync)
  workshop/
    README.md
    workshop.tscn           # REQUIRED when implemented — main scene to F6
    workshop.gd             # optional
  street/
    README.md
    street.tscn             # REQUIRED when implemented — main scene to F6
    day_night.gd            # or AnimationPlayer; must drive 20 s cycle
```

Shared placeholders (optional, preferred):

```text
art_style_demo/shared/
  placeholders/             # colored rects / primitive meshes OK
  imported/<pack_name>/     # free, non-AI, open-licensed packs + LICENSE/credits
```

Naming: snake_case paths; scene root node named `Workshop` or `Street`.

Do **not** change `project.godot` `run/main_scene` for these demos — open with F6 / “Run Current Scene”.

## Placeholder policy

| Stage | Allowed |
|-------|---------|
| First pass | Solid-color plates, primitive meshes, labeled `Sprite2D` regions (no external art yet) |
| Compare pass | Free-store **non-AI** open-licensed packs under `shared/imported/` with credits |
| Forbidden | AI art in scenes; unlicensed scraped art; unclear-provenance “free” packs; day/night as editor-only toggle |

Placeholders must still hit composition (forge/anvil readable; street facade readable).

## Day/night contract (`street.tscn`)

- Autostart on `_ready` (or Autoplay animation).
- t∈[0,10): day look; t∈[10,20): night look.
- Same `Camera2D` / `Camera3D` transform for both.
- Implement with `AnimationPlayer`, `Tween`, or a tiny script + timer — pick one per approach and document in that approach README if non-obvious.

## Done checklist (per approach)

- [ ] `workshop/workshop.tscn` runs (F6), locked camera, required props visible
- [ ] `street/street.tscn` runs (F6), day 10 s → night 10 s without input
- [ ] Matches reference framing intent (workshop FP; street shop-front)
- [ ] Warm forge / night spill vs cool ambient readable
- [ ] No free look / no gameplay systems required
- [ ] Any third-party art is free-store, **non-AI**, open-licensed, credited under `shared/imported/`
- [ ] No AI-generated files from `references/` (or elsewhere) used as scene textures/meshes
- [ ] If `06`: nearest filtering + integer scale; reads as pixel, not painted

## Implementation order

Historical compare order (superseded 2026-08-09 — only Plan B shipped):

1. `01` workshop + street (placeholders OK)  
2. `02` clone 01 layout, add lights/particles  
3. `06` pixel track (can proceed in parallel with 01/02 once packs are chosen)  
4. `04` greybox FP workshop + street cycle  
5. `03` / `05` only if still needed for the comparison

Current direction: continue from merged `06_pixel_2d` unless [`docs/tech/art-style.md`](../docs/tech/art-style.md) / the development log reopen other plans.  

## Status

| Item | State |
|------|--------|
| Build brief + references | Done (incl. pixel track) |
| Runnable `.tscn` | **Plan B** `06_pixel_2d` workshop + street merged; Plan A / E illustrative demos closed; C / D not pursued for now ([`docs/tech/art-style.md`](../docs/tech/art-style.md), [`docs/development-log.md`](../docs/development-log.md)) |
| Imported art packs | LPC Blacksmith + LPC Base Assets under `shared/imported/` drive `06` walls/floors/props |
