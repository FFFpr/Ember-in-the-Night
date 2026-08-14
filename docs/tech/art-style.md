---
author: F
updated: 2026-08-14
status: active
---

# 美术风格与技术路线

> **本文件：** 项目美术方向的 SoT。可运行的 look-dev demo 在 [`art_style_demo/`](../../art_style_demo/)——导入路径与机制留在那里；勿在此重复场景文件清单。

## 方向（已锁定）

| 项 | 选择 |
|------|--------|
| 艺术语言 | **HD-2D** — 像素风格角色 / UI / 特效 + 可走进的 3D 场景 + 电影感光影 |
| 氛围 | 冷色漫长之夜室外；暖色余烬锻炉作为情感锚 |
| 参考气质 | 《歧路旅人》(Octopath Traveler) 一类：立体关卡里的像素角色，而非纯 2D tilemap RPG |
| 像素资产来源 | **仅** [`Aseprite-User/`](../../Aseprite-User/) submodule 的 `export/`（见下方「素材来源」） |
| look-dev | 既有 `art_style_demo/`（含原 LPC 像素 demo）**可能滞后**；新建 / 修订场景按本文件 HD-2D |
| 像素约束 | [`pixel-art-standard.md`](pixel-art-standard.md) |

**已放弃：** 以 **LPC (Liberated Pixel Cup)** 为强制艺术语言与场景素材规范的方向。不再要求纹理 / 精灵符合 LPC Style Guide；不再以 `06_pixel_2d` 作为现行对齐基线。

## 工具分工

| 工具 | 负责 |
|------|------|
| **Aseprite-User**（submodule） | 全部像素 2D 资产的生产与导出（角色 / UI / 图标 / 像素贴图 / 2D 特效帧） |
| **Godot**（本仓库） | 3D 场景、灯光、阴影、景深、雾、粒子、材质与纹理采样、游戏逻辑；从 submodule 导入并挂接 |

