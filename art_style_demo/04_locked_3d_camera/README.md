# 04 — 3D + locked camera

Parent brief: [`../README.md`](../README.md). Project: Forward+, Jolt available (physics optional for look-dev).

## Technique

Real 3D meshes; **locked** `Camera3D` (workshop = true FP eye height ~1.6 m toward forge/anvil). No mouse look.

## Scenes

| Scene | Run | Notes |
|-------|-----|--------|
| [`workshop/workshop.tscn`](workshop/workshop.tscn) | F6 | Greybox room + required props; forge `OmniLight3D` flicker; optional tiny idle sway |
| [`street/street.tscn`](street/street.tscn) | F6 | Facade greybox; [`street/day_night.gd`](street/day_night.gd) drives 0–10 s day / 10–20 s night (≤0.5 s fade) |

Shared palette / mesh helpers: [`../shared/placeholders/`](../shared/placeholders/).

## Build notes

Workshop and street build primitive `MeshInstance3D` props in `_ready` (first-pass placeholders). Swap for free-store pack meshes under `shared/imported/` later without changing camera locks.

## Done when

- FP workshop reads like reference blocking (anvil in reach, forge ahead)
- Street unaided day→night, camera fixed
- Stylized materials OK; photoreal not required
