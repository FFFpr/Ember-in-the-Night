extends Node2D
## 02 street: same framing as 01; day/night toggles light nodes (not modulate-only).

const DAY_S := 10.0
const NIGHT_S := 10.0
const FADE_S := 0.45

var _sky: Polygon2D
var _night_glows: Node2D
var _modulate: CanvasModulate
var _day_sun: PointLight2D
var _forge_light: PointLight2D
var _door_light: PointLight2D
var _lantern_light: PointLight2D
var _window_lights: Array[PointLight2D] = []


func _ready() -> void:
	var built := StreetLayout.build(self)
	_sky = built["sky"]
	_night_glows = built["night_glows"]

	_modulate = CanvasModulate.new()
	_modulate.name = "CanvasModulate"
	add_child(_modulate)

	_day_sun = DemoLights.make_point_light("DaySun", Vector2(640, 80), Color(0.85, 0.9, 1.0, 1.0), 0.9, 8.0)
	add_child(_day_sun)

	_forge_light = DemoLights.make_point_light("ForgeSpillLight", Vector2(505, 340), ArtPalette.WARM_EMBER, 0.0, 3.6)
	add_child(_forge_light)

	_door_light = DemoLights.make_point_light("DoorLight", Vector2(235, 360), Color(1.0, 0.55, 0.22, 1.0), 0.0, 2.4)
	add_child(_door_light)

	_lantern_light = DemoLights.make_point_light("LanternLight", Vector2(700, 300), Color(1.0, 0.72, 0.35, 1.0), 0.0, 2.0)
	add_child(_lantern_light)

	for pos in [Vector2(125, 120), Vector2(385, 120), Vector2(1058, 215)]:
		var wl := DemoLights.make_point_light("WindowLight_%d" % _window_lights.size(), pos, Color(1.0, 0.6, 0.25, 1.0), 0.0, 1.6)
		_window_lights.append(wl)
		add_child(wl)

	var cam := Camera2D.new()
	cam.name = "Camera2D"
	cam.position = Vector2(640, 360)
	add_child(cam)
	cam.make_current()

	_apply_day_instant()
	_run_cycle()


func _run_cycle() -> void:
	while is_inside_tree():
		await _set_day()
		await get_tree().create_timer(DAY_S).timeout
		await _set_night()
		await get_tree().create_timer(NIGHT_S).timeout


func _apply_day_instant() -> void:
	_sky.color = ArtPalette.COOL_SKY_DAY
	_modulate.color = Color(1, 1, 1, 1)
	_night_glows.visible = false
	_day_sun.energy = 0.9
	_forge_light.energy = 0.35
	_door_light.energy = 0.0
	_lantern_light.energy = 0.0
	for wl in _window_lights:
		wl.energy = 0.0


func _set_day() -> void:
	_night_glows.visible = false
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(_sky, "color", ArtPalette.COOL_SKY_DAY, FADE_S)
	tween.tween_property(_modulate, "color", Color(1.0, 1.0, 1.0, 1.0), FADE_S)
	tween.tween_property(_day_sun, "energy", 0.9, FADE_S)
	tween.tween_property(_forge_light, "energy", 0.35, FADE_S)
	tween.tween_property(_door_light, "energy", 0.0, FADE_S)
	tween.tween_property(_lantern_light, "energy", 0.0, FADE_S)
	for wl in _window_lights:
		tween.tween_property(wl, "energy", 0.0, FADE_S)
	await tween.finished


func _set_night() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(_sky, "color", ArtPalette.COOL_SKY_NIGHT, FADE_S)
	tween.tween_property(_modulate, "color", Color(0.28, 0.30, 0.42, 1.0), FADE_S)
	tween.tween_property(_day_sun, "energy", 0.0, FADE_S)
	tween.tween_property(_forge_light, "energy", 1.7, FADE_S)
	tween.tween_property(_door_light, "energy", 0.9, FADE_S)
	tween.tween_property(_lantern_light, "energy", 1.1, FADE_S)
	for wl in _window_lights:
		tween.tween_property(wl, "energy", 0.75, FADE_S)
	await tween.finished
	_night_glows.visible = true
