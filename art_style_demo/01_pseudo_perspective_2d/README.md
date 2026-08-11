# 01 — 伪透视 2D

上级 brief（先读）：[`../README.md`](../README.md)。参考图：[`../references/`](../references/)。

## 手法

完整 2D 管线。纵深 = 绘制透视 + 分层 + 视差 / z-index。此处不要求 `Light2D`（那是 `02`）。

## 建造步骤（工坊）

1. 创建 `workshop/workshop.tscn`，根节点 `Workshop`（`Node2D`）。
2. 添加锁定的 `Camera2D`（current）；构图对齐 `references/workshop_fp_ref.png`。
3. 图层（后 → 前），各为 `Node2D` 或 `Sprite2D`：
   - `LayerFar` — 后墙、窗户、炉口
   - `LayerMid` — 铁砧、风箱、桶、架子
   - `LayerNear` — 梁 / 悬挂工具 / 画框
4. 占位可接受：彩色 `Polygon2D` / `ColorRect` 组成的 `Sprite2D` 层级，但剪影须可读为锻炉 + 铁砧。
5. 可选：缓慢 `Parallax2D` 或脚本驱动的 2–4 px 相机晃动。

## 建造步骤（街道）

1. 创建 `street/street.tscn`，根节点 `Street`（`Node2D`），锁定 `Camera2D`。
2. 立面 + 街道道具，匹配白天参考构图。
3. 添加 `day_night.gd` 或 `AnimationPlayer`：
   - 0–10 s：白天 modulate / 明亮天空图板
   - 10–20 s：夜晚 modulate + 暖色窗/门发光精灵开启
4. 自动开始；无输入。

## 完成条件

- F6 工坊：工作台第一人称取景，必需道具可见  
- F6 街道：无需操作 20 s 内白天→夜晚，相机不变  
- 不依赖 `Light2D`（本方案在平涂色彩下仍须可读）

## 交接给 02

导出或保留这些场景作为**布局来源**。`02` 必须复制节点布局 / 图板，再加灯光。
