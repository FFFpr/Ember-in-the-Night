# 04 — 3D + locked camera

Parent brief: [`../README.md`](../README.md). Project: Forward+, Jolt available (physics optional for look-dev).

## Technique

Real 3D meshes; **locked** `Camera3D` (workshop = true FP eye height ~1.6 m toward forge/anvil). No mouse look.

## Scenes (Compare pass)

| Scene | Run | Notes |
|-------|-----|--------|
| [`workshop/workshop.tscn`](workshop/workshop.tscn) | F6 | Locked FP; Kenney room shell + sandsound forge/anvil/tub/hammers + Quaternius crate |
| [`street/street.tscn`](street/street.tscn) | F6 | Locked shop-front; Kenney facade/neighbors; forge spill day→night via [`day_night.gd`](street/day_night.gd) |

Imported packs (credits under each folder): [`../shared/imported/`](../shared/imported/).

## Done when

- FP workshop reads like reference blocking (anvil in reach, forge ahead)
- Street unaided day→night, camera fixed
- Stylized pack meshes (not untextured primitives as the final look)
- Photoreal not required
