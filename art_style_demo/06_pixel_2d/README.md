# 06 — Pixel 2D

Parent brief: [`../README.md`](../README.md). Pixel mood refs: [`../references/`](../references/) (`*_pixel_ref.png`).

## Technique

Classic **pixel-art 2D** (chunky pixels, limited palette), same workshop FP + street day/night contracts as other approaches. This is a **separate art-language track** from `01`–`05` (hand-painted / soft illustrative).

## Pixel rules (this approach only)

| Rule | Value |
|------|--------|
| Look | Visible pixels; SNES / indie pixel RPG read |
| Texture filter | **Nearest** on root + sprites (`TEXTURE_FILTER_NEAREST`) |
| Scale | Internal **320×180**, `Camera2D.zoom = (4, 4)` integer into 1280×720; sprite scales are integers only (`1` or `2`) |
| Camera | Locked; no position smoothing |
| Lights | `PointLight2D` for forge/shop warm spill; does not soft-blur the framebuffer |
| Assets | Free-store **non-AI** LPC packs under [`../shared/imported/`](../shared/imported/) |

## Imported file → prop map

### Packs

| Pack | Path | License |
|------|------|---------|
| LPC Blacksmith | [`../shared/imported/lpc_blacksmith/`](../shared/imported/lpc_blacksmith/) | OGA-BY 3.0 / CC-BY 3.0+ / GPL 2.0+ |
| LPC Base Assets | [`../shared/imported/lpc_base_assets/`](../shared/imported/lpc_base_assets/) | CC-BY-SA 3.0 / GPL 3.0 |

### Workshop

| Element | File |
|---------|------|
| Walls | `lpc_base_assets/slices/wall_grey_*.png` (from `tiles/house.png`) |
| Floor | `lpc_base_assets/slices/floor_cobble.png` (from `tiles/castlefloors.png`) |
| Beams | `lpc_base_assets/slices/beam_wood.png` (from `tiles/inside.png`) |
| Window | `lpc_base_assets/slices/window_house_a.png` |
| Forge | `lpc_blacksmith/props/forge_chimney_lit.png` + `forge_wall_lit.png` |
| Anvil | `lpc_blacksmith/props/anvil_block.png` |
| Bellows / quench / rack / coal / tools / horseshoes | matching `lpc_blacksmith/props/*.png` |

### Street

| Element | File |
|---------|------|
| Neighbor + smithy walls | `wall_grey_*.png` / `wall_brick_*.png` |
| Roof strip | `roof_slate.png` (recolor of house grey fill) |
| Road | `dirt_fill.png` + `floor_cobble.png` |
| Door / windows | `door_wood.png`, `window_house_*.png`, `window_house_night.png` |
| Sign | `sign_sword.png` + `lpc_blacksmith/props/hammer_tool.png` |
| Forge bay / anvil | `forge_wall_lit.png`, `anvil_block.png` |
| Barrels | `slices/barrel_*.png` |
| Mountains | `slices/mountains.png` |

Day/night: `street/day_night.gd` swaps window textures and raises forge/window/lamp spill (0–10 day / 10–20 night).

## Done when

- [x] Driven by imported LPC slices/props (not geometric placeholders for walls/floors/doors/windows/key props)
- [x] Clearly reads as **pixel art**; nearest + integer camera scale
- [x] F6 workshop + street; street day→night unaided; warm night spill
- [x] Credits under `shared/imported/`; no AI `references/` in scenes
