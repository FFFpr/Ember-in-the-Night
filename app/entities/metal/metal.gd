# res://app/entities/metal/metal.gd
class_name Metal
extends BaseEntity

const METAL_SIZE := Vector2(80, 15)   # 扁平的矩形：宽80，只有15高

func _ready() -> void:
	super._ready()
	var shape_node: CollisionShape2D = $CollisionShape2D
	if shape_node.shape == null:
		var rect := RectangleShape2D.new()
		rect.size = METAL_SIZE
		shape_node.shape = rect
