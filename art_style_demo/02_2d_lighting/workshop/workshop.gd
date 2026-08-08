extends Node2D
## 02 workshop: same plates as 01 + forge PointLight2D and spark/smoke particles.

@export var sway_px := 3.0
@export var sway_period_s := 5.0
@export var flicker_amount := 0.18

var _cam: Camera2D
var _forge_light: PointLight2D
var _t := 0.0


func _ready() -> void:
	WorkshopLayout.build(self)

	var ambient := CanvasModulate.new()
	ambient.name = "CanvasModulate"
	ambient.color = Color(0.42, 0.45, 0.55, 1.0)
	add_child(ambient)

	_forge_light = DemoLights.make_point_light(
		"ForgeLight",
		Vector2(970, 340),
		ArtPalette.WARM_EMBER,
		1.55,
		4.2,
	)
	add_child(_forge_light)

	var window_fill := DemoLights.make_point_light(
		"WindowFill",
		Vector2(155, 190),
		Color(0.45, 0.55, 0.85, 1.0),
		0.55,
		2.2,
	)
	add_child(window_fill)

	add_child(DemoLights.make_sparks("ForgeSparks", Vector2(970, 320)))
	add_child(DemoLights.make_smoke("ForgeSmoke", Vector2(955, 280)))

	_cam = Camera2D.new()
	_cam.name = "Camera2D"
	_cam.position = Vector2(640, 360)
	add_child(_cam)
	_cam.make_current()


func _process(delta: float) -> void:
	_t += delta
	if _cam != null and sway_px > 0.0:
		var phase := _t * TAU / sway_period_s
		_cam.position = Vector2(640.0 + sin(phase) * sway_px, 360.0 + cos(phase * 0.7) * (sway_px * 0.5))
	if _forge_light != null:
		_forge_light.energy = 1.45 + sin(_t * 9.0) * flicker_amount + sin(_t * 17.3) * (flicker_amount * 0.35)
