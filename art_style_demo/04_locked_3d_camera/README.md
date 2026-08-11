# 04 — 3D + 锁定相机

上级 brief：[`../README.md`](../README.md)。项目：Forward+，Jolt 可用（look-dev 物理可选）。

## 手法

真实 3D 网格；**锁定** `Camera3D`（工坊 = 真第一人称眼高约 1.6 m，看向锻炉/铁砧）。无鼠标自由视角。

## 建造步骤（工坊）

1. `workshop/workshop.tscn`，根节点 `Workshop`（`Node3D`）。
2. 用 `MeshInstance3D` 方块灰盒；有素材包网格后再替换。
3. `Camera3D` current，固定 transform；锻炉 `OmniLight3D`/`SpotLight3D` 暖色。
4. `WorldEnvironment` 温和；避免刺眼 bloom。

## 建造步骤（街道）

1. `street/street.tscn` — 立面 + 道路灰盒；锁定相机（路缘第一人称或三脚架）。
2. `AnimationPlayer` 或脚本：0–10 s 太阳能量；10–20 s 夜灯 + 锻炉门溢出光。

## 完成条件

- 工坊第一人称读起来像参考 blocking（铁砧够得着，锻炉在前方）
- 街道无需操作白天→夜晚，相机固定
- 风格化材质可接受；不要求 photoreal
