---
name: scene-from-issue
description: 按 Ember GitHub issue 做可运行场景：认领 bc、样例图定稿、素材只走 Aseprite-User 工单、异步扇出/扇入、有逻辑则先测试后脚本。用户提供 Ember issue 并要求做场景时使用。
---

# 按 Ember issue 做场景

一次只做一个 Ember issue。用户必须给出 issue 号或 URL。没有 issue：停下来问。不要替用户开 Ember issue。

美术来源、画布、色板、Sprite 进 3D 的受光/投影，以 [`docs/tech/art-style.md`](../../../docs/tech/art-style.md) 和 [`docs/tech/pixel-art-standard.md`](../../../docs/tech/pixel-art-standard.md) 为准，不要在本文件复述。

回复语言、注释与 GitHub 面向文本的语言，遵循根目录 `AGENTS.md`。不要改 `project.godot` 的 `run/main_scene`。场景落在 issue 指定的路径；issue 没写就问，不要自己挑目录。

## 1. 启动

用户启动时必须提供 Ember issue。用 `gh` 读完整 body 与评论。缺 issue 则停止。

## 2. Issue 里必须有的

- **场景描述**（必有）：空间、物体、玩家能看见/交互什么。没有则停下来让用户补，不要猜一整间房。
- **运行逻辑**（可有）：脚本、输入、胜负、UI。没有则本 issue 可以没有脚本；有则必须清晰、可执行。含糊则动手前和用户确认，写进 issue 后再实现。

## 3. 认领 bc

Issue body 里维护一行可机读标记：

```text
cursor_agent_id: bc-…
```

本 run 的 id 用 Cursor Cloud 的 run-info（或本 run URL 中的 `bc-…`）读取，不要编造。

- **没有 bc：** 把本 run 的 `bc-…` 写进 issue body，你接管。
- **有 bc 且就是你：** 继续。
- **有 bc 但不是你：** 用 Cursor Cloud Agents API 查该 agent 是否还能收 follow-up（未归档、未过期）。只看对话记录不算「活着」。
  - 活着：不要抢。告诉用户已有 owner `bc-…`，停止。
  - 死了：把 body 里的 bc 改成你的，评论说明接管，然后继续。

接管后：已经发出的 Aseprite 工单仍可能 POST 旧 `bc`。**以 Ember issue 上的回执评论为准**，不必改已开的 Aseprite issue。之后新工单才写新 `bc`。

同一 issue 同一时间只有一个活着的 owner。只推自己的功能分支。

## 4. 样例图

样例图是构图参考，**不是**进场景的像素交付物。禁止当作 `Aseprite-User/export/` 的替代，禁止当作精灵/UI 纹理 import。

- Issue 里还没有双方认可的定稿样例：按场景描述生成一张主视角图发给用户。按反馈改图，直到用户明确说通过。
- **只有用户明确通过之后**，才把该图写入 issue body。未通过的图不是 SoT，不要写进 body，也不要提交到仓库。
- 定稿图写入 issue body（附件或链接）。若 issue 指定了仓库内保存路径，同时提交到该路径，供后续 agent 读取。未指定路径则只放 issue。
- 未通过前：可以澄清场景理解、可以列缺哪些素材。**不要**写玩法代码、不要开 Aseprite 工单、不要改 issue 里的定稿样例。

## 5. 样例图是什么 / 不是什么

已定稿样例图是场景 **target**。与更早、更短的文字清单冲突时，以定稿样例为准：

- **决定：** 物体、分布、材质、贴图、色块、比例。
- **不决定：** 素材类别（2D / 3D）、画风（像素 / 写实）。类别与画风遵守 `docs/tech/art-style.md`。

样例图里的元素可以比 issue 原先文字更多。用户往往只写和逻辑相关的物体，边角会漏。最终场景仍要包括样例图里的那些东西。

## 6. 素材来源

全部像素 2D 只能用 submodule `Aseprite-User/export/` 里已有文件。不要在本仓库新建或旁路存放像素 PNG。3D 灰盒 Mesh 可以作占位，不能当像素精灵替代品。

动手前先查 `Aseprite-User/export/`（及 `src/`），包括 `export/<repo>/issue_<number>/`。不够就开工单，不要用生成图或临时 PNG 顶上。

