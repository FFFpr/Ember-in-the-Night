# 06 — Pixel 2D

Parent brief: [`../README.md`](../README.md). Pixel mood refs: [`../references/`](../references/) (`*_pixel_ref.png`).

## Technique

Classic **pixel-art 2D** (chunky pixels, limited palette), same workshop FP + street day/night contracts as other approaches. This is a **separate art-language track** from `01`–`05` (hand-painted / soft illustrative).

## Pixel rules (this approach only)

| Rule | Value |
|------|--------|
| Look | Visible pixels; SNES / indie pixel RPG read |
| Texture filter | **Nearest** on all pixel sprites/tiles (`CanvasItemTextureFilter` nearest / import filter off) |
| Scale | Integer scale into 1280×720 (e.g. internal 320×180 @ 4×, or 640×360 @ 2×). Avoid non-integer stretch on pixel layers |
| Camera | Locked; no smooth sub-pixel jitter that blurs tiles (camera pixel-snap recommended) |
| Lights | Optional `Light2D` OK if it stays readable; do not soft-blur the whole framebuffer into a painted look |
| Assets | Free-store **non-AI** pixel packs only (see parent Asset sourcing) |

## Implementation notes

- Internal layout: **320×180**, `Camera2D.zoom = (4, 4)` → 1280×720 integer scale.
- Root `texture_filter = nearest`; no camera smoothing.
- Packs: [`../shared/imported/lpc_blacksmith/`](../shared/imported/lpc_blacksmith/), [`../shared/imported/lpc_base_assets/`](../shared/imported/lpc_base_assets/) (credits in each `LICENSE.txt`).
- Street day/night: `street/day_night.gd` (0–10 day, 10–20 night, ≤0.5 s fade).

## Build steps (workshop)

1. `workshop/workshop.tscn`, root `Workshop` (`Node2D`).
2. Locked `Camera2D`; frame like `references/workshop_fp_pixel_ref.png` (FP at bench → forge + anvil).
3. Layers or TileMap for walls/floor; sprites for forge, anvil, bellows, rack, barrel, horseshoes, beams.
4. Warm forge colors vs cool room corners; animated forge coals optional (few-frame pixel sheet).
5. Enable nearest filtering on every pixel texture.

## Build steps (street)

1. `street/street.tscn`, root `Street`; locked camera matching pixel street refs.
2. Facade + cobbles + barrels; day/night 20 s autostart.
3. Night = palette/modulate + lit window/door/lamp pixels (warm), not a camera cut.

## Done when

- [x] Clearly reads as **pixel art** (not the painted `01` look)
- [x] Nearest filtering; no accidental bilinear mush
- [x] F6 workshop + street; street day→night unaided
- [x] Props list satisfied; credits under `shared/imported/`
