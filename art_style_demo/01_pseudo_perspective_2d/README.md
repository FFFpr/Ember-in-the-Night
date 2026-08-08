# 01 — Pseudo-perspective 2D

Parent brief (read first): [`../README.md`](../README.md). Refs: [`../references/`](../references/).

## Technique

Full 2D pipeline. Depth = drawn perspective + layer split + parallax / z-index. No `Light2D` required here (that is `02`).

## Build steps (workshop)

1. Create `workshop/workshop.tscn`, root `Workshop` (`Node2D`).
2. Add locked `Camera2D` (current); frame like `references/workshop_fp_ref.png`.
3. Layers (back → front), each a `Node2D` or `Sprite2D`:
   - `LayerFar` — back wall, window, forge mouth
   - `LayerMid` — anvil, bellows, barrel, racks
   - `LayerNear` — beams / hanging tools / frame
4. Placeholders OK: colored `Polygon2D` / `ColorRect` in a `Sprite2D` hierarchy, but silhouettes must read as forge + anvil.
5. Optional: slow `Parallax2D` or scripted 2–4 px camera sway.

## Build steps (street)

1. Create `street/street.tscn`, root `Street` (`Node2D`), locked `Camera2D`.
2. Facade + street props matching day ref composition.
3. Add `day_night.gd` or `AnimationPlayer`:
   - 0–10 s: day modulate / bright sky plate
   - 10–20 s: night modulate + warm window/door glow sprites on
4. Autostart; no input.

## Status

Runnable placeholders: `workshop/workshop.tscn`, `street/street.tscn` (shared layout builders).

## Done when

- F6 workshop: FP bench framing, required props visible  
- F6 street: unaided day→night in 20 s, camera unchanged  
- No `Light2D` dependency (keep this approach readable in flat color)

## Hand-off to 02

Export or keep these scenes as the **layout source**. `02` must duplicate node layout / plates, then add lights.
