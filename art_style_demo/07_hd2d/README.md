# 07 — HD-2D look-dev（Demo A 构图）

上级 brief：[`../README.md`](../README.md)。像素标准：[`../../docs/tech/pixel-art-standard.md`](../../docs/tech/pixel-art-standard.md)。Godot 像素进 3D：[`../../docs/tech/art-style.md`](../../docs/tech/art-style.md)。

用 Demo A 参考图的**构图与冷暖**，而不是它的笔触。像素精灵按标准直接画（实验生产线 B）；3D 场景提供光、影、雾、景深。

## 打开

不要改 `project.godot` 的主场景。F6：

| 场景 | 路径 |
|------|------|
| 工坊 | `workshop/workshop.tscn` |
| 街道 | `street/street.tscn`（0–10 s 白天 / 10–20 s 夜晚） |

## 实验

| 路径 | 内容 |
|------|------|
| `tools/pipeline_a_convert.py` | 插画缩放 + 量化 |
| `tools/pipeline_b_draw.py` | 按画布/调色板直接画 |
| `tools/measure_sprites.py` | 色数与 4-连通色块 |
| `experiment/out/` | 对照 PNG |
| `experiment/out/prompt_lookdev/` | 按标准约束出的图（非正式交付） |
| `experiment/metrics/sprite_metrics.csv` | 测量表 |
| `sprites/` | look-dev 用的 B 线精灵（非正式 `Aseprite-User/export`） |

结论见像素标准文档。B 线精灵过数字门禁，但仍是色块草稿；正式图继续向 Aseprite-User 按标准开 issue。
