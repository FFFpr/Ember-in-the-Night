# 04 — 3D + locked camera

Parent brief: [`../README.md`](../README.md). Project: Forward+, Jolt available (physics optional for look-dev).

## Technique

Real 3D meshes; **locked** `Camera3D` (workshop = true FP eye height ~1.6 m toward forge/anvil). No mouse look.

## Scenes (Compare pass)

| Scene | Run | Notes |
|-------|-----|--------|
| [`workshop/workshop.tscn`](workshop/workshop.tscn) | F6 | Locked FP; pack meshes only (Kenney / Quaternius / OGA). Tiny emissive glow helper allowed. |
| [`street/street.tscn`](street/street.tscn) | F6 | Locked shop-front; pack facade/props; day→night via [`day_night.gd`](street/day_night.gd) |

No untextured `BoxMesh` / `CylinderMesh` hero pieces. Imported packs: [`../shared/imported/`](../shared/imported/).

## Done when

- FP workshop reads like reference blocking (anvil in reach, forge ahead)
- Street unaided day→night, camera fixed
- Stylized pack meshes (not untextured primitives as the final look)
- Photoreal not required
