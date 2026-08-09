# 03 — Isometric / axonometric

Parent brief: [`../README.md`](../README.md).

## Technique

Isometric `TileMapLayer` (or equivalent diamond sprites). Same props; camera is **close locked iso** toward forge–anvil, not true FPS lens.

## Build steps (workshop)

1. `workshop/workshop.tscn`, root `Workshop`.
2. Create iso floor + wall tiles (placeholders: solid diamond polygons OK).
3. Multi-cell or tall sprites: forge, anvil on adjacent cells in the lower-center of view.
4. Lock camera on that cluster; no click-to-move required for look-dev.

## Build steps (street)

1. `street/street.tscn` — short iso street + facade.
2. Day/night via `CanvasModulate` + emissive window sprites; 20 s autostart.

## Done when

- Clearly readable as iso (diamond floor), not side-view 01
- Props list satisfied; street day→night works

## Status

Compare pass: `workshop/workshop.tscn` and `street/street.tscn` use free CC0 pack art under `../shared/imported/` (Feudal Wars iso medieval buildings; rubberduck iso ground + props). Street day/night via `street/day_night.gd` (`World.modulate` + soft `Emissives`).
