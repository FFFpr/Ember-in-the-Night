# Workshop — 2D lighting

## Goal

First-person bench view where **fire light** is the visual hero.

## Required set dressing

Same prop list as `01` workshop (forge, anvil, bellows, tools, barrel, stock), plus:

- Light sources: forge mouth, optional candle/lantern
- Particle emitters: sparks, soft smoke

## Implementation sketch

- Low ambient; forge `PointLight2D` (warm, flickering via animation or noise).
- Anvil and nearby metal catch the key light; corners fall off hard (“long night” outside the glass).
- Occluders on thick props only if cheap; avoid over-occluding a look-dev scene.
