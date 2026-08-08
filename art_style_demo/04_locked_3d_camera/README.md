# 04 — 3D + locked camera

## Idea

Author the spaces in **3D** (meshes, real depth, Jolt only if physics is needed later). Presentation stays 2.5D: **fixed first-person or locked orbit-free camera**, no free look for the demo.

## How to build it

1. Blockout workshop and street with primitives, then swap in pack meshes.
2. Workshop camera: true first-person at standing eye height, aimed at forge + anvil.
3. Use Forward+ lights: forge as warm omni/spot; street sun vs night lamps.
4. Do not enable free mouse-look in the look-dev scenes; optional tiny breathing bob only.
5. Day/night street: animate `WorldEnvironment` / light energy over 20 s.

## Scenes

| Scene | Notes |
|-------|--------|
| [`workshop/`](workshop/) | Real FP camera; forge, anvil, props in 3D. |
| [`street/`](street/) | Locked exterior camera (FP at curb or fixed tripod); day 10 s / night 10 s. |

## Godot touchpoints

`Node3D`, `Camera3D`, `OmniLight3D` / `SpotLight3D` / `DirectionalLight3D`, `WorldEnvironment`, mesh instances; project already has Forward+ and Jolt for 3D.
