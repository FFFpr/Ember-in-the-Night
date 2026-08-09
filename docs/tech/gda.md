---
author: F
updated: 2026-08-09
status: active
---

# Godot Agent (`gda`) integration

> **This file:** Chosen integration path for [godot-agent / `gda`](https://github.com/aigengame/godot-agent) in this Godot 4.7 project (CLI, Skill, Cursor MCP). Not a substitute for upstream docs.

## Why

Agents can edit `.gd` / `.tscn` text, but they do not see engine load errors, the runtime scene tree, or physics state unless something drives Godot and returns **structured JSON**. `gda` is that loop: headless project ops, plus a live daemon for a running main scene.

## Integration choices (same command surface)

| Path | Use when |
|------|----------|
| CLI (`gda … --json`) | Shell, scripts, CI, cloud agents without MCP |
| Skill (`gda skill`) | Agents that load a Skill package and call the CLI |
| MCP (`gda-mcp`) | Cursor / Claude Code / Codex tool calls |

This repo registers Cursor MCP at [`.cursor/mcp.json`](../../.cursor/mcp.json) (`GDA_PROJECT=${workspaceFolder}`). Install once on the machine: Python **3.13+**, [`uv`](https://docs.astral.sh/uv/) / `uvx`, Godot **4.7+** on `PATH` or set `GDA_GODOT`. Optional: `uv tool install 'gda[mcp]'` for a pinned `gda` / `gda-mcp` on `PATH`.

For **Cursor Cloud Agents**, the same pins are installed by [`.cursor/environment.json`](../../.cursor/environment.json) → [`.cursor/install.sh`](../../.cursor/install.sh) (Cursor does not install tools from names alone; the script must run).

Reload Cursor after editing MCP config (Settings → Tools & MCP). If `uvx` is missing under Cursor’s GUI `PATH`, keep the `PATH` repair in `.cursor/mcp.json` or set `command` to the absolute `uvx` path (`which uvx`).

## Live harness (committed)

`gda daemon start` installs an inert autoload harness. This project keeps it so live ops do not rewrite the tree on first use:

- `addons/gda_harness/gda_harness.gd`
- `project.godot` → `[autoload] GdaHarness=*`

Remove with `gda daemon uninstall` if you decide live control is unwanted. Headless commands do not need the harness.

## Practical workflow

1. Point env: `export GDA_PROJECT=/path/to/Ember-in-the-Night` and `GDA_GODOT` if Godot is not on `PATH`.
2. Warm `.godot` once (class cache / UIDs): `godot --path "$GDA_PROJECT" --headless --import`.
3. Headless inspect/edit: `gda project info --json`, `gda scene get levels/test_scene.tscn --json`, …
4. Live: `gda daemon start` (add `--windowed` for `screen capture`), then `game` / `perf` / `input` / `diag`, then `gda daemon stop`.

Upstream registration recipes: [gda-mcp-registration.md](https://github.com/aigengame/godot-agent/blob/main/docs/gda-mcp-registration.md).

## Verification

Verified 2026-08-07 against the main scene with gda 0.9.0 + Godot 4.7.1 (CLI, live daemon, MCP `tools/list`). Treat `screen capture` pixel output as environment-dependent in cloud/VNC sessions.

## Open questions

- Whether cloud / headless display servers can produce useful `screen capture` for this Forward+ 2D demo without extra rendering flags.
- Whether to also ship a `gda skill` install for non-MCP agents (CLI-only path already works).
