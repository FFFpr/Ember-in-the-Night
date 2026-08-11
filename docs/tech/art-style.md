---
author: F
updated: 2026-08-11
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
| look-dev | 既有 `art_style_demo/`（含原 LPC 像素 demo）**可能滞后**；新建 / 修订场景按本文件 HD-2D |

**已放弃：** 以 **LPC (Liberated Pixel Cup)** 为强制艺术语言与场景素材规范的方向。不再要求纹理 / 精灵符合 LPC Style Guide；不再以 `06_pixel_2d` 作为现行对齐基线。

## 工具分工

| 工具 | 负责 |
|------|------|
| **Aseprite** | Sprite / 动画、UI、图标、像素贴图、2D 特效帧（资产生产侧） |
| **Godot** | 3D 场景、灯光、阴影、景深、雾、粒子、材质与纹理采样、游戏逻辑 |

**本仓库主体职责在 Godot：** 导入、挂接、受光 / 投影、环境与后期。不要求在本项目流程里用 Aseprite 生产素材；像素资产可由外部管线提供，只要导入后符合下方 Godot 最小设置即可。

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

## 素材约束

| 规则 | 细节 |
|------|------|
| 目标观感 | HD-2D：像素 2D 资产 + 3D 关卡与电影感画面层 |
| 许可 | 免费 / 开源许可、导入时附署名 |
| 禁止 | AI 生成的场景美术；无许可刮取；以 photoreal PBR 冲刷作主视觉（可作灰盒 / 碰撞代理） |

demo 导入目录约定仍见 [`art_style_demo/README.md`](../../art_style_demo/README.md)；若该 brief 仍写 LPC，以**本文件**为准，并在修订 demo 时再对齐。

## 参考图（仅氛围）

[`art_style_demo/references/`](../../art_style_demo/references/) 下的 AI 生成构图参考**不是**场景美术，不得导入场景。匹配冷暖与构图意图即可，勿描摹其笔触为制作资产。

## look-dev 历史（已取代）

早期双轨实验（柔和插画 Track A vs 像素 Track B）、Plan A / E / C / D，以及曾锁定的 **LPC + `06_pixel_2d` 基线**，仅作背景记录。**现行制作与新场景工作遵循上方 HD-2D。**
