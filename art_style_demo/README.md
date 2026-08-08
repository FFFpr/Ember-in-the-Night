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
| Art language | **Stylized hand-painted / soft illustrative** — not pixel art, not photoreal |
| Palette | Cool “long night” blues/greys outside; **warm ember** oranges/ambers on forge and night windows |
| Workshop camera | **First-person at the bench**: locked, looking at forge + anvil (see references). No free look. Optional tiny idle sway only. |
| Street camera | **Fixed shop-front framing** (same camera day and night) |
| Street time | **0–10 s day**, **10–20 s night**, then loop or stop; transition ≤0.5 s fade OK |
| Fair compare | Same prop *set* and same *composition intent* across approaches; only the presentation technique changes |

### Required props (workshop)

Forge/hearth, anvil, bellows, tool rack (hammers/tongs), quench barrel, ore or ingots, hanging horseshoes, dim rafters/beams. Optional: small cold window.

### Required read (street)

Smithy facade + door, simple hanging sign, a few street props (barrels/crates), cobbles or dirt road, neighboring building masses. Night must read via **light/palette**, not a different camera.

## Reference images

| File | Use as |
|------|--------|
| [`references/workshop_fp_ref.png`](references/workshop_fp_ref.png) | Workshop FP composition + forge/anvil mood |
| [`references/street_day_ref.png`](references/street_day_ref.png) | Street day framing / palette |
| [`references/street_night_ref.png`](references/street_night_ref.png) | Street night framing / warm spill |

References are **mood and framing guides**, not pixel-perfect targets. Match silhouette placement and warm/cool split more than exact brushwork.

## Approaches

| Dir | Technique | Depends on |
|-----|-----------|------------|
| [`01_pseudo_perspective_2d/`](01_pseudo_perspective_2d/) | 2D layers, parallax, Y-sort / z-index | — |
| [`02_2d_lighting/`](02_2d_lighting/) | 01 spatial language + Light2D + particles | **Must reuse 01 plates/layout** |
| [`03_isometric/`](03_isometric/) | Iso tilemap / diamond grid | Own layout; same props |
| [`04_locked_3d_camera/`](04_locked_3d_camera/) | 3D meshes, locked FP / tripod cam | Own greybox→art |
| [`05_hybrid_2d_3d/`](05_hybrid_2d_3d/) | 2D shell + 3D hero props | Prefer 01/02 plates + 3D anvil/forge |

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
  imported/                 # free/open packs go here after license note
```

Naming: snake_case paths; scene root node named `Workshop` or `Street`.

Do **not** change `project.godot` `run/main_scene` for these demos — open with F6 / “Run Current Scene”.

## Placeholder policy

| Stage | Allowed |
|-------|---------|
| First pass | Solid-color plates, primitive meshes, Kenney-style blocks, labeled `Sprite2D` regions |
| Compare pass | Free/open pack art (license file or README credit under `shared/imported/`) |
| Forbidden | Unlicensed scraped art; leaving day/night as a manual editor toggle only |

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
- [ ] Credits for any third-party art listed under `shared/imported/` or approach README

## Implementation order

1. `01` workshop + street (placeholders OK)  
2. `02` clone 01 layout, add lights/particles  
3. `04` greybox FP workshop + street cycle  
4. `03` / `05` only if still needed for the comparison  

## Status

| Item | State |
|------|--------|
| Build brief + references | Done |
| Runnable `.tscn` | Not started |
| Imported art packs | Not started |
