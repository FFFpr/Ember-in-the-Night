# 美术风格 demo — 建造 brief

用于对比呈现方式的脚手架 + **建造规则**。无先前聊天上下文的 agent 应能仅凭本文件与各方案 README 实现。

主题：锻炉之火 / 漫长之夜 / 余烬。设计：[`docs/design/theme.md`](../docs/design/theme.md)。视觉锁定：[`docs/tech/art-style.md`](../docs/tech/art-style.md)（HD-2D）。像素画布 / 色数：[`docs/tech/pixel-art-standard.md`](../docs/tech/pixel-art-standard.md)。本 brief 里的 LPC 句是历史脚手架，**新场景以 art-style SoT 为准**。

## 目标

在 `art_style_demo/` 下交付**可运行**的 Godot 4.7 场景，使人能打开各方案并比较观感。这些是 **look-dev** demo，不是玩法。

## 锁定视觉规则（所有方案）

| 规则 | 值 |
|------|--------|
| 视口 | **1280×720**，拉伸模式已项目级配置（`canvas_items` / `expand`） |
| 画幅 | 按 **16:9** 构图 |
| 艺术语言 | **LPC**（见项目 SoT）— 最近邻过滤，像素图块整数缩放 |
| 色板 | 室外冷色「漫长之夜」蓝/灰；锻炉与夜窗暖色余烬橙/琥珀 |
| 工坊相机 | **工作台第一人称**：锁定，看向锻炉 + 铁砧（见参考图）。无自由视角。可选极小 idle 晃动（像素轨：优先像素对齐，无模糊晃动）。 |
| 街道相机 | **固定店面取景**（昼夜同一相机） |
| 街道时间 | **0–10 s 白天**，**10–20 s 夜晚**，然后循环或停止；过渡 ≤0.5 s 淡入淡出可接受 |
| 公平对比 | 各方案同一道具*集*与同一*构图意图*；仅呈现 / 艺术语言变化 |

### 艺术语言

项目锁定为 **LPC**。新建或修订的 demo 场景必须使用符合 LPC Style Guide 的素材包。脚手架目录 `01`–`05` 可能滞后；**`06_pixel_2d`** 是仓库内 LPC 对齐基线。

### 必需道具（工坊）

锻炉/炉床、铁砧、风箱、工具架（锤子/钳子）、淬火桶、矿石或锭、悬挂马蹄铁、昏暗椽梁。可选：小冷窗。

### 必需可读性（街道）

铁匠铺立面 + 门、简单悬挂招牌、少量街道道具（桶/木箱）、鹅卵石或土路、邻楼体块。夜晚须靠**光/色板**传达，而非换相机。

## 参考图（仅氛围 — 非游戏美术）

### Track A（插画）

| 文件 | 用途 |
|------|--------|
| [`references/workshop_fp_ref.png`](references/workshop_fp_ref.png) | 工坊第一人称构图 + 锻炉/铁砧氛围 |
| [`references/street_day_ref.png`](references/street_day_ref.png) | 街道白天取景 / 色板 |
| [`references/street_night_ref.png`](references/street_night_ref.png) | 街道夜晚取景 / 暖溢出光 |

### Track B（像素）

| 文件 | 用途 |
|------|--------|
| [`references/workshop_fp_pixel_ref.png`](references/workshop_fp_pixel_ref.png) | 像素工坊第一人称氛围 |
| [`references/street_day_pixel_ref.png`](references/street_day_pixel_ref.png) | 像素街道白天 |
| [`references/street_night_pixel_ref.png`](references/street_night_pixel_ref.png) | 像素街道夜晚 |

这些 PNG 是 **AI 生成的构图/氛围指南**。它们**不是**可交付素材：勿导入场景、勿描摹成制作美术、勿当作许可已清的素材包美术。

匹配剪影位置与冷暖分割，胜过匹配笔触。对 `06`，优先真实像素素材包，而不是追逐 AI 像素参考的精确外观。

## 素材来源（demo 美术强制）