**本仓库主体职责在 Godot：** 导入、挂接、受光 / 投影、环境与后期。**不要**在本仓库内新建或旁路存放像素精灵 / UI / 2D 特效图；缺什么就按下方模板向 [Aseprite-User](https://github.com/FFFpr/Aseprite-User) 提 issue。

## 基准画幅

| 项 | 值 |
|----|----|
| 基准画幅 | `project.godot` 的视口尺寸；未显式设置时为 Godot 默认 **1152×648（16:9）** |
| 出图 | 验收截图在基准画幅下 1:1 出，不要用参考图的画幅 |
| 参考图画幅 | 参考图未必是 16:9；比对时按基准画幅重取景，别把参考图的宽高比当成机位约束 |

场景里物体的位置与占比一律按基准画幅归一化描述（左上原点，`x, y ∈ [0, 1]`）。用参考图的像素坐标会在画幅不一致时失真。

## 画面层验收（明暗）

HD-2D 的观感主要来自这一层。缺判据时，环境光叠方向光再叠点光很容易把暗部整体抹平，画面变成一片均匀暖橙，看起来跟参考图完全是两个场景。

判据量在最终截图上（转灰度，0–255）：

| 判据 | 要求 | 怎么量 |
|------|------|--------|
| 暗部收边 | 边缘均值 ≤ 中心均值 × 0.5 | 四边各 10% 宽条带的均值，比中心 40%×40% 区域的均值 |
| 整体亮度 | 夜间室内画面灰度均值落在 **30–50** | 全幅均值 |
| 光源可见 | 每个照亮画面的暖光源，本体必须在画面内，或有画面内的明确动机 | 截图 + `Camera3D.unproject_position()` |
| 最亮区 | 整幅只有一处最亮区（单个物件的最亮点约束见 [`pixel-art-standard.md`](pixel-art-standard.md)） | 直方图 + 目视 |
| 冷暖分区 | 暖光只落在它够得到的范围，其余保持冷调；不要全局暖泛光 | 对照定稿参考 |

夜间室内以 `OmniLight3D` / `SpotLight3D` 为主，`DirectionalLight3D` 与 `ambient_light_energy` 只作补位。

## Godot 最小设置（像素角色进 3D）

| 项 | 要求 |
|----|------|
| 节点 | `AnimatedSprite3D` / `Sprite3D` |
| 受光 | `shaded = true` |
| 投影 | `cast_shadow = ON` |
| 透明 | **Alpha Cut / Discard**（阈值约 **0.5**）；避免主体用纯 Alpha Blend（易导致影子失败） |
| 采样 | `texture_filter = Nearest` |
| 面向 | 需要时 Billboard / Y-Billboard |
| 场景 | 有开启 Shadow 的灯 + 能接影的地面 Mesh |

未齐这些项时，角色容易像浮在场景上的贴纸，或有光无影 / 透明无影。

## 技能点光

特效播放时同步加 `OmniLight3D`（《歧路旅人》常用思路）：影子与光效一起打在环境上，技能读作「照亮了这个世界」，而不是只在精灵层闪帧。

## 灯光 / 雾 / 景深（画面层）

| 手段 | 节点 / 设置 | 用途 |
|------|-------------|------|
| 主光 | `DirectionalLight3D` + Shadow | 日照、主投影 |
| 点光 / 聚光 | `OmniLight3D` / `SpotLight3D` | 火把、技能、室内 |
| 深度雾 | Environment Fog | 大气透视 |
| 体积雾 | Volumetric Fog / `FogVolume`（Forward+） | 光束、体积感 |
| 景深 | `CameraAttributes` DoF | 移轴 / 微缩电影感 |
| Bloom | Environment Glow | 高光氛围（宜克制） |
| 粒子 | `GPUParticles3D` / `CPUParticles3D` | 环境氛围；大招可配合 Aseprite 帧 |

后期与像素可读性冲突时，优先保角色轮廓与点阵可读（尤其 Bloom、DoF）。

## 常见坑

| 现象 | 处理 |
|------|------|
| 像素发糊 | `Filter = Nearest` |
| 角色亮度不变 | 开 `shaded` |
| 无影子 | 开 `cast_shadow` + 灯光 Shadow + 地面接影 |
| 透明无影 | 改 Alpha Cut，勿用 Blend 做主体 |
| 像纸片 | Billboard / 多方向换图 |
| Bloom 冲掉点阵 | 降低强度，保轮廓可读 |
| 画面被泛光冲平、暗部消失 | 降 `ambient_light_energy` 与方向光，改以点光为主；按「画面层验收」量边缘/中心亮度比 |
| 纹理读不出来、场景全是灰盒 | 先查 submodule 是否初始化、LFS 是否拉过（见「素材来源」）；不要当成美术问题 |

## Godot 关键技术点

### Nearest（最近邻过滤）

- **是什么：** 放大采样时取最近纹素，不混色 → 硬像素边。
- **对比 Linear：** 混色后发糊。
- **谁设置：** Godot 导入 / 材质 / 精灵，**不是** Aseprite。
- **建议用于：** 角色、UI、图标、像素贴图、2D 特效帧。

### Sprite 进 3D：受光与投影

平面像素角色放进 3D 世界后：

- **受光（shaded）** — 随方向光 / 点光改变亮暗
- **投影（cast shadow）** — 把影子打在地面 / 墙上

否则像贴纸浮在场景上；齐了才像站在同一个世界。

## 素材来源（强制）

游戏主风格为 **HD-2D**。玩法与正式场景用到的**全部像素 2D 素材**必须来自 submodule [`Aseprite-User/`](../../Aseprite-User/)：

| 路径 | 用途 |
|------|------|
| `Aseprite-User/export/` | 游戏侧可读的导出 PNG（唯一消费入口） |
| `Aseprite-User/src/` | `.aseprite` / `.ase` 源文件（只在资源仓库编辑，不在本仓库复制） |

克隆后先初始化，并拉 LFS——`Aseprite-User` 的 PNG 全部存在 Git LFS 里：

```bash
git submodule update --init --recursive
git -C Aseprite-User lfs pull
```

没拉 LFS 时 `export/` 下是文本指针，Godot 读不出纹理。**消费侧读不出图必须显式报错**，不要静默退回灰盒：那会让「环境没拉 LFS」伪装成「美术不够好」，同一个 commit 在两台机器上渲出两个场景。

| 允许 | 说明 |
|------|------|
| 引用 `Aseprite-User/export/**` | 正式玩法、关卡、UI、2D 特效 |
| Godot 侧程序化 / 灰盒 Mesh | 3D 碰撞代理、占位几何；不是像素精灵替代品 |
| `art_style_demo/` 历史导入包 | 仅 look-dev 遗留；**不得**当作新玩法素材来源 |

| 禁止 | 说明 |
|------|------|
| 在本仓库 `app/` 等处手搓 / 另存像素图 | 一律走 Aseprite-User |
| AI 生成的场景美术当交付物 | 参考图除外，见下方 |
| 无许可刮取；以 photoreal PBR 冲刷作主视觉 | 可作灰盒 / 碰撞代理 |

### 缺素材时：向 Aseprite-User 开 issue

1. 先查 `Aseprite-User/export/`（及 `src/`）是否已有可用资源。
2. 没有则在 **[FFFpr/Aseprite-User](https://github.com/FFFpr/Aseprite-User/issues/new)** 开 issue，**不要**在本仓库用临时 PNG 顶替。
3. Issue 正文使用下方模板（可删无用行，但画布、锚点、描述必填）。画布与 `C_max` 按 [`pixel-art-standard.md`](pixel-art-standard.md)。

#### Issue 标题

```text
[asset] <短名> — <用途一句话>
```

示例：`[asset] player_idle — 铁匠待机四向`

#### Issue 正文模板

```markdown
## 用途
<!-- 谁用、在什么场景 / UI / 特效里出现；关联的本仓库 issue / PR（若有） -->

## 建议路径
<!-- 导出目标，例如 export/characters/player/idle.png -->
- src: `src/...`
- export: `export/...`

## 画布
| 项 | 值 |
| --- | --- |
| 画布大小 (px) | 必须选自 [`pixel-art-standard.md`](pixel-art-standard.md) 画布表，例如 `48×48` |
| 透明背景 | 是 / 否 |
| 色数上限 `C_max` | 按该文件公式填写；索引色 |
| 调色板 | 锻夜板子集，列出用到的色名 |

## 锚点
| 项 | 值 |
| --- | --- |
| 原点 / 锚点 | 例如底部中心 `(16, 31)`；或脚底、握点、特效中心 |
| 与其他资产对齐 | 例如与 `export/...` 同脚底线 |

## 动画（若需要）
| 项 | 值 |
| --- | --- |
| 是否动画 | 静帧 / 动画 |
| 帧数 | |
| 帧尺寸 | 单帧宽×高；是否统一 |
| 方向数 | 例如 1 / 4 / 8 |
| 时长 / FPS | |
| 循环 | 是 / 否；起止帧约定 |
| 切片 / Tag 名 | 例如 Aseprite tag：`idle`、`walk` |

## 描述
<!-- 剪影、服饰、冷暖、是否发光、禁止事项；一两段即可 -->

## 参考
<!-- 可选：情绪板、本仓库 docs 链接、竞品截图（勿要求描摹受版权图） -->

## 验收
- [ ] 已导出到约定 `export/` 路径
- [ ] 锚点与画布符合上表
- [ ] 色数 / 碎点比 / 平均色块符合 [`pixel-art-standard.md`](pixel-art-standard.md)
- [ ] 颜色来自锻夜板
- [ ] 纯黑剪影仍可读
- [ ] （动画）tag / 帧序可被 Godot 导入使用
```

## 素材约束

| 规则 | 细节 |
|------|------|
| 目标观感 | HD-2D：像素 2D 资产 + 3D 关卡与电影感画面层 |
| 像素来源 | **仅** `Aseprite-User/export/`（见「素材来源」） |
| 像素画法 | [`pixel-art-standard.md`](pixel-art-standard.md) |
| 许可 | 免费 / 开源许可、导入时附署名（第三方包若进入 Aseprite-User，在该仓库记录） |
| 禁止 | AI 生成的场景美术；无许可刮取；以 photoreal PBR 冲刷作主视觉（可作灰盒 / 碰撞代理）；在本仓库旁路存放像素交付物 |

demo 导入目录约定仍见 [`art_style_demo/README.md`](../../art_style_demo/README.md)；若该 brief 仍写 LPC，以**本文件**为准，并在修订 demo 时再对齐。

## 参考图

[`art_style_demo/references/`](../../art_style_demo/references/) 下的 AI 生成参考**不是**场景美术，不得导入场景，也不得当作精灵 / UI 纹理。

参考图（含照片级渲染与高清插画）可以作为**物体、构图、比例、明暗结构**的 target；**不可**作为材质笔触、色数、分辨率、画幅的 target，那些按 [`pixel-art-standard.md`](pixel-art-standard.md) 与上文「基准画幅」。把参考图当场景 target 时，先按 `scene-from-issue` 翻译成可判定的拟合清单，再动场景。

## look-dev 历史（已取代）

早期双轨实验（柔和插画 Track A vs 像素 Track B）、Plan A / E / C / D，以及曾锁定的 **LPC + `06_pixel_2d` 基线**，仅作背景记录。**现行制作与新场景工作遵循上方 HD-2D。**
