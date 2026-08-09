extends Node2D
## Iso shop-front street: Feudal Wars buildings + rubberduck ground/props (CC0).
## Day 0–10s / night 10–20s via World.modulate + soft Emissives.

const GROUND := "res://art_style_demo/shared/imported/rubberduck_iso_ground/PNG/"
const FEUDAL := "res://art_style_demo/shared/imported/feudalwars_iso_medieval/"
const PROPS := "res://art_style_demo/shared/imported/rubberduck_iso_medieval_props/PNG/"

const TILE_W := 128.0
const TILE_H := 64.0


func _ready() -> void:
	_build_street()
	_lock_camera()


func _grid(gx: float, gy: float) -> Vector2:
	return Vector2((gx - gy) * TILE_W * 0.5, (gx + gy) * TILE_H * 0.5)


func _tex(path: String) -> Texture2D:
	return load(path) as Texture2D


func _sprite(parent: Node, tex: Texture2D, pos: Vector2, z: int, scale := 1.0) -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = tex
	s.centered = true
	s.position = pos
	s.z_index = z
	s.scale = Vector2(scale, scale)
	parent.add_child(s)
	return s


func _soft_glow_texture() -> GradientTexture2D:
	var grad := GradientTexture2D.new()
	grad.width = 128
	grad.height = 128
	grad.fill = GradientTexture2D.FILL_RADIAL
	grad.fill_from = Vector2(0.5, 0.5)
	grad.fill_to = Vector2(0.5, 0.0)
	var g := Gradient.new()
	g.colors = PackedColorArray([Color(1, 1, 1, 1), Color(1, 1, 1, 0)])
	g.offsets = PackedFloat32Array([0.0, 1.0])
	grad.gradient = g
	return grad


func _build_street() -> void:
	var sky := Polygon2D.new()
	sky.name = "Sky"
	sky.polygon = PackedVector2Array([
		Vector2(-1100, -620), Vector2(1100, -620), Vector2(1100, 280), Vector2(-1100, 280),
	])
	sky.color = Color("8fa3b8")
	sky.z_index = -40
	add_child(sky)

	var world := Node2D.new()
	world.name = "World"
	add_child(world)

	_build_ground(world)
	_build_buildings(world)
	_build_street_props(world)

	var emissives := Node2D.new()
	emissives.name = "Emissives"
	emissives.visible = false
	add_child(emissives)
	_build_night_emissives(emissives)

	var cycle := Node.new()
	cycle.name = "DayNight"
	cycle.set_script(load("res://art_style_demo/03_isometric/street/day_night.gd"))
	add_child(cycle)


func _build_ground(world: Node2D) -> void:
	var dirt: Array[Texture2D] = [
		_tex(GROUND + "dirt_0_0.png"),
		_tex(GROUND + "dirt_1_0.png"),
		_tex(GROUND + "dirt_2_0.png"),
		_tex(GROUND + "grass_medium_0_0.png"),
	]
	var road: Array[Texture2D] = [
		_tex(GROUND + "stone_path_0_0.png"),
		_tex(GROUND + "stone_path_1_0.png"),
		_tex(GROUND + "stone_path_2_0.png"),
		_tex(GROUND + "stone_path_3_0.png"),
	]
	for gx in range(-1, 12):
		for gy in range(2, 10):
			var on_road := gy >= 5 and gy <= 7
			var tex: Texture2D
			if on_road:
				tex = road[(gx + gy) % road.size()]
			else:
				tex = dirt[(gx * 3 + gy) % dirt.size()]
			_sprite(world, tex, _grid(float(gx), float(gy)), 0, 1.0)


func _build_buildings(world: Node2D) -> void:
	_sprite(world, _tex(FEUDAL + "house1c.png"), _grid(0.4, 2.6) + Vector2(0, -18), 5, 1.2).name = "NeighborC"
	_sprite(world, _tex(FEUDAL + "blacksmith.png"), _grid(3.2, 3.0) + Vector2(0, -28), 8, 1.4).name = "Smithy"
	_sprite(world, _tex(FEUDAL + "house1.png"), _grid(7.4, 2.5) + Vector2(0, -16), 6, 1.25).name = "NeighborA"
	_sprite(world, _tex(FEUDAL + "house1b.png"), _grid(9.8, 3.3) + Vector2(0, -8), 5, 1.2).name = "NeighborB"


func _build_street_props(world: Node2D) -> void:
	_sprite(world, _tex(PROPS + "medieval_props_128x64_no_shadow_18.png"), _grid(4.8, 5.5), 12, 1.0).name = "Barrels"
	_sprite(world, _tex(PROPS + "medieval_props_128x64_no_shadow_19.png"), _grid(5.4, 5.9), 12, 0.95)
	_sprite(world, _tex(PROPS + "medieval_props_128x64_no_shadow_12.png"), _grid(6.0, 5.3), 12, 1.0).name = "Crate"
	_sprite(world, _tex(PROPS + "medieval_props_128x64_no_shadow_13.png"), _grid(6.6, 5.7), 12, 0.9)
	_sprite(world, _tex(PROPS + "medieval_props_128x64_no_shadow_22.png"), _grid(4.2, 6.1), 12, 0.85)
	_sprite(world, _tex(PROPS + "medieval_props_128x64_no_shadow_04.png"), _grid(5.0, 6.4), 12, 0.8)


func _build_night_emissives(emissives: Node2D) -> void:
	var glow_tex := _soft_glow_texture()

	var window_a := Sprite2D.new()
	window_a.name = "GlowWindowA"
	window_a.texture = glow_tex
	window_a.centered = true
	window_a.modulate = Color(1.0, 0.75, 0.35, 0.9)
	window_a.scale = Vector2(0.55, 0.7)
	window_a.position = _grid(2.7, 2.5) + Vector2(-28, -98)
	window_a.z_index = 40
	emissives.add_child(window_a)

	var window_b := window_a.duplicate() as Sprite2D
	window_b.name = "GlowWindowB"
	window_b.position = _grid(3.0, 2.4) + Vector2(8, -102)
	emissives.add_child(window_b)

	var forge := Sprite2D.new()
	forge.name = "GlowForge"
	forge.texture = glow_tex
	forge.centered = true
	forge.modulate = Color(1.0, 0.5, 0.15, 0.95)
	forge.scale = Vector2(1.8, 1.3)
	forge.position = _grid(4.4, 3.5) + Vector2(100, 20)
	forge.z_index = 41
	emissives.add_child(forge)

	var light := PointLight2D.new()
	light.name = "NightForgeLight"
	light.color = Color(1.0, 0.55, 0.22, 1.0)
	light.energy = 1.4
	light.texture_scale = 3.0
	light.position = forge.position
	light.texture = glow_tex
	emissives.add_child(light)


func _lock_camera() -> void:
	var cam := Camera2D.new()
	cam.name = "Camera2D"
	cam.position = _grid(5.2, 4.2) + Vector2(10, -35)
	cam.zoom = Vector2(0.92, 0.92)
	cam.enabled = true
	add_child(cam)
