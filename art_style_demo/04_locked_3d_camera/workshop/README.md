# Workshop — locked 3D camera

## Goal

True first-person greybox (then art) of the smithy interior.

## Required set dressing

- Forge / hearth volume with emissive materials or lights
- Anvil mesh in arm’s reach of the camera
- Props: bellows, tool rack, quench barrel, crates, hanging tools, beams

## Implementation sketch

- `Camera3D` at ~1.6 m, rotation fixed toward forge–anvil.
- Strong warm key from forge; cool fill from a small window.
- Static bodies only if you need silhouette collision later; not required for look-dev.
