# Agent instructions

- Reply to the user in Chinese.
- All GitHub-facing content must be in English: repository docs (`README`, `docs/**`), code comments, commit messages, and PR titles/bodies.
- Keep comments and documentation to necessary information only. Do not restate the same fact in multiple places; prefer a single source of truth and link or omit duplicates.

## Cursor Cloud specific instructions

Setup (`.cursor/install.sh`) installs Godot 4.7.1, Python 3.13, `uv`, and `gda`, and exports `PATH`/`GDA_GODOT`/`GDA_PROJECT` in `~/.bashrc`. Standard run/inspect commands live in [`docs/tech/gda.md`](docs/tech/gda.md); there is no separate build step for this Godot project. Warm the import cache once per fresh checkout with `godot --path "$GDA_PROJECT" --headless --import` before headless `gda scene`/`script` reads. Verify runtime behavior via the `gda daemon` + `gda game`/`perf`/`diag` JSON loop (e.g. the Hammer falls from y≈238 to y≈483 under gravity).

Non-obvious caveats:
- The current demo has **no visual nodes** — entities carry only `CollisionShape2D`, so the game window and `gda screen capture` show a uniform gray frame. This is expected, not a broken renderer; validate behavior through runtime state, not pixels.
- Injected mouse input does **not** drive `DragController` grabs: it reads `get_global_mouse_position()`, which stays stale under `gda` daemon input injection. Injection is still accepted; assert interaction through node properties/physics, not by expecting drag to move a body.
