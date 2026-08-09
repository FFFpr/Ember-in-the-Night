---
author: F
updated: 2026-08-08
status: active
---

# Development log

## 2026-08-09T05:35:00Z

### Progress

- **PR D** denser pack-art pass: more Feudal Wars buildings (barracks/stable/archery), more rubberduck ground/prop slices; workshop/street rebuilt so pack sprites/tiles fill the viewport. Geometric scenery limited to sky wash + glow cookies per updated review bar.

## 2026-08-09T05:15:00Z

### Progress

- **PR D compare pass** (`03_isometric`): replaced solid-color placeholders with free CC0 pack art.
  - Imported under `art_style_demo/shared/imported/`: `feudalwars_iso_medieval`, `rubberduck_iso_ground`, `rubberduck_iso_medieval_props` — each with `LICENSE.txt`.
  - Workshop/street rebuild to read as smithy street + close-iso forge–anvil cluster; day/night unchanged contract.

### Todo

- Attach/review screenshots on the PR; merge when compare-pass bar is satisfied.
- `05_hybrid_2d_3d` only if still needed after reviewing `03`.
- Remaining look-dev PRs A/B/C per table below.

## 2026-08-08T08:25:00Z

### Progress

- **PR D** (`03_isometric`): runnable placeholder workshop + street scenes.
  - `workshop/workshop.tscn` — locked iso camera on forge–anvil; required props as solid-color diamond/box placeholders.
  - `street/street.tscn` — shop-front strip; day 0–10s / night 10–20s via `AnimationPlayer` (`World.modulate` + `Emissives` overlays so night windows stay warm).
  - Shared helper: `art_style_demo/shared/placeholders/iso_draw.gd`.

### Todo

- Import free-store non-AI packs for `03` compare pass (optional follow-up).
- `05_hybrid_2d_3d` only if still needed after reviewing `03`.
- Remaining look-dev PRs A/B/C per table below.

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

#### PR split (do not ship all demos in one PR)

| PR | Scope | Why together |
|----|--------|----------------|
| **PR A** | `01_pseudo_perspective_2d` + `02_2d_lighting` | Same layout; `02` must clone `01`. Smallest useful compare (flat vs lit). |
| **PR B** | `06_pixel_2d` | Separate art-language track + different packs/filter rules; can start after A or in parallel once pixel packs are chosen. |
| **PR C** | `04_locked_3d_camera` | 3D greybox/FP pipeline; contrasts with 2D without depending on A’s plates. |
| **PR D** (optional) | `03_isometric` and/or `05_hybrid_2d_3d` | Only if A–C still leave the direction unclear. Prefer **one approach per PR** here (`03` then `05`, or skip). |

Rules for each implementation PR:

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
