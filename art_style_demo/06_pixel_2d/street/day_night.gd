extends Node
## Day 0–10s / night 10–20s; same camera. Autostarts via start_cycle().

const DAY_LEN := 10.0
const NIGHT_LEN := 10.0
const CYCLE_LEN := DAY_LEN + NIGHT_LEN
const FADE := 0.45

const WIN_DAY := "res://art_style_demo/shared/imported/lpc_base_assets/slices/window_house_a.png"
const WIN_DAY_B := "res://art_style_demo/shared/imported/lpc_base_assets/slices/window_house_b.png"
const WIN_NIGHT := "res://art_style_demo/shared/imported/lpc_base_assets/slices/window_house_night.png"

var _root: Node2D
var _time: float = 0.0
var _running: bool = false

var _sky: Polygon2D
var _mountains: Sprite2D
var _forge_glow: Polygon2D
var _window_glow: Polygon2D
var _door_glow: Polygon2D
var _lamp: Polygon2D
var _shop_light: PointLight2D
var _window_a: Sprite2D
var _window_b: Sprite2D
var _neighbor_window: Sprite2D

var _day_sky := Color("7ec8e8")
var _night_sky := Color("0d1830")
var _day_mountain := Color(0.75, 0.85, 0.95, 0.7)
var _night_mountain := Color(0.2, 0.28, 0.45, 0.9)


func start_cycle(street_root: Node2D) -> void:
	_root = street_root
	_sky = street_root.get_node_or_null("Sky") as Polygon2D
	_mountains = street_root.get_node_or_null("Mountains") as Sprite2D
	_forge_glow = street_root.get_node_or_null("ForgeGlow") as Polygon2D
	_window_glow = street_root.get_node_or_null("WindowGlow") as Polygon2D
	_door_glow = street_root.get_node_or_null("DoorGlow") as Polygon2D
	_lamp = street_root.get_node_or_null("Lamp") as Polygon2D
	_shop_light = street_root.get_node_or_null("ShopLight") as PointLight2D
	_window_a = street_root.get_node_or_null("WindowA") as Sprite2D
	_window_b = street_root.get_node_or_null("WindowB") as Sprite2D
	_neighbor_window = street_root.get_node_or_null("NeighborWindow") as Sprite2D
	_running = true
	_apply(0.0)


func _process(delta: float) -> void:
	if not _running:
		return
	_time = fmod(_time + delta, CYCLE_LEN)
	_apply(_time)


func _apply(t: float) -> void:
	var night_w: float
	if t < DAY_LEN - FADE:
		night_w = 0.0
	elif t < DAY_LEN:
		night_w = (t - (DAY_LEN - FADE)) / FADE
	elif t < CYCLE_LEN - FADE:
		night_w = 1.0
	else:
		night_w = 1.0 - (t - (CYCLE_LEN - FADE)) / FADE

	if _sky:
		_sky.color = _day_sky.lerp(_night_sky, night_w)
	if _mountains:
		_mountains.modulate = _day_mountain.lerp(_night_mountain, night_w)
	if _forge_glow:
		_forge_glow.color = Color("ff7a30", lerpf(0.35, 0.95, night_w))
	if _window_glow:
		_window_glow.color = Color("ffcc66", lerpf(0.12, 0.9, night_w))
	if _door_glow:
		_door_glow.color = Color("ff9944", lerpf(0.1, 0.7, night_w))
	if _lamp:
		_lamp.color = Color("ffcc66", lerpf(0.2, 0.95, night_w))
	if _shop_light:
		_shop_light.energy = lerpf(0.25, 1.45, night_w)

	var night := night_w > 0.5
	_set_win(_window_a, WIN_NIGHT if night else WIN_DAY)
	_set_win(_window_b, WIN_NIGHT if night else WIN_DAY_B)
	_set_win(_neighbor_window, WIN_NIGHT if night else WIN_DAY)

	if _root:
		_root.modulate = Color.WHITE.lerp(Color(0.78, 0.85, 1.05), night_w * 0.35)


func _set_win(node: Sprite2D, path: String) -> void:
	if node == null:
		return
	var tex := load(path) as Texture2D
	if tex:
		node.texture = tex
