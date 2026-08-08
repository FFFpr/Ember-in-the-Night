# Street — pseudo-perspective 2d

## Goal

Shop-front / medieval street, fixed composition.

## Day → night (20 s)

| Time | Look |
|------|------|
| 0–10 s | Day: bright sky/ambient, readable shop sign, cooler shadows |
| 10–20 s | Night: deep blue/black wash, windows and forge spill as warm accents |

Loop or stop at 20 s; keep camera identical so only lighting/palette changes.

## Implementation sketch

- Base street plate + facade layers (awning, door, barrels, distant houses).
- Day/night via `CanvasModulate`, ColorRect overlays, and/or swap sky sprites.
- Optional: lantern sprites that “turn on” at t=10 s.
