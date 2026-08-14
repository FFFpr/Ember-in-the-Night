Remaining work for this issue. Spec is already locked in the repo (`fit_list.md`, `issue_32_body.md`, approved `fp_idle.png` on PR #33). This run’s token cannot comment or edit GitHub (403); please paste this into a comment on #32, and paste `issue_32_body.md` into the issue body.

Owner: `cursor_agent_id: bc-8a789d1f-16ca-4bba-931c-a5fbe196c0f3`

Do not open Aseprite tickets until A and B are committed and the framing is treated as locked. Do not change `project.godot` `run/main_scene`. Do not change round rules without writing them here first, then tests, then code.

## Blocked on a human

- [ ] Paste `art_style_demo/references/kelly_room/issue_32_body.md` into this issue’s body (GitHub still has the old “fit list to be filled in” text).

## Scene implementation (local, uncommitted)

Greybox on `cursor/kelly-room-fit-169-c0f3` already builds from the fit list. Last acceptance at 1152×648: 13/13 items PASS, mean luma 30.3, edge/P90 0.25. Composition matches; the look is still blocky gold slabs. Files are **not** on the PR.

- [ ] Commit the scene files and open a **draft** PR against this issue (separate from #31 / #33).
- [x] A1 Camera and room proportions from the fit list; nothing cropped, no lit ceiling in frame. *(local)*
- [x] A2 Beams, posts, riveted iron apron, cold side window. *(local greybox)*
- [x] A3 Floor as long boards converging toward the camera. *(local greybox)*
- [x] B1 Water-level model: fill + crest tiles on 3 parallax planes, `level` float. *(local greybox; crest still too regular)*
- [x] B2 Fall-in on lever pull; sprite-to-level handoff, pool cap 36. *(local)*
- [x] B3 Ejection on payout; level-to-sprite handoff through the outlet. *(local)*
- [x] B4 Outlet open/closed frames + recessed channel. *(local greybox)*
- [x] C1 Frosted patch behind the formula, equals, and sticker. *(local)*
- [x] C2 Local fill lights on the board and formula; ambient kept low. *(local)*
- [ ] C3 Marker text readable at 1:1 with no outline halo; box readout at 0.080 of frame height. *(glyphs still Label3D; needs `marker_digits` art)*
- [x] D1 `kelly_assets.gd` `audit()` lists missing paths / LFS pointers via `push_error` and an on-screen GREYBOX banner. Still falls back to greybox so work can continue. *(local)*
- [x] D2 Acceptance script `art_style_demo/07_kelly_room/tools/acceptance.gd`. *(local)*
- [ ] Optional look pass before tickets: cooler window fill so the lever/box read on the dark right wall; less regular greybox crest.

## E. Art tickets (not opened)

One `[art]` issue per asset on FFFpr/Aseprite-User. Prefix `[art]`. Each body needs `ember_issue:` this URL, `cursor_agent_id:` the owner bc, and the path pair under `issue_32/`. Derive canvas / px/m from the **committed** framing, not from guesses. Space-level first.

### E1 Space level

- [ ] `[art]` coin mass fill — `src/Ember-in-the-Night/issue_32/coin_mass_fill.aseprite`
- [ ] `[art]` coin mass crest A — `…/coin_mass_crest_a.aseprite`
- [ ] `[art]` coin mass crest B — `…/coin_mass_crest_b.aseprite`
- [ ] `[art]` riveted iron apron — `…/iron_apron.aseprite`
- [ ] `[art]` wall plank (tileable, 100 px/m) — `…/wood_plank_wall.aseprite`
- [ ] `[art]` floor plank (tileable, 100 px/m) — `…/wood_plank_floor.aseprite`

### E2 Prop level

- [ ] `[art]` edge-on coin — `…/coin_edge.aseprite`
- [ ] `[art]` beam — `…/beam.aseprite`
- [ ] `[art]` post — `…/post.aseprite`
- [ ] `[art]` side window — `…/side_window.aseprite`
- [ ] `[art]` outlet closed — `…/outlet_closed.aseprite`
- [ ] `[art]` outlet open — `…/outlet_open.aseprite`
- [ ] `[art]` whiteboard — `…/whiteboard.aseprite`
- [ ] `[art]` coin box — `…/coin_box.aseprite`
- [ ] `[art]` lever up — `…/lever.aseprite`
- [ ] `[art]` lever down — `…/lever_down.aseprite`
- [ ] `[art]` sticker — `…/sticker.aseprite`
- [ ] `[art]` wall lantern — `…/wall_lantern.aseprite`
- [ ] `[art]` marker digits — `…/marker_digits.aseprite`

Floor coins reuse existing `export/props/kelly_room/coin.png`. Do not ticket that.

## After art lands

- [ ] Sweep this issue for Aseprite receipt comments; bump `Aseprite-User`, `git lfs pull`, swap greybox for exports.
- [ ] Re-run acceptance at 1152×648; attach the script output and a full-frame screenshot.
- [ ] Kelly logic tests still pass (`godot --headless --path . --script res://art_style_demo/07_kelly_room/tests/test_kelly_round.gd`).

Done when every fit-list item is PASS with that evidence attached.
