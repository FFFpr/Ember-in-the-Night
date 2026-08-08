# 02 — 2D lighting & particles

## Idea

Same spatial language as `01_pseudo_perspective_2d`, but sell volume with **2D lights**, optional **normal-mapped sprites**, and **particles** (embers, smoke, dust).

## How to build it

1. Start from the same layer breakdown as approach 01 (or share placeholder plates).
2. Add `PointLight2D` / `DirectionalLight2D` on forge, windows, street lamps.
3. Prefer textures with normal maps where cheap; otherwise fake volume with soft light cookies.
4. Particles: rising sparks at the forge; thin smoke; night moths/dust optional.
5. Street day/night becomes a **light rig change**, not only a color overlay.

## Scenes

| Scene | Notes |
|-------|--------|
| [`workshop/`](workshop/) | Dark interior; forge as dominant warm key light; anvil readable in spill. |
| [`street/`](street/) | Day sun-like directional light → night point lights + forge glow from the shop. |

## Godot touchpoints

`Light2D`, light occlusion on props if needed, `GPUParticles2D`, `CanvasModulate`, normal-map import on sprites.
