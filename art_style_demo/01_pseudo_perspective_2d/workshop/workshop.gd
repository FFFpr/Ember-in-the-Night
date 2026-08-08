extends Node2D
## 01 workshop: locked FP camera + placeholder plates. Optional idle sway.

@export var sway_px := 3.0
@export var sway_period_s := 5.0

var _cam: Camera2D
var _t := 0.0


func _ready() -> void:
	WorkshopLayout.build(self)
	_cam = Camera2D.new()
	_cam.name = "Camera2D"
	_cam.position = Vector2(640, 360)
	add_child(_cam)
	_cam.make_current()


func _process(delta: float) -> void:
	if _cam == null or sway_px <= 0.0:
		return
	_t += delta
	var phase := _t * TAU / sway_period_s
	_cam.position = Vector2(640.0 + sin(phase) * sway_px, 360.0 + cos(phase * 0.7) * (sway_px * 0.5))
