---
author: F
updated: 2026-08-20
status: thinking
---

# 图形变换接口

对 `Graphic` 的几何修改只通过下列两个操作。签名以图形为对象；仿射不对 `Graphic` 子类做特化。

| 类型 | 含义 |
|------|------|
| `Graphic` | 图形。可由波叠加，可含子图形 |
| `Affine2D` | 平面仿射映射（affine map）`p ↦ L(p) + v` |
| `Deform` | 非仿射的轮廓扰动 |

```text
apply_affine(graphic: Graphic, affine: Affine2D) -> Graphic
apply_deform(graphic: Graphic, deform: Deform) -> Graphic
```

`apply_affine`：把 `affine` 作用到整图。`L` 对波叠加分配；平移 `v` 施加一次；组合图将同一映射作用到每个子图形。

`apply_deform`：把 `deform` 作用到合成后的轮廓。不对波叠加分配；不得用仿射接口代替。
