# Documentation

In-repo Markdown docs for **Ember in the Night: A Blacksmith's Tale**.

This tree is the single source of design truth for the solo developer and for AI agents. There is no separate docs repo.

## Layout

| Directory | Purpose | Churn |
|-----------|---------|-------|
| [`vision/`](vision/) | Premise, themes, dual paths | Low — change only when the core idea shifts |
| [`design/`](design/) | Systems, economy, forging gameplay | Medium |
| [`lore/`](lore/) | Setting bible / worldbuilding | Medium–low |
| [`narrative/`](narrative/) | Plot outlines, dialogue drafts | Medium–high |
| [`tech/`](tech/) | Tech roadmap, physics notes, ADRs | Medium |
| [`ideas/`](ideas/) | Fleeting inspiration (messy OK) | High — promote when confirmed |
| [`meta/`](meta/) | How we write and maintain docs | Low |

## Start here

1. Read [`meta/documentation-standards.md`](meta/documentation-standards.md) before adding or rewriting docs.
2. Read [`vision/premise.md`](vision/premise.md) for the confirmed premise.
3. Put new inspiration in `ideas/` first; promote into the right folder when it is confirmed.

## Root README vs `docs/`

- Repo root [`README.md`](../README.md): short public premise and project identity.
- `docs/`: working design bible. When they conflict, update both; prefer clarifying `docs/vision/` then syncing the root README.
