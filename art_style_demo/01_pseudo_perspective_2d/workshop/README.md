# Workshop — pseudo-perspective 2D

## Goal

First-person-at-the-bench view of the smithy interior.

## Required set dressing

- Forge / hearth (glowing coals; can be a sprite sheet or simple emissive plate)
- Anvil in the lower-mid foreground or midground
- Props: bellows, hammer rack, tongs, quench barrel, wood/coal pile, hanging horseshoes, shelves with ingots
- Framing: dark beams, wall tools, maybe a window slit for “long night” contrast

## Implementation sketch

- Locked `Camera2D` (no free look). Optional tiny idle sway.
- Layers: back wall → forge wall → anvil/bench → near overhang.
- Hotspots later (not required for look-dev): anvil, bellows, forge mouth.

## Deliverable when coded

One `.tscn` that opens on this framing with placeholder or pack art.
