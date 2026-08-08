# Art style demos

Scaffold for comparing presentation approaches for *Ember in the Night*. **Docs and folders only for now** — no runnable scenes yet.

Theme context: forge fire / long night / ember; blacksmith shop + street atmosphere. Design baseline: [`docs/design/theme.md`](../docs/design/theme.md).

## Shared scene briefs (every approach)

Each approach directory must eventually ship **at least two** scenes:

| Scene | Intent |
|-------|--------|
| `workshop/` | Interior of a smithy, **first-person** toward the work area: forge/hearth, anvil, and typical shop props (bellows, tool rack, quench barrel, ore/ingots, hanging horseshoes, dim rafters). |
| `street/` | Exterior street / shop front. Timeline: **0–10 s day**, **10–20 s night** (same camera framing; lighting and palette carry the change). |

“First-person” here means the camera reads as the smith at the bench (over the tools toward forge and anvil), not a free FPS controller unless the approach is true 3D.

## Approaches

| Dir | Approach | One-line idea |
|-----|----------|----------------|
| [`01_pseudo_perspective_2d/`](01_pseudo_perspective_2d/) | Pseudo-perspective 2D | Flat sprites + layers, parallax, Y-sort depth |
| [`02_2d_lighting/`](02_2d_lighting/) | 2D lighting & particles | Same 2D base; normal maps, lights, sparks/smoke |
| [`03_isometric/`](03_isometric/) | Isometric / axonometric | Diamond tiles, grid movement, height sorting |
| [`04_locked_3d_camera/`](04_locked_3d_camera/) | 3D + locked camera | Real meshes; fixed / anonymous FP camera |
| [`05_hybrid_2d_3d/`](05_hybrid_2d_3d/) | Hybrid 2D + 3D | 2D world with 3D hero props (or the reverse) |

**Out of scope for this scaffold:** Mode7-style ground projection (poor fit for shop + street comparison).

## Status

| Item | State |
|------|--------|
| Directories + approach/scene READMEs | Done |
| Godot `.tscn` / assets | Not started |
| Art pack shortlist | Pending (search free/open assets when requested) |

Implementation order suggestion when coding starts: `01` → `02` → optional `04` greybox → `03` / `05` only if still needed.
