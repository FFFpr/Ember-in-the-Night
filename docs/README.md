# 文档 (`docs`)

> **本文件：** `docs/` 的目录说明——各子目录用途、文档元数据格式，以及设计文档与代码的关系。

本目录记录**游戏设计**：主题、循环、设定、叙事，以及技术路线讨论。

## 与代码的关系

- `docs/` 记录设计意图与讨论。它**不**描述代码库当前实现了什么。
- 引擎版本、开发环境，以及如何打开项目，见根目录 [`README.md`](../README.md)。
- 设计文档与代码之间**没有硬绑定**。实现可能落后、超前或偏离；何时同步任一侧由你决定。

## 目录职责

| 目录 | 职责 |
|-----------|------|
| [`design/`](design/) | 玩法与系统设计。现有：[`theme.md`](design/theme.md)（游戏主题）、[`main-loop.md`](design/main-loop.md)（主循环） |
| [`lore/`](lore/) | 世界观与设定事实 |
| [`narrative/`](narrative/) | 剧情大纲、对白及其他叙事草稿 |
| [`tech/`](tech/) | **技术路线讨论与备选方案** — 不是项目当前交付内容。现有：[`art-style.md`](tech/art-style.md)（HD-2D SoT）、[`pixel-art-standard.md`](tech/pixel-art-standard.md)（画布 / 色数 / 色块门禁）、[`gda.md`](tech/gda.md)（Godot Agent / Cursor MCP）、[`fourier.md`](tech/fourier.md)（图形仿射 / 扰动接口）；demo 在 [`art_style_demo/`](../art_style_demo/) |
| [`ideas/`](ideas/) | 随手灵感与笔记；与其他文件夹**无强制同步或晋升流程** |

`docs/` 根目录还有 [`development-log.md`](development-log.md)（按日期的进度 / 待办；不是设计基线）。

不要预先在每个子目录创建 README；仅当某文件夹变复杂时再补。

## 文档元数据

除本 `README.md` 外，每个 Markdown 文件**应**使用下方 YAML 头。用于记录，不作门禁。字段可省略；日后不清楚时再补。

```yaml
---
author: name or id
updated: YYYY-MM-DD
status: active | thinking | outdated
---
```

| `status` | 含义（仅表示设计置信度） |
|----------|----------------------------------|
| `active` | 足够扎实，可作为设计基线 |
| `thinking` | 值得推进；尚非最终结论 |
| `outdated` | 在设计意义上已被取代；勿当作现行 |

`status` **不**表示「已在代码中实现」。

## 不在本目录范围

- Cursor / agent 规则（Cursor 配置；不属于本仓库 docs 体系）
- 当前软件版本与环境（见根目录 `README.md`）
