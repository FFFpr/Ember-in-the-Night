# 04 — 3D + locked camera

Parent brief: [`../README.md`](../README.md). Project: Forward+, Jolt available (physics optional for look-dev).

## Technique

Real 3D meshes; **locked** `Camera3D` (workshop = true FP eye height ~1.6 m toward forge/anvil). No mouse look.

## Build steps (workshop)

1. `workshop/workshop.tscn`, root `Workshop` (`Node3D`).
2. Greybox with `MeshInstance3D` boxes; replace with pack meshes when available.
3. `Camera3D` current, fixed transform; forge `OmniLight3D`/`SpotLight3D` warm.
4. `WorldEnvironment` mild; avoid blinding bloom.

## Build steps (street)

1. `street/street.tscn` — facade + road greybox; locked camera (curb FP or tripod).
2. `AnimationPlayer` or script: sun energy 0–10 s; night lamps + forge door spill 10–20 s.

## Done when

- FP workshop reads like reference blocking (anvil in reach, forge ahead)
- Street unaided day→night, camera fixed
- Stylized materials OK; photoreal not required
