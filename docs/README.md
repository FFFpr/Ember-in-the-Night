# Documentation (`docs`)

> **This file:** Housekeeping for `docs/` — what each subdirectory is for, the document metadata format, and how design docs relate to code.

This tree records **game design**: theme, loops, setting, narrative, and technical-path discussion.

## Relation to code

- `docs/` captures design intent and discussion. It does **not** describe what the codebase currently implements.
- Engine version, development environment, and how to open the project belong in the root [`README.md`](../README.md).
- There is **no hard binding** between design docs and code. Implementation may lag, lead, or diverge; update either side when you choose to.

## Directory roles

| Directory | Role |
|-----------|------|
| [`design/`](design/) | Gameplay and systems design. Present: [`theme.md`](design/theme.md) (game theme), [`main-loop.md`](design/main-loop.md) (main loop) |
| [`lore/`](lore/) | Worldbuilding and setting facts |
| [`narrative/`](narrative/) | Plot outlines, dialogue, and other narrative drafts |
| [`tech/`](tech/) | **Technical-path discussion and alternatives** — not what the project currently ships. Present: [`art-style.md`](tech/art-style.md) (locked look-dev direction; demos in [`art_style_demo/`](../art_style_demo/)), [`gda.md`](tech/gda.md) (Godot Agent / Cursor MCP) |
| [`ideas/`](ideas/) | Casual inspiration and notes; **no required sync or promotion workflow** with other folders |

Root of `docs/` also has [`development-log.md`](development-log.md) (dated progress / todos; not design baseline).

Do not pre-create a README in every subdirectory; add one later only if a folder gets complex.

## Document metadata

Every Markdown file except this `README.md` **should** use the YAML header below. It is for recording, not gating. Fields may be omitted; fill them in later if something becomes unclear.

```yaml
---
author: name or id
updated: YYYY-MM-DD
status: active | thinking | outdated
---
```

| `status` | Meaning (design confidence only) |
|----------|----------------------------------|
| `active` | Solid enough to treat as a design baseline |
| `thinking` | Worth pursuing; not a final conclusion yet |
| `outdated` | Superseded in design terms; do not treat as current |

`status` does **not** mean “implemented in code.”

## Out of scope here

- Cursor / agent rules (Cursor configuration; not part of this repo’s docs scheme)
- Current software versions and environment (see root `README.md`)
