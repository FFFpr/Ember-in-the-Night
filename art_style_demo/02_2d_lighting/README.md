# 02 — 2D lighting & particles

Parent brief: [`../README.md`](../README.md). **Depends on 01 layout.**

## Technique

Same spatial language as `01`, plus `PointLight2D` / `DirectionalLight2D`, optional normal maps, `GPUParticles2D` (sparks/smoke). Street day/night = **light rig**, not only modulate.

## Build steps

1. Duplicate `01_*` workshop/street scenes into this folder (or instance shared plates from `art_style_demo/shared/` if created).
2. **Do not redesign composition.** Node names for layers should stay parallel to 01.
3. Workshop: low ambient (`CanvasModulate`); forge `PointLight2D` warm + flicker; sparks `GPUParticles2D` at forge mouth.
4. Street: day = directional/bright ambient; at t=10 s drop ambient, enable window/lamp/forge spill lights.
5. Occluders optional; skip if they fight placeholders.

## Status

Runnable **compare pass**. Same `ArtDemoPlates` layout as `01` (imported pack art), plus forge/street `PointLight2D`, daytime `DirectionalLight2D`, `CanvasModulate`, and forge `GPUParticles2D` sparks. Street night enables door/window/lantern lights (not modulate-only).

## Done when

- Side-by-side with 01, same framing, clearly richer light/particle read
- Street cycle still 20 s autostart
- Credits if using normal-mapped pack textures
