extends Node2D
## 01 street: fixed shop-front camera; day 0–10s, night 10–20s, then loop.

const DAY_S := 10.0
const NIGHT_S := 10.0
const FADE_S := 0.45

var _sky: Polygon2D
var _night_glows: Node2D
var _modulate: CanvasModulate


func _ready() -> void:
	var built := StreetLayout.build(self)
	_sky = built["sky"]
	_night_glows = built["night_glows"]

	_modulate = CanvasModulate.new()
	_modulate.name = "CanvasModulate"
	_modulate.color = Color(1, 1, 1, 1)
	add_child(_modulate)

	var cam := Camera2D.new()
	cam.name = "Camera2D"
	cam.position = Vector2(640, 360)
	add_child(cam)
	cam.make_current()

	_run_cycle()


func _run_cycle() -> void:
	while is_inside_tree():
		await _set_day()
		await get_tree().create_timer(DAY_S).timeout
		await _set_night()
		await get_tree().create_timer(NIGHT_S).timeout


func _set_day() -> void:
	_night_glows.visible = false
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(_sky, "color", ArtPalette.COOL_SKY_DAY, FADE_S)
	tween.tween_property(_modulate, "color", Color(1.0, 1.0, 1.0, 1.0), FADE_S)
	await tween.finished


func _set_night() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(_sky, "color", ArtPalette.COOL_SKY_NIGHT, FADE_S)
	tween.tween_property(_modulate, "color", Color(0.35, 0.38, 0.55, 1.0), FADE_S)
	await tween.finished
	_night_glows.visible = true
