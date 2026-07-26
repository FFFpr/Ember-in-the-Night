# res://resources/materials/material.gd
class_name BaseMaterial
extends Resource

@export var deformability: float = 0.5   # 形变能力，影响回弹力 & 未来的形变模拟
@export var friction: float = 0.5
@export var bounciness: float = 0.3
