extends Node
## Autostart day (0–10s) / night (10–20s) via AnimationPlayer (loops).
## Darkens `World` + `Sky`; shows `Emissives` overlays at night so windows stay warm.

const DAY_WORLD := Color(1.0, 0.99, 0.96, 1.0)
const NIGHT_WORLD := Color(0.55, 0.60, 0.82, 1.0)
const DAY_SKY := Color("8fa3b8")
const NIGHT_SKY := Color("121c2e")


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_apply_day()
	var player := AnimationPlayer.new()
	player.name = "CyclePlayer"
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(player)

	var anim := Animation.new()
	anim.length = 20.0
	anim.loop_mode = Animation.LOOP_LINEAR

	# Method tracks fire day/night at the boundaries.
	var track := anim.add_track(Animation.TYPE_METHOD)
	anim.track_set_path(track, NodePath("."))
	anim.track_insert_key(track, 0.0, {"method": "_apply_day", "args": []})
	anim.track_insert_key(track, 10.0, {"method": "_apply_night", "args": []})

	var lib := AnimationLibrary.new()
	lib.add_animation("day_night", anim)
	player.add_animation_library("demo", lib)
	player.play("demo/day_night")


func _apply_day() -> void:
	_set_world_modulate(DAY_WORLD)
	_set_sky(DAY_SKY)
	_set_emissives_visible(false)


func _apply_night() -> void:
	_set_world_modulate(NIGHT_WORLD)
	_set_sky(NIGHT_SKY)
	_set_emissives_visible(true)


func _set_world_modulate(color: Color) -> void:
	var world := get_parent().get_node_or_null("World") as Node2D
	if world:
		world.modulate = color


func _set_sky(color: Color) -> void:
	var sky := get_parent().get_node_or_null("Sky") as Polygon2D
	if sky:
		sky.color = color


func _set_emissives_visible(visible: bool) -> void:
	var emissives := get_parent().get_node_or_null("Emissives") as Node2D
	if emissives:
		emissives.visible = visible
