extends Node2D
## Locked close-iso workshop: Feudal Wars blacksmith + rubberduck CC0 ground/props.

const GROUND := "res://art_style_demo/shared/imported/rubberduck_iso_ground/PNG/"
const FEUDAL := "res://art_style_demo/shared/imported/feudalwars_iso_medieval/"
const PROPS := "res://art_style_demo/shared/imported/rubberduck_iso_medieval_props/PNG/"

const TILE_W := 128.0
const TILE_H := 64.0


func _ready() -> void:
	_build_ambiance()
	_build_floor()
	_build_smithy_cluster()
	_build_extra_props()
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


func _build_ambiance() -> void:
	var bg := Polygon2D.new()
	bg.name = "Backdrop"
	bg.polygon = PackedVector2Array([
		Vector2(-1000, -700), Vector2(1000, -700), Vector2(1000, 800), Vector2(-1000, 800),
	])
	bg.color = Color("141c28")
	bg.z_index = -40
	add_child(bg)


func _build_floor() -> void:
	var world := Node2D.new()
	world.name = "World"
	add_child(world)

	var tiles: Array[Texture2D] = [
		_tex(GROUND + "dirt_dark_0_0.png"),
		_tex(GROUND + "dirt_dark_1_0.png"),
		_tex(GROUND + "dirt_0_0.png"),
		_tex(GROUND + "stone_path_0_0.png"),
		_tex(GROUND + "stone_path_1_0.png"),
		_tex(GROUND + "stone_path_2_0.png"),
	]
	for gx in range(0, 10):
		for gy in range(0, 10):
			var tex: Texture2D
			if gx >= 3 and gx <= 6 and gy >= 3 and gy <= 6:
				tex = tiles[3 + ((gx + gy) % 3)]
			else:
				tex = tiles[(gx + gy) % 3]
			_sprite(world, tex, _grid(float(gx), float(gy)), 0, 1.0)


func _build_smithy_cluster() -> void:
	var props := Node2D.new()
	props.name = "Props"
	add_child(props)

	var smith := _sprite(props, _tex(FEUDAL + "blacksmith.png"), _grid(4.5, 3.2) + Vector2(8, -18), 10, 1.7)
	smith.name = "Blacksmith"

	# Soft warm forge spill (additive-looking translucent diamond).
	var glow := Sprite2D.new()
	glow.name = "ForgeGlow"
	glow.centered = true
	glow.position = _grid(5.8, 3.5) + Vector2(85, 18)
	glow.z_index = 12
	glow.modulate = Color(1.0, 0.55, 0.18, 0.7)
	glow.scale = Vector2(2.4, 1.6)
	glow.texture = _soft_glow_texture()
	props.add_child(glow)

	var light := PointLight2D.new()
	light.name = "ForgeLight"
	light.color = Color(1.0, 0.55, 0.22, 1.0)
	light.energy = 1.25
	light.texture_scale = 2.6
	light.position = glow.position
	light.texture = _soft_glow_texture()
	props.add_child(light)


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


func _build_extra_props() -> void:
	var props := get_node("Props")
	_sprite(props, _tex(PROPS + "medieval_props_128x64_no_shadow_18.png"), _grid(2.2, 4.8), 14, 1.05).name = "Barrels"
	_sprite(props, _tex(PROPS + "medieval_props_128x64_no_shadow_19.png"), _grid(2.8, 5.2), 14, 1.0)
	_sprite(props, _tex(PROPS + "medieval_props_128x64_no_shadow_12.png"), _grid(6.6, 4.9), 14, 1.05).name = "Crates"
	_sprite(props, _tex(PROPS + "medieval_props_128x64_no_shadow_13.png"), _grid(7.1, 5.3), 14, 0.95)
	_sprite(props, _tex(PROPS + "medieval_props_128x64_no_shadow_04.png"), _grid(1.6, 3.8), 12, 0.95)
	_sprite(props, _tex(PROPS + "medieval_props_128x64_no_shadow_22.png"), _grid(6.2, 5.6), 14, 0.9)


func _lock_camera() -> void:
	var cam := Camera2D.new()
	cam.name = "Camera2D"
	cam.position = _grid(4.8, 3.6) + Vector2(50, 20)
	cam.zoom = Vector2(1.2, 1.2)
	cam.enabled = true
	add_child(cam)
