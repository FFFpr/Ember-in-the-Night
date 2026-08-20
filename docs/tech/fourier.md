---
author: F
updated: 2026-08-20
status: thinking
---

# 傅里叶图形与映射

`FourierGraphic` 是图形。几何修改经 `FourierMap`（傅里叶映射）进行；动画经 `FourierAnime` 将映射与子动画按序合成。

## 映射

```text
FourierMap.变换(graphic: FourierGraphic) -> FourierGraphic
```

公开入口。实现固定为调用自身的 `_变换(graphic)` 并返回结果。

```text
FourierMap._变换(graphic: FourierGraphic) -> FourierGraphic
```

内部钩子。`FourierAffine2D` 与 `FourierDeform` 继承 `FourierMap`，并实现 `_变换`。具体仿射与非仿射变体继续重写 `_变换`，不改 `变换` 的签名。

`FourierAffine2D`：平面仿射 `p ↦ L(p) + v`。`L` 对波叠加分配；`v` 施加一次；组合图将同一映射作用到每个子图形。

`FourierDeform`：非仿射轮廓扰动。在合成后的轮廓上作用，不对波叠加分配。

## 动画

`FourierAnime.components` 的每一项是 `FourierAnime` 或 `FourierMap`。

```text
FourierAnime.play(graphic: FourierGraphic) -> FourierGraphic
```

按 `components` 次序执行：对 `FourierAnime` 调用 `play`，对 `FourierMap` 调用 `变换`。每一步的输出作为下一步的输入，返回最后一份 `FourierGraphic`。
