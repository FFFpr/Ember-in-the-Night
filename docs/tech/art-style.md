---
author: F
updated: 2026-08-09
status: active
---

# Art style and technical approach

> **This file:** Project art-direction SoT. Runnable look-dev demos live under [`art_style_demo/`](../../art_style_demo/) — import path mechanics stay there; do not duplicate scene file checklists here.

## Direction (locked)

| Item | Choice |
|------|--------|
| Art language | **LPC (Liberated Pixel Cup)** — overhead / three-quarter orthographic **32×32** pixel RPG style |
| Mood | Cool long-night exterior; warm ember forge as the emotional key |
| Look-dev baseline | Merged Plan B pixel demo [`art_style_demo/06_pixel_2d/`](../../art_style_demo/06_pixel_2d/) |

## Project constraint (all scenes)

**Mandatory:** every texture, sprite, and tileset used in **any scene implementation** (gameplay under `app/`, look-dev under `art_style_demo/`, or future levels) must comply with the official LPC Style Guide:

https://lpc.opengameart.org/static/LPC-Style-Guide/build/styleguide.html

| Rule | Detail |
|------|--------|
| Allowed | LPC base, LPC extensions, LPC Revised, and other packs that match the style guide |
| Also required | Free/open license, **non-AI**, credits with imports |
| Forbidden | AI-generated scene art; non-LPC hero art (e.g. generic low-poly kits, photoreal PBR as primary look); unlicensed scrapes |

Import folder conventions for demos: [`art_style_demo/README.md`](../../art_style_demo/README.md) § Asset sourcing.

## Recommended browse page

LPC-family pack index (browse and pick packs; **not** a single zip to dump into the repo):

https://opengameart.org/content/nearly-all-the-lpc-assets-in-one-place

## References (mood only)

AI-generated framing under [`art_style_demo/references/`](../../art_style_demo/references/) is **not** scene art and must not be imported into scenes. Prefer LPC packs over matching those PNGs’ brushwork.

## Look-dev history (superseded direction)

Earlier dual-track experiments (soft illustrative Track A vs pixel Track B) and Plans A / E / C / D are recorded for context only. **Production and new scene work follow LPC above.** Plan B’s merged `06_pixel_2d` demo remains the closest in-repo LPC-aligned baseline.
