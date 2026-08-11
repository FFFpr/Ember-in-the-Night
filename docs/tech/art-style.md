---
author: F
updated: 2026-08-09
status: active
---

# 美术风格与技术路线

> **本文件：** 项目美术方向的 SoT。可运行的 look-dev demo 在 [`art_style_demo/`](../../art_style_demo/)——导入路径与机制留在那里；勿在此重复场景文件清单。

## 方向（已锁定）

| 项 | 选择 |
|------|--------|
| 艺术语言 | **LPC (Liberated Pixel Cup)** — 俯视 / 四分之三正交 **32×32** 像素 RPG 风格 |
| 氛围 | 冷色漫长之夜室外；暖色余烬锻炉作为情感关键 |
| look-dev 基线 | 已合并的 Plan B 像素 demo [`art_style_demo/06_pixel_2d/`](../../art_style_demo/06_pixel_2d/) |

## 项目约束（所有场景）

**强制：** 用于**任何场景实现**的每一张纹理、精灵、图块集（`app/` 下玩法、`art_style_demo/` 下 look-dev，或未来关卡）必须符合官方 LPC Style Guide：

https://lpc.opengameart.org/static/LPC-Style-Guide/build/styleguide.html

| 规则 | 细节 |
|------|--------|
| 允许 | LPC base、LPC extensions、LPC Revised，以及其他符合 style guide 的素材包 |
| 另需 | 免费/开源许可、**非 AI**、导入时附署名 |
| 禁止 | AI 生成的场景美术；非 LPC 的主角美术（如通用 low-poly 套件、以 photoreal PBR 作为主视觉）；无许可刮取 |

demo 的导入目录约定：[`art_style_demo/README.md`](../../art_style_demo/README.md) § Asset sourcing。

## 推荐浏览页

LPC 系列素材包索引（浏览并挑选；**不是**一个直接整包倒进仓库的 zip）：

https://opengameart.org/content/nearly-all-the-lpc-assets-in-one-place

## 参考图（仅氛围）

[`art_style_demo/references/`](../../art_style_demo/references/) 下的 AI 生成构图参考**不是**场景美术，不得导入场景。优先使用 LPC 素材包，而不是去贴近那些 PNG 的笔触。

## look-dev 历史（已取代的方向）

早期双轨实验（柔和插画 Track A vs 像素 Track B）以及 Plan A / E / C / D 仅作背景记录。**制作与新场景工作遵循上方 LPC。** Plan B 已合并的 `06_pixel_2d` demo 仍是仓库内最接近 LPC 对齐的基线。
