# 06 — 像素 2D

上级 brief：[`../README.md`](../README.md)。像素氛围参考：[`../references/`](../references/)（`*_pixel_ref.png`）。

## 手法

经典**像素艺术 2D**（块状像素、有限色板），与其他方案相同的工坊第一人称 + 街道昼夜约定。这是相对 `01`–`05`（手绘 / 柔和插画）的**独立艺术语言轨**。

## 像素规则（仅本方案）

| 规则 | 值 |
|------|--------|
| 观感 | 可见像素；SNES / indie 像素 RPG 读感 |
| 纹理过滤 | 根节点与精灵使用**最近邻**（`TEXTURE_FILTER_NEAREST`） |
| 缩放 | 内部 **320×180**，`Camera2D.zoom = (4, 4)` 整数放大到 1280×720；精灵缩放仅整数（`1` 或 `2`） |
| 相机 | 锁定；无位置平滑 |
| 灯光 | 锻炉/店铺暖溢出用 `PointLight2D`；不软模糊 framebuffer |
| 素材 | [`../shared/imported/`](../shared/imported/) 下免费商店**非 AI** LPC 包 |

## 导入文件 → 道具映射

### 素材包

| 素材包 | 路径 | 许可 |
|------|------|---------|
| LPC Blacksmith | [`../shared/imported/lpc_blacksmith/`](../shared/imported/lpc_blacksmith/) | OGA-BY 3.0 / CC-BY 3.0+ / GPL 2.0+ |
| LPC Base Assets | [`../shared/imported/lpc_base_assets/`](../shared/imported/lpc_base_assets/) | CC-BY-SA 3.0 / GPL 3.0 |

### 工坊

| 元素 | 文件 |
|---------|------|
| 墙 | `lpc_base_assets/slices/wall_grey_*.png`（来自 `tiles/house.png`） |
| 地面 | `lpc_base_assets/slices/floor_cobble.png`（来自 `tiles/castlefloors.png`） |
| 梁 | `lpc_base_assets/slices/beam_wood.png`（来自 `tiles/inside.png`） |
| 窗 | `lpc_base_assets/slices/window_house_a.png` |
| 锻炉 | `lpc_blacksmith/props/forge_chimney_lit.png` + `forge_wall_lit.png` |
| 铁砧 | `lpc_blacksmith/props/anvil_block.png` |
| 风箱 / 淬火 / 架 / 煤 / 工具 / 马蹄铁 | 对应 `lpc_blacksmith/props/*.png` |

### 街道

| 元素 | 文件 |
|---------|------|
| 邻楼 + 铁匠铺墙 | `wall_grey_*.png` / `wall_brick_*.png` |
| 屋顶条 | `roof_slate.png`（房屋灰填色重着色） |
| 道路 | `dirt_fill.png` + `floor_cobble.png` |
| 门 / 窗 | `door_wood.png`、`window_house_*.png`、`window_house_night.png` |
| 招牌 | `sign_sword.png` + `lpc_blacksmith/props/hammer_tool.png` |
| 锻炉隔间 / 铁砧 | `forge_wall_lit.png`、`anvil_block.png` |
| 桶 | `slices/barrel_*.png` |
| 山 | `slices/mountains.png` |

昼夜：`street/day_night.gd` 切换窗纹理并提高锻炉/窗/灯溢出（0–10 白天 / 10–20 夜晚）。

## 完成条件

- [x] 由导入的 LPC slices/props 驱动（墙/地/门/窗/关键道具非几何占位）
- [x] 明确读作**像素艺术**；最近邻 + 整数相机缩放
- [x] F6 工坊 + 街道；街道无需操作白天→夜晚；暖色夜溢出光
- [x] `shared/imported/` 下有署名；场景未使用 AI `references/`
