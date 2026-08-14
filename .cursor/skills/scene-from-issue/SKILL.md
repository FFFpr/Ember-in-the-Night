---
name: scene-from-issue
description: 按 Ember GitHub issue 实现新场景，或修改现有场景的空间/物体/美术。认领 bc、样例图定稿、把样例图翻译成拟合清单、素材按画面覆盖面积倒推且只走 Aseprite-User 工单、异步扇出/扇入、有逻辑则先测试后脚本、完工前三项判据齐备。单纯改运行逻辑不要用本 skill。
---

# 按 Ember issue 做场景

一次只做一个 Ember issue。用户必须给出 issue 号或 URL。没有 issue：停下来问。不要替用户开 Ember issue。

美术来源、基准画幅、明暗验收、Sprite 进 3D 的受光/投影，以 [`docs/tech/art-style.md`](../../../docs/tech/art-style.md) 为准；画布、色数、色块、调色板以 [`docs/tech/pixel-art-standard.md`](../../../docs/tech/pixel-art-standard.md) 为准。不要在本文件复述这两份的内容。

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

定稿之后，先做第 6 节的拟合清单，再动场景。

## 5. 样例图在哪些维度上是 target

已定稿样例图是场景 **target**，但只在下表维度上是。与更早、更短的文字清单冲突时，以定稿样例为准。

| 维度 | 是 target | 判据在哪 |
|------|-----------|----------|
| 有哪些物体、分布、遮挡关系 | 是 | 拟合清单 |
| 每个物体在画面里的位置与占比 | 是 | 拟合清单，按视口归一化 |
| 物体之间、物体与房间的比例 | 是 | 拟合清单 |
| 明暗分区、光源位置、冷暖分布 | 是（结构，不是像素值） | [`art-style.md`](../../../docs/tech/art-style.md) 画面层验收 |
| 材质笔触、渐变、色数、分辨率 | 否 | [`pixel-art-standard.md`](../../../docs/tech/pixel-art-standard.md) |
| 素材类别（2D / 3D）、画风（像素 / 写实） | 否 | `art-style.md` |
| 画幅比例 | 否 | 项目基准画幅，见 `art-style.md` |

样例图常常是照片级渲染或高清插画。要复现的是它的物体、构图、比例与明暗结构，**不是**它的材质与色数——后者按 `pixel-art-standard.md`，照抄不了也不该照抄。把照片级材质当 target，只会让验收永远无法判定，然后退化成两件坏事：把差距一律归因为「缺图」不停开工单，或者在 Godot 里用几何硬凑。

样例图里的元素可以比 issue 原先文字更多。用户往往只写和逻辑相关的物体，边角会漏。最终场景仍要包括样例图里的那些东西。

## 6. 拟合清单

样例图本身不构成判据，**从它翻译出来的拟合清单才是**。没有清单不要开始搭场景。

清单由 owner 从定稿样例逐项读出，先发 issue 评论请用户确认，通过后写进 issue body。每一项都必须是完工时能被一张截图判成 PASS / FAIL 的陈述：

- **物体：** 名字、数量、是否必须完整落在画面内（一切可交互物都必须）、被谁遮挡。
- **位置与占比：** 用 `art-style.md` 的归一化坐标，加占画面宽或高的比例，写区间不写单点。例如「摇杆中心 (0.88±0.04, 0.62±0.05)，高度占画面 0.30±0.05」。
- **明暗：** 暗部收边落在哪、最亮处在哪、冷暖怎么分区。量化判据见 `art-style.md`。
- **可读性：** 画面里每处文字与数字，在基准画幅 1:1 下必须能读出来。

只写能从样例图看出来的事实，不写实现方式。清单是后续所有取舍的仲裁者：与它冲突的实现改实现；清单本身要改，先改 issue。

本 run 的 token 可能开得了 issue 但评不了、也改不了 body（`Resource not accessible by integration`）。那就退回到对话里请用户确认，并请用户把定稿清单贴进 issue body。**不要**因为发不出评论就跳过确认、直接开工。