**项目 SoT：** [`docs/tech/art-style.md`](../docs/tech/art-style.md)。场景美术必须符合 [LPC Style Guide](https://lpc.opengameart.org/static/LPC-Style-Guide/build/styleguide.html)。浏览 LPC 系列素材包：[Nearly all the LPC assets in one place](https://opengameart.org/content/nearly-all-the-lpc-assets-in-one-place)。

| 允许 | 禁止 |
|---------|-----------|
| LPC base / LPC extensions / LPC Revised / 符合 LPC Style Guide 的包（开源许可，**非 AI**） | AI 生成的场景美术（含 `references/` 下文件） |
| 引擎图元 / 纯色占位**仅在阻塞时** | 非 LPC 主角美术（如通用 low-poly 套件、以 photoreal PBR 冲刷作主视觉） |
| 在 `shared/imported/` 下有清晰许可 + 署名 | 付费包除非明确放行；刮取或来源不明的包 |

导入素材包时：

1. 文件放在 `art_style_demo/shared/imported/<pack_name>/`。
2. 添加 `LICENSE.txt` 或简短署名说明（作者、许可、URL；若商店声明非 AI / 人工创作则注明）。
3. 优先声明**非 AI 生成**的包；来源不明则跳过，另选。

## 方案

| 目录 | 手法 | 依赖 |
|-----|-----------|------------|
| [`01_pseudo_perspective_2d/`](01_pseudo_perspective_2d/) | 2D 层、视差、Y-sort / z-index | — |
| [`02_2d_lighting/`](02_2d_lighting/) | 01 的空间语言 + Light2D + 粒子 | **必须复用 01 的图板/布局** |
| [`03_isometric/`](03_isometric/) | 等距 tilemap / 菱形网格 | 自有布局；同一道具 |
| [`04_locked_3d_camera/`](04_locked_3d_camera/) | 3D 网格，锁定第一人称 / 三脚架相机 | 自有灰盒→美术 |
| [`05_hybrid_2d_3d/`](05_hybrid_2d_3d/) | 2D 外壳 + 3D 主角道具 | 优先 01/02 图板 + 3D 铁砧/锻炉 |
| [`06_pixel_2d/`](06_pixel_2d/) | 像素艺术 2D（最近邻，整数缩放） | 自有像素包；并行轨（历史 LPC 基线） |
| [`07_hd2d/`](07_hd2d/) | HD-2D：3D 关卡 + 像素 `Sprite3D` | Demo A 构图；像素标准实验 |

**范围外：** Mode7 地面投影。

## 文件与场景约定

对每个方案 `NN_name/`：

```text
NN_name/
  README.md                 # 手法说明（已有；保持同步）
  workshop/
    README.md
    workshop.tscn           # 实现后必需 — 用 F6 打开的主场景
    workshop.gd             # 可选
  street/
    README.md
    street.tscn             # 实现后必需 — 用 F6 打开的主场景
    day_night.gd            # 或 AnimationPlayer；必须驱动 20 s 循环
```

共享占位（可选，推荐）：

```text
art_style_demo/shared/
  placeholders/             # 色块 / 基础网格可接受
  imported/<pack_name>/     # 免费、非 AI、开源许可包 + LICENSE/credits
```

命名：路径 snake_case；场景根节点名为 `Workshop` 或 `Street`。

**不要**为这些 demo 改 `project.godot` 的 `run/main_scene` — 用 F6 / “Run Current Scene” 打开。

## 占位策略

| 阶段 | 允许 |
|-------|---------|
| 第一遍 | 纯色图板、基础网格、带标签的 `Sprite2D` 区域（尚无外部美术） |
| 对比遍 | `shared/imported/` 下免费商店**非 AI**开源许可包，附署名 |
| 禁止 | 场景中的 AI 美术；无许可刮取美术；来源不明的「免费」包；仅编辑器切换的昼夜 |

占位仍须达到构图（锻炉/铁砧可读；街道立面可读）。

## 昼夜约定（`street.tscn`）

- 在 `_ready` 自动开始（或 Autoplay 动画）。
- t∈[0,10)：白天外观；t∈[10,20)：夜晚外观。
- 两者使用同一 `Camera2D` / `Camera3D` transform。
- 用 `AnimationPlayer`、`Tween` 或小脚本 + timer 实现 — 每方案选一种，若不明显则在该方案 README 中说明。

## 完成清单（每方案）

- [ ] `workshop/workshop.tscn` 可运行（F6），锁定相机，必需道具可见
- [ ] `street/street.tscn` 可运行（F6），无需输入白天 10 s → 夜晚 10 s
- [ ] 匹配参考构图意图（工坊第一人称；街道店面）
- [ ] 暖色锻炉 / 夜溢出光 vs 冷环境可读
- [ ] 无自由视角 / 不需要玩法系统
- [ ] 任何第三方美术为免费商店、**非 AI**、开源许可，并在 `shared/imported/` 署名
- [ ] 未把 `references/`（或其他处）的 AI 生成文件用作场景纹理/网格
- [ ] 若为 `06`：最近邻过滤 + 整数缩放；读作像素，而非手绘
- [ ] 若为 `07`：3D 锁定相机；像素 `Sprite3D` 为 Nearest + shaded + Alpha Cut；未把 Demo A 插画当纹理

## 实现顺序

历史对比顺序（已被 2026-08-09 取代 — 仅 Plan B 交付）：

1. `01` 工坊 + 街道（占位可接受）  
2. `02` 克隆 01 布局，加灯光/粒子  
3. `06` 像素轨（选定素材包后可与 01/02 并行）  
4. `04` 灰盒第一人工坊 + 街道循环  
5. `03` / `05` 仅当对比仍需要时

当前方向：HD-2D look-dev 在 [`07_hd2d/`](07_hd2d/)；像素画法见 [`docs/tech/pixel-art-standard.md`](../docs/tech/pixel-art-standard.md)。`06_pixel_2d` 保留作历史 2D 像素对照。

## 状态

| 项 | 状态 |
|------|--------|
| 建造 brief + 参考图 | 完成（含像素轨） |
| 可运行 `.tscn` | 历史 **Plan B** `06_pixel_2d` 仍在；现行 HD-2D look-dev 为 `07_hd2d`（[`docs/tech/art-style.md`](../docs/tech/art-style.md)） |
| 已导入美术包 | `shared/imported/` 下的 LPC Blacksmith + LPC Base Assets 驱动 `06` 的墙/地/道具 |
