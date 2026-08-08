# 05 — Hybrid 2D + 3D

## Idea

Keep the **world readable as 2D** (background plates, street, UI-scale space) while rendering **hero props in 3D** (anvil, hammer, forge mouth) via a `SubViewport` or co-located 3D layer. Harder pipeline; useful only if 01/02 lack “weight” on the tools.

## How to build it

1. Workshop: 2D room plate + parallax; 3D anvil/forge tools composited in the center of the FP frame.
2. Match light direction/color between 2D lights and 3D lights so metal does not look pasted.
3. Street: mostly 2D day/night; optional 3D sign, cart, or hanging lamp as proof of hybrid — keep scope tiny.
4. Freeze 3D camera; treat the SubViewport as a billboard/sprite in 2D space.

## Scenes

| Scene | Notes |
|-------|--------|
| [`workshop/`](workshop/) | 2D interior shell; 3D forge+anvil cluster in FP view. |
| [`street/`](street/) | 2D street cycle; one small 3D accent max for the demo. |

## Godot touchpoints

`SubViewport` + `Sprite2D`/`TextureRect`, or 2D canvas in front of a 3D world with matched ortho/perspective; careful with HDR/tonemap mismatch.
