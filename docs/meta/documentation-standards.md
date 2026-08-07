# Documentation Standards

Norms for the in-repo `docs/` tree. Audience: solo maintainer + AI agents.

## Goals

1. One place for design truth — no parallel docs repo or scattered notes outside this tree (except the root README).
2. Cheap to update — status and folder purpose make it obvious where a note belongs.
3. Agent-friendly — clear paths, stable filenames, explicit status so agents do not invent lore or systems.

## Directory roles

| Path | Put here | Do not put here |
|------|----------|-----------------|
| `vision/` | Confirmed premise, themes, dual-path framing | Mechanics details, one-off plot beats |
| `design/` | Game systems, economy, forging loop, UI/UX systems | Unconfirmed brainstorms |
| `lore/` | World facts, factions, places, calendar, tone bible | Temporary plot drafts |
| `narrative/` | Arcs, quests, dialogue drafts, scene outlines | Engine/API notes |
| `tech/` | Godot/architecture decisions, physics conclusions, ADRs, roadmap | Story content |
| `ideas/` | Rough sparks, “maybe later”, unresolved questions | Confirmed design (promote out) |
| `meta/` | Doc and agent process only | Game content |

## Document status

Every content doc (not folder README indexes) should start with a short YAML front matter block:

```yaml
---
status: draft | active | deprecated
owner: solo
updated: YYYY-MM-DD
---
```

| Status | Meaning |
|--------|---------|
| `draft` | Work in progress; may contradict other docs; agents treat as non-binding |
| `active` | Confirmed enough to guide design and implementation |
| `deprecated` | Kept for history; do not extend; link to the replacement if any |

Folder `README.md` index files do not need status front matter.

## Promotion workflow (`ideas/` → elsewhere)

1. Capture freely in `ideas/` (messy is OK). Prefer one idea per file.
2. When an idea is confirmed, move or rewrite it into the matching folder (`design/`, `lore/`, etc.).
3. Set `status: active` on the promoted doc.
4. In the old `ideas/` file, either delete it or leave a short stub pointing to the new path and set `status: deprecated`.
5. Update the target folder’s `README.md` index if you add a major doc.

## Naming

- Use kebab-case ASCII filenames: `guild-reputation.md`, `forge-heat-loop.md`.
- Prefer English filenames even if the body is Chinese (stable paths for agents and links).
- One primary topic per file. Split when a file grows past ~200–300 lines or mixes unrelated systems.
- ADRs in `tech/`: `adr-NNN-short-title.md` (e.g. `adr-001-jolt-physics.md`).

## Language

- **Filenames & folder structure:** English.
- **Body text:** Chinese or English are both allowed. Prefer the language you will revise fastest.
- **Canonical conflict rule:** If two docs disagree, the one with `status: active` in the more specific folder wins (`design/` over `ideas/`, `vision/` over root README for thematic detail). Resolve by editing; do not leave lasting contradictions.
- Root `README.md` stays a short **English** public premise; keep it in sync with `docs/vision/`.

## Writing style

- Lead with the decision or fact; put rationale after.
- Prefer short sections and bullet lists over long prose.
- Mark unknowns explicitly: `TBD`, `Open question:`, or a `## Open questions` section.
- Do not invent lore, systems, or plot to “fill gaps” when editing as an agent — leave TBD or ask via a listed open question.
- Cross-link with relative Markdown links.

## What not to document here

- Generated or binary assets
- Secrets, credentials, personal machine paths
- Full engine API dumps (link to Godot docs instead)
- Chat logs — distill conclusions into `tech/` or `design/` instead

## Checklist for new docs

- [ ] Correct folder for maturity and topic
- [ ] Status front matter set
- [ ] Linked from the folder `README.md` if it is a primary doc
- [ ] No contradiction with `vision/` (or vision updated first)
- [ ] Open questions listed instead of silent invention
