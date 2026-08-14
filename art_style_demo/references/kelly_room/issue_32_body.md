Refit `art_style_demo/07_kelly_room/` until it matches its approved sample. Follow `.cursor/skills/scene-from-issue/SKILL.md`. The acceptance gates land in #31.

```text
cursor_agent_id: bc-8a789d1f-16ca-4bba-931c-a5fbe196c0f3
```

## Target

- Approved sample: `art_style_demo/references/kelly_room/fp_idle.png`, 1536×864 (16:9, same ratio as the baseline framing). Approved 2026-08-14. The previous 3:2 sample is kept as `fp_idle_legacy_3x2.png` for atmosphere only.
- **Acceptance criterion: `art_style_demo/references/kelly_room/fit_list.md`.** Per-item, normalised on the baseline framing, approved. Read it before touching the scene; do not eyeball the image.
- Target for objects, distribution, position and share of frame, proportion and light structure. Not the target for material, colour count, resolution or aspect ratio.

This body is also stored at `art_style_demo/references/kelly_room/issue_32_body.md` because the owner agent's token can open issues but cannot edit or comment on them. If this GitHub body and that file diverge, the file in the repo is the working copy until someone pastes it here.

## Scene description and run logic

Unchanged, in `art_style_demo/07_kelly_room/README.md`. `kelly_round.gd`, `kelly_math.gd` and `tests/test_kelly_round.gd` stay as they are. Coordinate changes needed to bring props into frame are expected; a change to the rules themselves goes into this issue first, then the tests, then the code.

Outlet width follows the sample / fit list (0.220 of frame width), not the README's "1/3 of the view".

## Coin market structure

The sample's hoard cannot be built from individual coin objects. The animations decide the structure:

- **Density is a texture, not instances.** A single `level` float drives a tileable fill below it and an irregular tileable crest strip on it, drawn on two or three parallax planes at different depths with progressively darker modulate. Thousands of coins are painted, not instantiated.
- **Only moving coins are sprites**, pooled, capped on screen. Pulling the lever spawns falling edge-on coins in the empty upper half of the glass; on landing each sprite despawns and raises `level` by its share. Payout runs it backwards: `level` drops while sprites spawn behind the outlet, pass through it and arc onto the floor.
- **The outlet must read as a way through the glass wall:** open/closed frames, plus a recessed 3D channel so depth occludes the coins in transit.

Floor coins stay individual sprites because they are box-selected; they belong in front of the glass and are unrelated to the market layer.

## Tasks

### A. Framing and shell
- [ ] A1 Camera and room proportions to the fit list; nothing cropped, no lit ceiling in frame.
- [ ] A2 Beams, posts, riveted iron apron below the glass, cold side window.
- [ ] A3 Floor as long boards converging toward the camera, not staggered short bricks.

### B. Coin market
- [ ] B1 Water-level model with fill and crest tiles on parallax planes.
- [ ] B2 Fall-in on lever pull, with the sprite-to-level handoff.
- [ ] B3 Ejection through the outlet on payout, with the level-to-sprite handoff.
- [ ] B4 Outlet open/closed frames and the recessed channel that occludes coins in transit.

### C. Legibility
- [ ] C1 Frosted, less transparent glass patch behind the formula, the equals sign and the sticker.
- [ ] C2 Local fill light on the whiteboard and the formula; global ambient stays low so the contrast gates still pass.
- [ ] C3 Marker text readable at 1:1 with no outline halo swallowing the glyphs; box readout at 0.080 of frame height.

### D. Pipeline
- [ ] D1 `kelly_assets.gd` raises an explicit error listing missing paths instead of silently falling back to greybox.
- [ ] D2 Committed acceptance script: render at the baseline framing, report every fit-list item as PASS/FAIL with `unproject_position()` positions and the contrast numbers.

### E. Art tickets on FFFpr/Aseprite-User
Opened after A and B lock the framing, so every canvas and px/m is derived from the built scene rather than guessed. One issue per asset.

- [ ] E1 Space level: coin mass fill, coin mass crest (two variants), riveted iron apron, wall plank redraw, floor plank redraw.
- [ ] E2 Prop level: edge-on coin, beam, post, side window, outlet closed and open, whiteboard, coin box, lever up and down, sticker.

## Done when

Every fit-list item is PASS at the baseline framing, with the acceptance script output and a full-frame screenshot attached, and the Kelly tests still pass.
