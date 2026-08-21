---
author: F
updated: 2026-08-20
status: thinking
---

# FourierGraphic 与 FourierMap

`FourierGraphic` 是图形。几何修改经 `FourierMap` 进行；动画经 `FourierAnime` 将 `FourierMap` 与子动画按序合成。

## FourierMap

```text
FourierMap.transform(graphic: FourierGraphic) -> FourierGraphic
```

公开入口。实现固定为调用自身的 `_transform(graphic)` 并返回结果。

```text
FourierMap._transform(graphic: FourierGraphic) -> FourierGraphic
```

内部钩子。`FourierAffine2D` 与 `FourierDeform` 继承 `FourierMap`，并实现 `_transform`。具体仿射与非仿射变体继续重写 `_transform`，不改 `transform` 的签名。

`FourierAffine2D`：平面仿射 `p ↦ L(p) + v`。`L` 对波叠加分配；`v` 施加一次；组合图将同一个 `FourierMap` 作用到每个子图形。

```text
FourierAffine2D.compose(items: list[FourierAffine2D]) -> FourierAffine2D
```

类方法。按 `items` 从左到右依次作用，结果等价于这些仿射在 `play` 中相邻执行。空列表为单位仿射。

`FourierDeform`：非仿射轮廓扰动。在合成后的轮廓上作用，不对波叠加分配。

## FourierAnime

`FourierAnime.components` 的每一项是 `FourierAnime` 或 `FourierMap`。

```text
FourierAnime.flatten() -> list[FourierMap]
```

将 `components` 递归展开为只含 `FourierMap` 的列表，次序与原先嵌套执行一致。

```text
FourierAnime.play(graphic: FourierGraphic) -> FourierGraphic
```

先 `flatten`，再单次遍历把相邻的 `FourierAffine2D` 用 `compose` 合并，然后对缩短后的列表按序调用 `transform`，每一步输出作为下一步输入。空列表原样返回 `graphic`。
