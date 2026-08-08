extends Node2D

## 01 workshop: pseudo-perspective 2D plates, locked FP camera, optional sway.

@onready var camera: Camera2D = $Camera2D

var _plates: Dictionary = {}
var _sway_t := 0.0


func _ready() -> void:
	_plates = ArtDemoPlates.build_workshop(self)
	camera.position = ArtDemoPalette.VIEW * 0.5
	camera.make_current()


func _process(delta: float) -> void:
	_sway_t += delta
	# Tiny idle sway (2–4 px) for presence; camera stays locked otherwise.
	camera.position = ArtDemoPalette.VIEW * 0.5 + Vector2(sin(_sway_t * 0.7) * 3.0, cos(_sway_t * 0.55) * 2.0)
