---
author: F
updated: 2026-08-09
status: active
---

# Art style and technical approach

> **This file:** Locked visual rules and the **technical approaches** behind look-dev plans A / B / E. Runnable demos and scene checklists live under [`art_style_demo/`](../../art_style_demo/) — do not duplicate file-level build steps here.

## Direction (locked for demos)

Two look-dev tracks (same theme/composition; different art language):

| Track | Language | Approaches |
|-------|----------|------------|
| A | Stylized hand-painted / soft illustrative (not photoreal) | `01`–`05` |
| B | Pixel art (nearest filter, integer scale) | `06_pixel_2d` |

| Item | Choice |
|------|--------|
| Mood | Cool long-night exterior; warm ember forge as the emotional key |
| Compare via | Same composition intent across techniques (`art_style_demo/`) |

## Decision snapshot (2026-08-09)

| Plan | Scope | Technical verdict | Demo / PR |
|------|--------|-------------------|-----------|
| **A** | `01_pseudo_perspective_2d` + `02_2d_lighting` | Approach sound | Demo not accepted; PR closed |
| **B** | `06_pixel_2d` | Approach sound | **Merged** ([#11](https://github.com/FFFpr/Ember-in-the-Night/pull/11)) — highest demo completeness |
| **E** | Same A-scope (`01` + `02`), parallel compare-pass stack | Approach sound (same thesis as A) | Demo not accepted; PR closed |
| C / D | Locked 3D / iso (and optional hybrid) | — | Not pursued for now |

Production look-dev continues from **Plan B** (pixel track) unless this doc is revised.

## References

AI-generated mood/framing only — **not** shippable or importable scene art:

**Track A:** [`workshop_fp_ref.png`](../../art_style_demo/references/workshop_fp_ref.png), [`street_day_ref.png`](../../art_style_demo/references/street_day_ref.png), [`street_night_ref.png`](../../art_style_demo/references/street_night_ref.png)

**Track B (pixel):** [`workshop_fp_pixel_ref.png`](../../art_style_demo/references/workshop_fp_pixel_ref.png), [`street_day_pixel_ref.png`](../../art_style_demo/references/street_day_pixel_ref.png), [`street_night_pixel_ref.png`](../../art_style_demo/references/street_night_pixel_ref.png)

## Asset sourcing

Demo (and later production look-dev) art must be taken from **free stores / free libraries**, **non-AI**, with an **open license** and credits. Full rules: [`art_style_demo/README.md`](../../art_style_demo/README.md) § Asset sourcing.

---

## Plan A — Soft illustrative 2D (`01` + `02`)

**Thesis:** Stay fully in a 2D canvas. Fake depth with authored perspective, layer splits, and z-order; then (in `02`) add a real 2D light/particle rig so day/night and forge warmth are lighting events, not only color swaps. Same locked FP workshop / shop-front street contracts as the other demos.

### `01` — Pseudo-perspective 2D

| Piece | Approach |
|-------|----------|
| Pipeline | `Node2D` scenes only; no `Light2D` in this approach |
| Depth | Drawn perspective + three layers: `LayerFar` (walls, window, forge mouth) → `LayerMid` (anvil, bellows, barrel, racks) → `LayerNear` (beams / hanging tools / FP bench edge) |
| Camera | Locked `Camera2D` at 1280×720 framing; optional tiny idle sway (a few px) |
| Street day/night | Time script or `AnimationPlayer`: t∈[0,10) day, [10,20) night; blend ≤0.5 s. Night = cooler root/`CanvasItem` modulate + warm **glow overlays** (door/window/lantern/forge spill). Camera transform unchanged |
| Art bar (compare pass) | Hero props and building masses are **pack `Sprite2D`s**. `Polygon2D` limited to sky wash and soft glow overlays — not coded prop silhouettes |

**Implementation shape (closed demo):** shared plate builder (`ArtDemoPlates`) assembled workshop/street from imported packs (LPC blacksmith props, Calciumtrice medieval tiles / panels, AmbientCG / similar texture panels, etc.), then `01` scenes called the builder and drove street night via modulate + glow visibility/alpha.

### `02` — 2D lighting & particles

| Piece | Approach |
|-------|----------|
| Layout | **Must reuse `01` plates/node layout** — compare lighting only |
| Ambient | Low `CanvasModulate` so local lights read |
| Forge | Warm `PointLight2D` with scripted energy flicker; soft glow polygon stays subtle under the light |
| FX | `GPUParticles2D` sparks (and optionally smoke) at the forge mouth |
| Street night | Prefer a **light rig** (drop ambient, enable window/lamp/forge `PointLight2D`s) rather than modulate-only, so `01` vs `02` is a fair flat-vs-lit pair |
| Optional | `DirectionalLight2D` for day fill; LightOccluder2D only if it helps pack art |

**Why the approach is still considered right:** it isolates “soft illustrative 2D space” from “pixel language” and from full 3D, and `01`→`02` is the smallest useful A/B inside Track A. The closed demos failed the visual bar (pack composition / readability), not the pipeline thesis.

---

## Plan B — Pixel 2D (`06_pixel_2d`) — selected

**Thesis:** Same workshop FP + street day/night contracts, but a separate **art-language track**: chunky pixel art with nearest filtering and integer scale so the framebuffer stays crisp.

| Piece | Approach |
|-------|----------|
| Internal resolution | Compose in **320×180**; `Camera2D.zoom = (4, 4)` into project 1280×720 |
| Filtering | Root + sprites `TEXTURE_FILTER_NEAREST`; no position smoothing on the camera |
| Sprite scale | Integer only (`1` or `2`) |
| Structure | Shared helpers (`pixel_demo_common.gd`) for locked camera, nearest sprites, and tiled wall/floor slices |
| Assets | LPC Blacksmith props + LPC Base Assets wall/floor/door/window slices under `art_style_demo/shared/imported/` (credited). Scenes must be **slice/prop-driven**, not large geometric stand-ins for hero architecture |
| Workshop light | Warm `PointLight2D` at the forge; must not soft-blur the pixel framebuffer |
| Street day/night | `day_night.gd`: 0–10 s day / 10–20 s night, ≤0.5 s fade. Swaps window textures (day ↔ night slices), lerps sky/mountain modulate, raises forge/window/door/lamp glow + shop `PointLight2D` energy at night. Same camera |

**Why this won the demo round:** imported-driven scenery, clear pixel read, and a complete unaided day→night street cycle met the review bar with higher completeness than the illustrative attempts. See merged scenes under [`art_style_demo/06_pixel_2d/`](../../art_style_demo/06_pixel_2d/).

---

## Plan E — Parallel illustrative compare pass (`01` + `02`)

**Thesis:** Same technical plan as **Plan A** (Track A soft illustrative; `01` depth layers without lights, `02` shared layout + `PointLight2D` / `GPUParticles2D`). Plan E was a second agent pass at that scope with a **different builder and pack stack**, not a different presentation mode (not iso / not hybrid / not pixel).

| Piece | Plan E stack (vs A) |
|-------|---------------------|
| Layout builders | `WorkshopLayout` / `StreetLayout` (+ `PlateUtil`) instead of A’s `ArtDemoPlates` |
| Surfaces | Poly Haven (or similar) **texture washes** for floor/wall/beam strips via textured rects; hero forge/anvil/tools still pack sprites |
| Hero props | LPC blacksmith prop set (kiln, fire, anvil, bellows, quench, benches, tools); street masses also Kenney / OGA iso smithy where used |
| Pixel-ish sprites in a soft scene | Pack sprites often forced `TEXTURE_FILTER_NEAREST` while the overall target remained soft illustrative — a tension that hurt the look bar |
| `02` lights | Shared `DemoLights`: radial `GradientTexture2D` cookies on `PointLight2D`, forge sparks + smoke `GPUParticles2D`, optional cool window fill light; forge energy flicker in `_process` |
| Street night | Same 20 s contract; light/glow path aligned with `02`’s “rig over modulate-only” intent |

**Why the approach is still considered right:** it reaffirms that Track A should be judged as layered 2D illustration plus a lighting pass, independently of Plan B’s pixel language. Closing Plan E (with Plan A) rejects the demos, not the `01`/`02` split.

---

## Deferred plans (not pursued for now)

| Plan | Scope | Note |
|------|--------|------|
| C | `04_locked_3d_camera` | Real meshes + locked `Camera3D`; deferred |
| D | `03_isometric` and/or `05_hybrid_2d_3d` | Iso tile/diamond or 2D shell + 3D hero via `SubViewport`; deferred |

Scaffold READMEs under `art_style_demo/` remain for reference only until look-dev priorities change.
