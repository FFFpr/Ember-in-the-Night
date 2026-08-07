# Cursor Rules

Project AI guidance lives under [`.cursor/rules/`](../../.cursor/rules/) as `.mdc` files (version-controlled).

## Rule files

| File | Apply mode | Role |
|------|------------|------|
| `project.mdc` | Always | Identity, engine, dual-path themes, docs map |
| `docs.mdc` | Auto (`docs/**`) | Doc standards when editing documentation |
| `godot.mdc` | Auto (`**/*.{gd,tscn,godot}`) | Godot / GDScript conventions for this repo |

## When to edit rules

- **Do** update rules when a recurring agent mistake appears, or when a confirmed project convention changes.
- **Do not** dump one-off task instructions into always-on rules (keeps context small).
- Prefer pointing agents at `docs/` for design truth; rules should be short constraints, not a second design bible.

## Front matter conventions

```yaml
---
description: Short hint for when the agent should load this rule
globs: optional/path/**/*.md
alwaysApply: false
---
```

- `alwaysApply: true` — only for `project.mdc`-level essentials.
- `globs` — for path-scoped conventions (docs, Godot scripts).
- Keep each rule focused; split rather than grow a monolith.

## Relation to `docs/`

| Concern | Source of truth |
|---------|-----------------|
| Premise, themes, systems, lore | `docs/` |
| How to edit docs | `docs/meta/documentation-standards.md` + `docs.mdc` |
| How agents behave in-repo | `.cursor/rules/*.mdc` |
