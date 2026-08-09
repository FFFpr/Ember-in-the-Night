---
author: F
updated: 2026-08-09
status: active
---

# Development log

## 2026-08-09T05:51:00Z

### Progress

- Merged **PR #11** (Plan B / `06_pixel_2d`) because that demo had the highest completeness against the look-dev review bar.
- Closed the other art-demo PRs (Plan A [#7](https://github.com/FFFpr/Ember-in-the-Night/pull/7), Plan E [#10](https://github.com/FFFpr/Ember-in-the-Night/pull/10), Plan C [#9](https://github.com/FFFpr/Ember-in-the-Night/pull/9), Plan D [#8](https://github.com/FFFpr/Ember-in-the-Night/pull/8)).
- **Plan A** and **Plan E**: technical approach is still considered correct (soft illustrative `01` + lit `02`); demos were not good enough after iteration, so those PRs are closed.
- **Plans C / D** (and other non-B scopes): not considered for now.
- Documented Plan A / B / E technical approaches in [`docs/tech/art-style.md`](tech/art-style.md).

### Todo

- Continue look-dev from the merged Plan B pixel track (`06_pixel_2d`) unless direction changes.
- No further work on Plan A / E demo PRs or on Plan C / D unless reopened in this log.

## 2026-08-08T08:30:00Z

### Progress

- **PR B (`06_pixel_2d`)**: runnable `workshop/workshop.tscn` + `street/street.tscn` (320×180 @ 4×, nearest filter, locked cameras).
- Street day/night via `day_night.gd` (0–10 s day / 10–20 s night, fade ≤0.5 s).
- Imported non-AI packs under `art_style_demo/shared/imported/`: `lpc_blacksmith`, `lpc_base_assets` (LICENSE + credits).

### Todo

- ~~Implement remaining approach demos per PR split (A, then C; D optional).~~ Superseded 2026-08-09: only Plan B kept.
- Review `06` in Godot 4.7 (F6); compare with Track A once A lands.

## 2026-08-08T04:10:47Z

### Progress

- Root `README.md`: linked official Godot 4.7 docs (home, performance, best practices, engine details).
- `art_style_demo/`: scaffolds + **agent build brief** (locked palette/composition, file conventions, done checklist).
- Reference images under `art_style_demo/references/` (illustrative + pixel tracks).
- Added approach `06_pixel_2d` (pixel track; nearest filter / integer scale).
- `docs/tech/art-style.md`: two look-dev tracks; points at the demo brief.

### Todo

- Implement runnable demos per `art_style_demo/README.md` (each: `workshop/workshop.tscn` + `street/street.tscn`, day 0–10s / night 10–20s).
- Gather **free-store, non-AI, open-licensed** art into `art_style_demo/shared/imported/` (credits/LICENSE required; do not use AI `references/` as scene art).
- Review in Godot 4.7 (F6 per scene); pick a production direction.

#### PR split (historical — superseded 2026-08-09)

> Outcome: only **PR B** merged; Plan A / E demos closed (approach kept in tech docs); C / D not pursued for now. See the 2026-08-09 entry and [`tech/art-style.md`](tech/art-style.md).

| PR | Scope | Why together |
|----|--------|----------------|
| **PR A** (also Plan E parallel) | `01_pseudo_perspective_2d` + `02_2d_lighting` | Same layout; `02` must clone `01`. Smallest useful compare (flat vs lit). |
| **PR B** | `06_pixel_2d` | Separate art-language track + different packs/filter rules; can start after A or in parallel once pixel packs are chosen. |
| **PR C** | `04_locked_3d_camera` | 3D greybox/FP pipeline; contrasts with 2D without depending on A’s plates. |
| **PR D** (optional) | `03_isometric` and/or `05_hybrid_2d_3d` | Only if A–C still leave the direction unclear. Prefer **one approach per PR** here (`03` then `05`, or skip). |

Rules for each implementation PR (applied while the split was active):

- One agent pass ≈ one PR row above (A is the only intentional two-approach bundle).
- Include pack credits under `shared/imported/` in the same PR that first uses the pack.
- Do not mix Track A illustrative scenes and Track B pixel scenes in the same PR except shared docs.
- Current docs/refs PR (`art_style_demo` scaffolds) stays separate from runnable-scene PRs.

## 2026-08-07T16:57:10Z

### Progress

- Godot 4.7 project scaffolded: hammer physics demo (`entities/`, `systems/`, `levels/test_scene.tscn`).
- Design docs tree and Cursor / cloud agent setup are in place.
- `gda` (Godot Agent) CLI + MCP verified against the main scene; live harness committed.

### Todo

- On the user's local machine: start the agent and sync / configure the environment.
