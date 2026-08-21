---
author: F
updated: 2026-08-21
status: active
---

# 开发日志

## 2026-08-21(这一天是人工书写的，agent不要修改这一天的内容)

### 迄今为止的工作探索

- 尝试了几种2D表现的方式，感觉都不是太好：
  1. 一开始想用LPC风格的像素风，优点是平台现成资源多，素材尺寸标准，容易形成统一风格；缺点是成品劣质，上限不高。只是开发原型的话不如用纯色块
  2. 后来探索HD-2D，这种表现方式确实可以尝试。但是在没想好怎么应用之前，我认为应该先暂且搁置。
 
- 对于AI编程游戏的探索。以kelly-room demo为例子测试自动化开发流程暴露出很多工程问题
  1. 一开始尝试在submodule下启动独立的agent，由ember仓库的agent构建描述，发布工单。这个出发点是，场景构建者可以专心构造场景，素材绘制者专心使用Aseprite绘制像素画。但一个非常严重的问题是，因为多agent增大了沟通成本，素材难以一次通过。极大地提高了token的消耗。这条路是行不通的。
  2. opus4.8曾经独立生成贴图，完成场景搭建。但是贴图出来的效果并不好。而且场景光影等感官AI并不能完整承担调试的责任
 
- 对于美术和特效的想法
  1. 还是用像素来处理素材，可以人工自己画或者找样例图，再由AI把素材“标准化”，并填充细节
  2. 设计了一套基于傅里叶变换的线条图形，以一个低于一帧时间的周期循环播放波形，用来表现另一种风格的画面（需要性能调优）
  3. 游戏的主题依然是打铁，但是可能先不考虑除了打铁以外的部分
  4. 关键词是打击感和简单线条
 
- 接下来开发的方向
  1. 停止美术素材的纠结
  2. 开发逆向傅里叶工具
  3. 使用简单色块/线条进行原型开发，调试操作手感
  4. 探索由傅里叶图形主导的，graphic-physics双通道模式和graphic-sprite单通道模式

## 2026-08-20

### 进度

