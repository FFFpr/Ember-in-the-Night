# 03 — Isometric / axonometric

## Idea

Build shop and street on an **isometric (or axonometric) grid**. Depth is tile height + draw order, still 2D nodes.

## How to build it

1. Choose a tile diamond size and stick to it (Godot `TileMapLayer` isometric mode).
2. Workshop: camera aimed at the forge corner so the anvil sits on a clear cell; “first-person” here means **close, low isometric framing toward the work cell**, not a true FP camera.
3. Sort by tile/Y; multi-cell furniture (forge, anvil) as tall tiles or layered sprites.
4. Street: row of facades along an iso road; day/night modulates the whole map + emissive windows.

## Scenes

| Scene | Notes |
|-------|--------|
| [`workshop/`](workshop/) | Compact iso smithy; camera locked on forge–anvil diagonal. |
| [`street/`](street/) | Iso street slice; 20 s day→night on lights/modulate. |

## Godot touchpoints

Isometric `TileMapLayer`, custom tile collision, animated atlas for forge glow, `CanvasModulate` / per-tile modulate for night.
