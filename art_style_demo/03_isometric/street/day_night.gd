extends Node
## Autostart day (0–10s) / night (10–20s) cycle for the iso street.

const DAY_COLOR := Color(1.0, 0.98, 0.94, 1.0)
const NIGHT_COLOR := Color(0.38, 0.46, 0.72, 1.0)
const DAY_SKY := Color("9eb0c2")
const NIGHT_SKY := Color("1a2436")
const WINDOW_DAY := Color("7a8aa0")
const WINDOW_NIGHT := Color("ffb14a")
const FORGE_DAY := Color("ff6a1f")
const FORGE_NIGHT := Color("ffc56a")

var _elapsed := 0.0
var _is_night := false


func _ready() -> void:
	set_process(true)
	_apply_day()


func _process(delta: float) -> void:
	_elapsed += delta
	if _elapsed >= 20.0:
		_elapsed = fmod(_elapsed, 20.0)
	var want_night := _elapsed >= 10.0
	if want_night != _is_night:
		_is_night = want_night
		if _is_night:
			_apply_night()
		else:
			_apply_day()


func _apply_day() -> void:
	_set_modulate(DAY_COLOR)
	_set_sky(DAY_SKY)
	_set_named_poly_color("WindowA", WINDOW_DAY)
	_set_named_poly_color("WindowB", WINDOW_DAY)
	_set_named_poly_color("ForgeGlow", FORGE_DAY)


func _apply_night() -> void:
	_set_modulate(NIGHT_COLOR)
	_set_sky(NIGHT_SKY)
	_set_named_poly_color("WindowA", WINDOW_NIGHT)
	_set_named_poly_color("WindowB", WINDOW_NIGHT)
	_set_named_poly_color("ForgeGlow", FORGE_NIGHT)


func _set_modulate(color: Color) -> void:
	var m := get_parent().get_node_or_null("CanvasModulate") as CanvasModulate
	if m:
		m.color = color


func _set_sky(color: Color) -> void:
	var sky := get_parent().get_node_or_null("World/Sky") as Polygon2D
	if sky:
		sky.color = color


func _set_named_poly_color(node_name: String, color: Color) -> void:
	var node := get_parent().find_child(node_name, true, false)
	if node == null:
		return
	# Iso boxes are Node2D roots with Polygon2D children; flat diamonds are Polygon2D.
	if node is Polygon2D:
		(node as Polygon2D).color = color
		return
	for child in node.get_children():
		if child is Polygon2D:
			(child as Polygon2D).color = color
