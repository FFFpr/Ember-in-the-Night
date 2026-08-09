extends Node2D
## Locked close-iso workshop — pack sprites/tiles only (no IsoDraw / prop polygons).
## Allowed non-pack: sky wash + soft glow/light cookies.

const GROUND := "res://art_style_demo/shared/imported/rubberduck_iso_ground/PNG/"
const FEUDAL := "res://art_style_demo/shared/imported/feudalwars_iso_medieval/"
const PROPS := "res://art_style_demo/shared/imported/rubberduck_iso_medieval_props/PNG/"

const TILE_W := 128.0
const TILE_H := 64.0


func _ready() -> void:
	_build_sky_wash()
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


func _build_sky_wash() -> void:
	# Tiny allowed exception: flat sky wash behind pack scenery.
	var sky := Polygon2D.new()
	sky.name = "SkyWash"
	sky.polygon = PackedVector2Array([
		Vector2(-1400, -900), Vector2(1400, -900), Vector2(1400, 200), Vector2(-1400, 200),
	])
	sky.color = Color("1a2433")
	sky.z_index = -50
	add_child(sky)


func _build_floor() -> void:
	var world := Node2D.new()
	world.name = "World"
	add_child(world)

	var dirt: Array[Texture2D] = [
		_tex(GROUND + "dirt_dark_0_0.png"),
		_tex(GROUND + "dirt_dark_1_0.png"),
		_tex(GROUND + "dirt_dark_2_0.png"),
		_tex(GROUND + "dirt_0_0.png"),
		_tex(GROUND + "dirt_1_0.png"),
		_tex(GROUND + "dirt_2_0.png"),
		_tex(GROUND + "forest_ground_0_0.png"),
	]
	var stone: Array[Texture2D] = [
		_tex(GROUND + "stone_path_0_0.png"),
		_tex(GROUND + "stone_path_1_0.png"),
		_tex(GROUND + "stone_path_2_0.png"),
		_tex(GROUND + "stone_path_3_0.png"),
		_tex(GROUND + "stone_path_0_1.png"),
		_tex(GROUND + "stone_path_1_1.png"),
	]
	# Wide pack-tile plane so the viewport is mostly ground sprites, not void.
	for gx in range(-2, 14):
		for gy in range(-2, 14):
			var on_pad := gx >= 3 and gx <= 8 and gy >= 3 and gy <= 8
			var tex: Texture2D
			if on_pad:
				tex = stone[(gx * 2 + gy) % stone.size()]
			else:
				tex = dirt[(gx * 3 + gy * 5) % dirt.size()]
			_sprite(world, tex, _grid(float(gx), float(gy)), 0, 1.0)


func _build_smithy_cluster() -> void:
	var props := Node2D.new()
	props.name = "Props"
	add_child(props)

	# Hero pack sprite: forge + anvil + tools/armor bay.
	var smith := _sprite(props, _tex(FEUDAL + "blacksmith.png"), _grid(5.0, 4.0) + Vector2(0, -24), 10, 2.05)
	smith.name = "Blacksmith"

	# Soft glow cookie only (allowed exception).
	var glow := Sprite2D.new()
	glow.name = "ForgeGlow"
	glow.centered = true
	glow.position = _grid(6.2, 4.3) + Vector2(110, 28)
	glow.z_index = 12
	glow.modulate = Color(1.0, 0.55, 0.18, 0.65)
	glow.scale = Vector2(2.8, 1.9)
	glow.texture = _soft_glow_texture()
	props.add_child(glow)

	var light := PointLight2D.new()
	light.name = "ForgeLight"
	light.color = Color(1.0, 0.55, 0.22, 1.0)
	light.energy = 1.35
	light.texture_scale = 3.0
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
	# Larger readable pack props only (barrels / crates / pottery).
	var placements: Array = [
		["medieval_props_128x64_no_shadow_18.png", Vector2(2.6, 5.6), 1.45],
		["medieval_props_128x64_no_shadow_19.png", Vector2(3.2, 6.0), 1.4],
		["medieval_props_128x64_no_shadow_36.png", Vector2(7.6, 5.5), 1.4],
		["medieval_props_128x64_no_shadow_38.png", Vector2(8.2, 5.9), 1.35],
		["medieval_props_128x64_no_shadow_22.png", Vector2(6.8, 6.3), 1.3],
		["medieval_props_128x64_no_shadow_14.png", Vector2(2.0, 4.6), 1.25],
		["medieval_props_128x64_no_shadow_12.png", Vector2(7.2, 6.6), 1.25],
	]
	for i in placements.size():
		var item: Array = placements[i]
		_sprite(props, _tex(PROPS + String(item[0])), _grid(item[1].x, item[1].y), 14 + (i % 3), float(item[2]))


func _lock_camera() -> void:
	var cam := Camera2D.new()
	cam.name = "Camera2D"
	# Tight lock on forge–anvil bay so pack art dominates the viewport.
	cam.position = _grid(5.2, 4.4) + Vector2(55, 30)
	cam.zoom = Vector2(1.35, 1.35)
	cam.enabled = true
	add_child(cam)