## 7. 素材清单：按画面覆盖面积倒推

把定稿样例按**覆盖面积**切块（墙、地、天花、玻璃与框、成片背景堆叠物、道具、UI），再给每块指定负责方：

| 负责方 | 承担 |
|--------|------|
| Aseprite 工单 · 空间级 | 可平铺贴图、大面积背景、成片堆叠物 |
| Aseprite 工单 · 道具级 | 单体物件、图标、UI |
| Godot 画面层 | 灯光、阴影、雾、后期、几何与碰撞代理 |

**单块覆盖画面 ≥ 5% 且属于像素 2D 的，不允许由程序化灰盒长期承担**，必须有对应工单；灰盒只在工单在途时顶着。

不要按「玩家能点什么」列资产。那样会漏掉决定观感的大面积块——一轮下来最容易出现的结果，就是道具都出了图，而墙、地、光影全是代码里的灰盒，于是观感由代码决定，而代码没有判据。

成片堆叠物按「一张能拼出成片效果的图」开工单（例如侧视堆叠 tile），不要拿一张单体正视图去程序化复制成网格。

## 8. 素材来源

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

## 9. 素材工单（扇出）

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

## 10. 异步

开完工单立刻做还剩的事。不要阻塞，不要 `sleep` / 轮询等待工单关闭。

## 11. 扇入

任意一次 run 结束前，必须扫本 Ember issue 上是否有**未处理的工单回执评论**（含 PR、`src/`、`export/`、对 `bc-…` 的发送尝试）。忽略普通讨论。

有新回执则：按评论里的 commit/路径更新 `Aseprite-User` 子模块（尽量钉到该工单合并的 SHA，不要无说明地盲追无关提交）、拉 LFS、对照拟合清单验收；不行就开修改工单。处理过的回执在 Ember issue 里留一句已消化（或勾清单），避免每个 run 重复 bump。

被 follow-up 叫醒时同样先扫评论，再继续场景。

## 12. Git

只推自己的功能分支。开或更新 draft PR。**不要 merge**，除非用户明确要求。不要 force push，不要 amend 他人的提交。

## 13. 质量责任

动手前与用户把运行逻辑谈清楚；有逻辑则先写进 issue，再实现。逻辑在实现中若要改：先改 issue，再改测试，再改代码。

代码按软件工程来：职责分离、可测、同一事实只写一处。

**有运行逻辑时：**

1. Issue 上的逻辑必须清晰、可执行；否则先和用户确认并改 issue。
2. 实现任何脚本之前，按已确认逻辑写测试。
3. 实际跑的逻辑必须与 issue 描述完全一致。
4. 没有运行逻辑：不要为凑数写测试。
5. 决定完工前跑测试：全部通过，或明确某条用例已过时并改正文/测试后再跑。

**素材：** 你监管工单产出是否对得上拟合清单。不对就开修改工单。

**决定完工前，三样齐备，缺一不算完工：**

1. **管线可用。** submodule 已初始化、LFS 已拉（见 `art-style.md` 素材来源），`export/` 下拿到的是真图不是 LFS 指针，缺图会显式报错而不是静默退灰盒。
2. **基准画幅全画幅截图。** 在项目基准画幅（见 `art-style.md`）下跑场景出图，与定稿样例并排。局部裁切只能作补充，**不能**作唯一证据。
3. **清单逐项判定。** 拟合清单每项给 PASS / FAIL，附实测数字：可交互物与清单物体的 `Camera3D.unproject_position()` 投影位置与占比，以及明暗判据的量化结果。判定要能重复跑，不要靠一次目视。

有 FAIL 就继续做：Godot 侧能解决的自己改，缺图或图不对的开修改工单，然后再来一轮。不要把 FAIL 写进 PR 描述当已知问题报完工。

测试全绿但截图与清单对不上，不算完工。样例图与旧文字冲突时以定稿样例为准；2D/3D 与画风仍以 `art-style.md` 为准。
