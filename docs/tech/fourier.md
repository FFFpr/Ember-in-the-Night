---
author: F
updated: 2026-08-20
status: thinking
---

# 傅里叶轮廓的仿射与扰动接口

> **本文件：** 闭合轮廓（傅里叶级数 / Fourier series）上两类变换的接口约定。不是当前代码实现。

图形（`Graphic`）可由多道波叠加，也可再组合成子图形。对外只暴露两个入口：仿射（affine）与扰动（deform）。调用方传入 `Graphic`，不必为子类单独特化仿射。

## 仿射

前提：映射为 `p ↦ L(p) + v`。`L` 是线性的（linear）；`v` 是平移，只加一次。

```text
apply_affine(graphic: Graphic, affine: Affine2D) -> Graphic
```

`L(Σ γₙ) = Σ L(γₙ)`。组合图把同一个 `affine` 作用到每个子 `Graphic`。子类可把旋转与均匀缩放写成对系数 `cₙ` 乘同一复数，语义须与对顶点施加 `affine` 相同。

`Affine2D` 只构造映射，不接收 `Graphic`：

```text
translate(v: Vec2) -> Affine2D
rotate(theta: float) -> Affine2D
scale(sx: float, sy: float) -> Affine2D
reflect(axis: Vec2) -> Affine2D
around(pivot: Vec2, inner: Affine2D) -> Affine2D
compose(a: Affine2D, b: Affine2D) -> Affine2D
```

`around` 用于绕任意点旋转或缩放。`compose(a, b)` 先应用 `b` 再应用 `a`。

## 扰动

前提：`Deform(Σ γₙ)` 一般不等于 `Σ Deform(γₙ)`。先合成闭合折线，再沿半径或法向位移。

```text
apply_deform(graphic: Graphic, deform: Deform) -> Graphic
```

海浪尖不是仿射：圆经仿射只变为椭圆。

```text
harmonic_ripple(n: int, amplitude: float) -> Deform
arc_spike(wavelength: float, amplitude: float) -> Deform
```

`n` 为一圈尖数。`wavelength` 为沿弧长的间距。振幅随动画时间变化时，改 `Deform` 参数并再次 `apply_deform`，不要改共用的轮廓系数。
