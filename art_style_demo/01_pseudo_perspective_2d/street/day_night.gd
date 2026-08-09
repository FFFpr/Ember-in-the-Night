extends Node2D
## 01 street: fixed shop-front camera; day 0–10s, night 10–20s, then loop.

const CYCLE_S := 20.0
const DAY_END_S := 10.0
const FADE_S := 0.45

var _sky: Polygon2D
var _night_glows: Node2D
var _modulate: CanvasModulate
var _sun: CanvasItem
var _start_msec := 0
var _is_night := false


func _ready() -> void:
	var built := StreetLayout.build(self)
	_sky = built["sky"]
	_night_glows = built["night_glows"]
	_sun = get_node_or_null("LayerFar/Sun") as CanvasItem

	_modulate = CanvasModulate.new()
	_modulate.name = "CanvasModulate"
	_modulate.color = Color(1, 1, 1, 1)
	add_child(_modulate)

	var cam := Camera2D.new()
	cam.name = "Camera2D"
	cam.position = Vector2(640, 360)
	add_child(cam)
	cam.make_current()

	_start_msec = Time.get_ticks_msec()
	_apply_day_instant()


func _process(_delta: float) -> void:
	var t := fmod(float(Time.get_ticks_msec() - _start_msec) / 1000.0, CYCLE_S)
	var want_night := t >= DAY_END_S
	if want_night == _is_night:
		return
	_is_night = want_night
	if _is_night:
		_tween_to_night()
	else:
		_tween_to_day()


func _apply_day_instant() -> void:
	_is_night = false
	_sky.color = ArtPalette.COOL_SKY_DAY
	_modulate.color = Color(1, 1, 1, 1)
	_night_glows.visible = false
	if _sun:
		_sun.visible = true


func _tween_to_day() -> void:
	_night_glows.visible = false
	if _sun:
		_sun.visible = true
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(_sky, "color", ArtPalette.COOL_SKY_DAY, FADE_S)
	tween.tween_property(_modulate, "color", Color(1.0, 1.0, 1.0, 1.0), FADE_S)


func _tween_to_night() -> void:
	if _sun:
		_sun.visible = false
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(_sky, "color", ArtPalette.COOL_SKY_NIGHT, FADE_S)
	tween.tween_property(_modulate, "color", Color(0.35, 0.38, 0.55, 1.0), FADE_S)
	tween.chain().tween_callback(func() -> void: _night_glows.visible = true)
