# Ember in the Night: A Blacksmith's Tale

A blacksmith RPG and business simulation (Godot).

## Project

| Item | Value |
|------|--------|
| Engine | Godot **4.7** (Forward Plus) |
| Presentation | 2D (current demo: hammer physics) |
| Physics | Jolt (as configured in `project.godot`) |
| Multiplayer | None (solo project) |
| Cloud agents | Tool install for Cursor Cloud is defined in [`.cursor/environment.json`](.cursor/environment.json) (runs [`.cursor/install.sh`](.cursor/install.sh)) |

Open the project folder in Godot 4.7+. Main scene is set in `project.godot`.

### Official Godot docs (4.7)

| Topic | Link |
|-------|------|
| Documentation home | https://docs.godotengine.org/en/4.7/ |
| Performance | https://docs.godotengine.org/en/4.7/tutorials/performance/ |
| Best practices | https://docs.godotengine.org/en/4.7/tutorials/best_practices/ |
| Engine details | https://docs.godotengine.org/en/4.7/engine_details/ |

### Layout (code)

| Path | Role |
|------|------|
| `entities/` | Game entities (hammer, metal, etc.) |
| `systems/` | Controllers / interaction systems |
| `levels/` | Scenes |
| `resources/` | Shared resources (materials, etc.) |
| `art_style_demo/` | Art-direction demos (docs + future scenes; not shipping gameplay) |
| `docs/` | Game design docs (not a description of current code) |

Design intent, themes, and discussion live under [`docs/`](docs/). See [`docs/README.md`](docs/README.md). Stack and environment facts stay in this file; `docs/tech/` records **chosen** technical routes only. Art-style comparison demos: [`art_style_demo/`](art_style_demo/).

## Premise

The medieval world is a long night. You are a blacksmith; the forge fire is the only light you can hold—an **ember in the night**. The game offers two paths bound by the same flame: keep the guild’s order, or forge outside it.

Full theme, dual-path framing, and motifs: [`docs/design/theme.md`](docs/design/theme.md).