本 issue **新产出**的资产必须成对落在：

```text
src/<repo>/issue_<number>/<rel>.aseprite
export/<repo>/issue_<number>/<rel>.png
```

- `<repo>`：本 Ember issue 所在 GitHub 仓库名（例如 `Ember-in-the-Night`）
- `<number>`：该 issue 的数字号（例如 `42`）
- `<rel>`：本 issue 下的相对路径（小写、下划线，可含分类目录）

`src/` 与 `export/` 的 `<rel>` 必须相同。

可复用、且已存在于 `export/` 其它位置的资产直接引用，不要复制进本 issue 目录。

工单未完成时：用灰盒继续搭空间、逻辑和测试；图到了再换成正式导出。不要停工等图。

## 7. 素材工单（扇出）

缺素材，或已有素材需要对：在 [FFFpr/Aseprite-User](https://github.com/FFFpr/Aseprite-User) 用 **Art asset request** 模板开 issue。标题前缀 `[art]`。**一 issue 一资产**（一对 `src/` + `export/`）。改已有图开新的修改 issue，不要重开已关闭的号。

正文必须让对端 Skill 能解析，至少包含：

- `ember_issue:` 本 Ember issue 的 URL
- `cursor_agent_id:` 你的 `bc-…`
- 绘制要求：尺寸、材质、贴图、色块、动画（若有）；画布与 `C_max` 按 `pixel-art-standard.md`
- 输出路径，必须是这一对：

```text
src: src/<repo>/issue_<number>/<rel>.aseprite
export: export/<repo>/issue_<number>/<rel>.png
```

- 其它有助于生成的信息（锚点、参考、禁止事项）

修改已有资产时：`existing_path` 写当前 `src/` 或 `export/` 路径。若该资产还不在 `src/<repo>/issue_<number>/` 下，`output_path` 仍按上式迁入本 issue 目录后再改。

Cursor 会检测 Aseprite-User 上的新 issue、派 agent 出图、尝试对你的 `bc-…` 发 follow-up，并合并、关闭 Aseprite issue。无论 follow-up 是否成功，Aseprite agent 都会在**本 Ember issue** 下留一条评论。

需要新图或改已有图：再开工单。不要在 Ember 仓改像素文件。

## 8. 异步

开完工单立刻做还剩的事。不要阻塞，不要 `sleep` / 轮询等待工单关闭。

## 9. 扇入

任意一次 run 结束前，必须扫本 Ember issue 上是否有**未处理的工单回执评论**（含 PR、`src/`、`export/`、对 `bc-…` 的发送尝试）。忽略普通讨论。

有新回执则：按评论里的 commit/路径更新 `Aseprite-User` 子模块（尽量钉到该工单合并的 SHA，不要无说明地盲追无关提交）、对照定稿样例验收；不行就开修改工单。处理过的回执在 Ember issue 里留一句已消化（或勾清单），避免每个 run 重复 bump。

被 follow-up 叫醒时同样先扫评论，再继续场景。

## 10. Git

只推自己的功能分支。开或更新 draft PR。**不要 merge**，除非用户明确要求。不要 force push，不要 amend 他人的提交。

## 11. 质量责任

动手前与用户把运行逻辑谈清楚；有逻辑则先写进 issue，再实现。逻辑在实现中若要改：先改 issue，再改测试，再改代码。

代码按软件工程来：职责分离、可测、同一事实只写一处。

**有运行逻辑时：**

1. Issue 上的逻辑必须清晰、可执行；否则先和用户确认并改 issue。
2. 实现任何脚本之前，按已确认逻辑写测试。
3. 实际跑的逻辑必须与 issue 描述完全一致。
4. 没有运行逻辑：不要为凑数写测试。
5. 决定完工前跑测试：全部通过，或明确某条用例已过时并改正文/测试后再跑。

**素材：** 你监管工单产出是否对得上定稿样例。不对就开修改工单。

**决定完工前：**

1. 跑场景，截一张与样例同机位的主视角图，和定稿样例、场景描述比对：物体、分布、尺寸、色块、动画、材质、贴图。对不上就列差异，不要报完工。
2. 测试绿但截图对不上定稿样例：不算完工。
3. 样例图与旧文字冲突时，以定稿样例为准；2D/3D 与画风仍以 `art-style.md` 为准。
