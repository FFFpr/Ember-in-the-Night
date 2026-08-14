# Agent instructions

- Reply to the user in Chinese.
- Write repository documentation in Chinese (`README`, `docs/**`, and other project docs). Keep documentation filenames in English.
- When writing Chinese, only annotate **proper nouns** with the English original in parentheses (game titles, named paths/plans, product or standard names rendered in Chinese). Do **not** annotate ordinary nouns. Example: `《夜中余烬》(Ember in the Night: A Blacksmith's Tale)`, `行会之路 (Guild Path)`. Keep identifiers that are already English as-is (`Godot`, `LPC`, `Light2D`) without a Chinese wrapper.
- Code comments, commit messages, and PR titles/bodies must be in English.
- Keep comments and documentation to necessary information only. Do not restate the same fact in multiple places; prefer a single source of truth and link or omit duplicates.
- 当用户提到「实现一个场景」时，调用 skill `scene-from-issue`（`.cursor/skills/scene-from-issue/SKILL.md`）。提醒用户给出已有 Ember issue，或去创建一个。Issue 中应包含：**场景描述**（必有：空间、物体、玩家能看见/交互什么）；**运行逻辑**（可选：脚本、输入、胜负、UI）。没有 issue 不要开工。细则只在该 skill 里。