- 从 git 中移除 `Aseprite-User` submodule（子模块）。像素资源仍在 [Aseprite-User](https://github.com/FFFpr/Aseprite-User)；需要本地 `export/` 时在根目录独立 clone，该路径由 `.gitignore` 忽略。

## 2026-08-13

### 进度

- 写入像素验收约束 [`docs/tech/pixel-art-standard.md`](tech/pixel-art-standard.md)（画布、`C ≈ 0.19 √A`、色块、锻夜板）。
- 对照图 [`docs/tech/prompt_lookdev/`](tech/prompt_lookdev/)（非正式交付）。
- 缺图像素 issue 模板补上 `C_max` 与色块验收（见 [`tech/art-style.md`](tech/art-style.md)）。

### 待办

- 正式精灵向 Aseprite-User 按该约束开 issue。

## 2026-08-12

### 进度

- 将 [`Aseprite-User`](https://github.com/FFFpr/Aseprite-User) 以 submodule 链入根目录 `Aseprite-User/`（跟踪 `main`）。
- 在 [`docs/tech/art-style.md`](tech/art-style.md) 规定：HD-2D 下**全部**像素 2D 素材只从该 submodule 的 `export/` 取得；缺失则向 Aseprite-User 按标准模板开 issue（画布、锚点、动画、描述等）。

### 待办

- 新建 / 修订场景按 HD-2D SoT；玩法像素图一律等 Aseprite-User 导出，勿在本仓库旁路存放。
- 择机将 `art_style_demo/` brief 从 LPC 表述对齐到 art-style SoT。
- 用最小 Godot 场景验证受光 + 投影 + Nearest 可读性。

## 2026-08-11

### 进度

- 在 [`docs/tech/art-style.md`](tech/art-style.md) 将艺术语言改锁为 **HD-2D**；**放弃 LPC** 强制规范。
- 明确 Aseprite（资产生产）与 Godot（场景 / 光影 / 逻辑）分工；本仓库主体不负责用 Aseprite 生产素材。
- 写入 Godot 最小设置（`AnimatedSprite3D` / `Sprite3D`、shaded、cast_shadow、Alpha Cut、Nearest、Billboard）、技能点光、画面层（光 / 雾 / 景深 / Bloom / 粒子）、常见坑与 Nearest / 受光投影说明。

### 待办

- 新建 / 修订场景按 HD-2D SoT；择机将 `art_style_demo/` brief 从 LPC 表述对齐到本文件。
- 用最小 Godot 场景验证受光 + 投影 + Nearest 可读性。

## 2026-08-09T15:58:18Z

### 进度

- 在 [`docs/tech/art-style.md`](tech/art-style.md) 中将项目艺术语言锁定为 **LPC**。（**已于 2026-08-11 被 HD-2D 取代**）
- 约束：所有场景纹理 / 精灵 / 图块集必须符合 [LPC Style Guide](https://lpc.opengameart.org/static/LPC-Style-Guide/build/styleguide.html)。
- 推荐浏览索引：[Nearly all the LPC assets in one place](https://opengameart.org/content/nearly-all-the-lpc-assets-in-one-place)。
- 将 [`art_style_demo/README.md`](../art_style_demo/README.md) 的素材来源同步到同一 SoT。

### 待办

- 任何新建或修订场景优先使用 LPC 系列素材包；以 `06_pixel_2d` 作为仓库内 LPC 对齐基线。（已取消 — 见 2026-08-11）

## 2026-08-09T15:26:00Z

### 进度

- 将玩法代码移入 `app/`（`entities/`、`systems/`、`levels/`、`resources/`、`addons/`）。根目录保留 `project.godot`、`art_style_demo/` 与 `docs/`。

### 待办

- 除非方向变更，否则从已合并的 Plan B 像素轨 (`06_pixel_2d`) 继续 look-dev。

## 2026-08-09T05:51:00Z

### 进度

- 合并 **PR #11**（Plan B / `06_pixel_2d`），因为该 demo 相对 look-dev 评审标准完成度最高。
- 关闭其他美术 demo PR（Plan A [#7](https://github.com/FFFpr/Ember-in-the-Night/pull/7)、Plan E [#10](https://github.com/FFFpr/Ember-in-the-Night/pull/10)、Plan C [#9](https://github.com/FFFpr/Ember-in-the-Night/pull/9)、Plan D [#8](https://github.com/FFFpr/Ember-in-the-Night/pull/8)）。
- **Plan A** 与 **Plan E**：技术路线仍视为正确（柔和插画 `01` + 带光 `02`）；迭代后 demo 质量不足，故关闭这些 PR。
- **Plan C / D**（及其他非 B 范围）：暂不考虑。
- 在 [`docs/tech/art-style.md`](tech/art-style.md) 记录了 Plan A / B / E 技术路线。

### 待办

- 除非方向变更，否则从已合并的 Plan B 像素轨 (`06_pixel_2d`) 继续 look-dev。
- 除非本日志重新开启，否则不再推进 Plan A / E 的 demo PR，也不推进 Plan C / D。

## 2026-08-08T08:30:00Z

### 进度

- **PR B (`06_pixel_2d`)**：可运行的 `workshop/workshop.tscn` + `street/street.tscn`（320×180 @ 4×，最近邻过滤，锁定相机）。
- 街道昼夜经由 `day_night.gd`（0–10 s 白天 / 10–20 s 夜晚，淡入淡出 ≤0.5 s）。
- 在 `art_style_demo/shared/imported/` 导入非 AI 素材包：`lpc_blacksmith`、`lpc_base_assets`（LICENSE + credits）。

### 待办

- ~~按 PR 拆分实现其余方案 demo（A，然后 C；D 可选）。~~ 已被 2026-08-09 取代：仅保留 Plan B。
- 在 Godot 4.7 中用 F6 审阅 `06`；待 Track A 落地后与之比较。

## 2026-08-08T04:10:47Z

### 进度

- 根 `README.md`：链到官方 Godot 4.7 文档（home、performance、best practices、engine details）。
- `art_style_demo/`：脚手架 + **agent 建造 brief**（锁定色板/构图、文件约定、完成清单）。
- 参考图在 `art_style_demo/references/`（插画 + 像素轨）。
- 新增方案 `06_pixel_2d`（像素轨；最近邻过滤 / 整数缩放）。
- `docs/tech/art-style.md`：两条 look-dev 轨；指向 demo brief。

### 待办

- 按 `art_style_demo/README.md` 实现可运行 demo（每个：`workshop/workshop.tscn` + `street/street.tscn`，白天 0–10s / 夜晚 10–20s）。
- 将**免费商店、非 AI、开源许可**的美术收集到 `art_style_demo/shared/imported/`（必须有 credits/LICENSE；勿把 AI `references/` 当场景美术）。
- 在 Godot 4.7 中审阅（每场景 F6）；选定制作方向。

#### PR 拆分（历史 — 已被 2026-08-09 取代）

> 结果：仅 **PR B** 合并；Plan A / E demo 关闭（技术路线保留在 tech 文档）；C / D 暂不推进。见 2026-08-09 条目与 [`tech/art-style.md`](tech/art-style.md)。

| PR | 范围 | 为何放一起 |
|----|--------|----------------|
| **PR A**（亦含 Plan E 并行） | `01_pseudo_perspective_2d` + `02_2d_lighting` | 同一布局；`02` 必须克隆 `01`。最小有用对比（平面 vs 带光）。 |
| **PR B** | `06_pixel_2d` | 独立艺术语言轨 + 不同素材包/过滤规则；可在 A 之后或选定像素包后并行开始。 |
| **PR C** | `04_locked_3d_camera` | 3D 灰盒 / 第一人称管线；与 2D 对照且不依赖 A 的图板。 |
| **PR D**（可选） | `03_isometric` 和/或 `05_hybrid_2d_3d` | 仅当 A–C 仍不足以明确方向时。此处优先**每 PR 一种方案**（先 `03` 再 `05`，或跳过）。 |

各实现 PR 的规则（拆分仍有效时适用）：

- 一次 agent 通过 ≈ 上表一行 PR（A 是唯一有意捆绑两种方案的）。
- 首次使用某素材包的 PR 须在 `shared/imported/` 附带 credits。
- 除共享文档外，勿在同一 PR 混入 Track A 插画场景与 Track B 像素场景。
- 当前 docs/refs PR（`art_style_demo` 脚手架）与可运行场景 PR 分开。

## 2026-08-07T16:57:10Z

### 进度

- Godot 4.7 项目脚手架：锤子物理 demo（`entities/`、`systems/`、`levels/test_scene.tscn`）。
- 设计文档树与 Cursor / Cloud Agent 设置已就绪。
- `gda`（Godot Agent）CLI + MCP 已对照主场景验证；live harness 已提交。

### 待办

- 在用户本机：启动 agent 并同步 / 配置环境。
