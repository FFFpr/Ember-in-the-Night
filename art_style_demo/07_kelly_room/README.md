# 07 — Kelly 房间

独立小场景：用 Kelly 公式模拟一轮一轮的投资。用 F6 打开 `kelly_room.tscn`。不要改 `project.godot` 的主场景。

构图对照：[`../references/kelly_room/`](../references/kelly_room/)。像素道具只从 `Aseprite-User/export/props/kelly_room/` 读取；缺图时用锻夜色灰盒。

## 操作

- 拖拽松手：框选玻璃前的金币；金币聚到鼠标旁，并显示数量。
- 空地点击：放下。
- 对准投币箱（放大 + 黑描边）点击：投入。不能取回。
- 点摇杆：本轮投资。成功则出币口连本带息弹出；失败无回报。
- 点贴纸 / 数字：揭开或贴回建议投入枚数。一轮内该数字不变。

只有 1 枚金币时，成功率 100%、回报倍率 1。亏光后，下一轮出币口补 1 枚。

## 测试

```bash
godot --headless --path . --script res://art_style_demo/07_kelly_room/tests/test_kelly_round.gd
```
