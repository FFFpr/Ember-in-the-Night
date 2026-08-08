# 01 — Pseudo-perspective 2D

## Idea

Stay fully in Godot’s 2D pipeline. Depth comes from **drawn perspective**, **layered parallax**, and **Y-sort** (or explicit z-index), not from a 3D camera.

## How to build it

1. Paint or collage a smithy / street in a fixed 3/4 or slight side-perspective.
2. Split into layers: far wall / mid props / interactive bench / near frame (door jamb, hanging tools).
3. Use `Parallax2D` (or manual layer offsets) so small camera bob or pan sells depth.
4. Sort characters and standing props by foot Y so they pass in front/behind correctly.
5. Keep collision and interaction in 2D (`StaticBody2D` / areas on hotspots).

## Scenes

| Scene | Notes |
|-------|--------|
| [`workshop/`](workshop/) | FP-style framing: camera locked looking at forge + anvil; layered interior. |
| [`street/`](street/) | Same street plate; swap or modulate day/night layers on a 20 s loop. |

## Godot touchpoints

`Node2D`, `Sprite2D` / `AnimatedSprite2D`, `Parallax2D`, Y-sort, `CanvasModulate` or layered night overlays for the street cycle.
