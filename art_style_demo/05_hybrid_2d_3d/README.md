# 05 — Hybrid 2D + 3D

Parent brief: [`../README.md`](../README.md). Prefer after 01/02 exist.

## Technique

2D room/street shell + **3D hero cluster** (anvil and/or forge mouth) via `SubViewport` → `Sprite2D` (or equivalent). Street: at most **one** 3D accent.

## Build steps (workshop)

1. Start from 01/02 2D plates in `workshop/workshop.tscn`.
2. Add `SubViewport` (transparent bg) with 3D anvil/forge lit warm; display as centered sprite on the bench line.
3. Match key light color/direction between 2D and 3D so metal does not look pasted.
4. Both cameras locked.

## Build steps (street)

1. 2D street cycle like 01/02.
2. Optional single 3D sign or lantern in a small SubViewport — skip if time-boxed.

## Done when

- Workshop clearly shows 2D shell + 3D tools
- Street day→night still works; hybrid accent optional but documented if omitted
