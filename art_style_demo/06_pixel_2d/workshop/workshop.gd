extends Node2D
## 06 pixel workshop — locked FP bench framing; forge + anvil dominant.

const C := preload("res://art_style_demo/06_pixel_2d/pixel_demo_common.gd")

var _forge: Sprite2D
var _embers: Node2D
var _forge_light: PointLight2D
var _t: float = 0.0


func _ready() -> void:
	C.apply_pixel_filter(self)
	C.make_locked_camera(self)
	_build_room()
	_build_props()
	_build_forge_light()


func _process(delta: float) -> void:
	_t += delta
	if _forge:
		var pulse := 0.92 + 0.08 * sin(_t * 7.0) + 0.04 * sin(_t * 13.0)
		_forge.modulate = Color(1.0, pulse, pulse * 0.85, 1.0)
	if _forge_light:
		_forge_light.energy = 1.05 + 0.2 * sin(_t * 9.0)
	if _embers:
		for child in _embers.get_children():
			var p := child as Node2D
			if p == null:
				continue
			p.position.y -= delta * (8.0 + float(p.get_meta("spd", 10.0)))
			var poly := p as Polygon2D
			if poly:
				poly.color.a -= delta * 0.7
				if poly.color.a <= 0.0 or p.position.y < 40.0:
					p.position = Vector2(148.0 + randf() * 24.0, 96.0 + randf() * 8.0)
					poly.color.a = 0.7 + randf() * 0.3


func _build_room() -> void:
	C.solid(self, Rect2(0, 0, 320, 180), Color("1a2230"), -20)
	# Back wall — stone brick placeholders (composition plate)
	C.tiled_rect(self, C.PATH_PLACE + "wall_stone.png", Vector2(0, 16), Vector2i(320, 100), -10)
	# Cool side washes
	C.solid(self, Rect2(0, 16, 40, 100), Color(0.25, 0.35, 0.55, 0.4), -5)
	C.solid(self, Rect2(280, 16, 40, 100), Color(0.25, 0.35, 0.55, 0.4), -5)
	# Warm wash near forge center
	C.solid(self, Rect2(120, 40, 80, 70), Color(1.0, 0.45, 0.15, 0.12), -4)
	# Rafters
	C.solid(self, Rect2(0, 0, 320, 16), Color("2a1e14"), -8)
	for x in [36, 100, 164, 228, 292]:
		C.solid(self, Rect2(x, 0, 5, 26), Color("4a3424"), -6)
	C.tiled_rect(self, C.PATH_PLACE + "beam.png", Vector2(8, 12), Vector2i(304, 6), -7)
	# Floor
	C.tiled_rect(self, C.PATH_PLACE + "floor_cobble.png", Vector2(0, 116), Vector2i(320, 44), -12, Color("7a8088"))
	# Bench lip (FP foreground)
	C.solid(self, Rect2(0, 156, 320, 24), Color("2b241c"), 20)
	C.solid(self, Rect2(0, 154, 320, 3), Color("5a4a38"), 21)
	# Cold window
	C.sprite(self, C.PATH_PLACE + "window_day.png", Vector2(24, 48), 1)


func _build_props() -> void:
	for i in 4:
		var hs := C.sprite(self, C.PATH_BS_PROPS + "horseshoe.png", Vector2(214 + i * 16, 36), 2)
		hs.scale = Vector2(0.65, 0.65)

	var rack := C.sprite(self, C.PATH_BS_PROPS + "tool_rack_tall.png", Vector2(42, 86), 3)
	rack.scale = Vector2(0.8, 0.8)

	var quench := C.sprite(self, C.PATH_BS_PROPS + "quench_barrel.png", Vector2(62, 128), 4)
	quench.scale = Vector2(0.65, 0.65)

	var coal := C.sprite(self, C.PATH_BS_PROPS + "coal_pile_large.png", Vector2(248, 126), 3)
	coal.scale = Vector2(0.42, 0.42)

	var bellows := C.sprite(self, C.PATH_BS_PROPS + "bellows_a.png", Vector2(218, 116), 4)
	bellows.scale = Vector2(0.85, 0.85)

	var bench := C.sprite(self, C.PATH_BS_PROPS + "workbench_tools.png", Vector2(290, 118), 3)
	bench.scale = Vector2(0.65, 0.65)

	_forge = C.sprite(self, C.PATH_BS_PROPS + "forge_chimney_lit.png", Vector2(160, 76), 5)
	_forge.scale = Vector2(0.7, 0.7)

	var anvil := C.sprite(self, C.PATH_BS_PROPS + "anvil_block.png", Vector2(160, 146), 10)
	anvil.scale = Vector2(2.4, 2.4)

	C.solid(self, Rect2(146, 138, 28, 5), Color("ff6a2a"), 11)
	C.solid(self, Rect2(148, 139, 24, 3), Color("ffcc66"), 12)

	var hammer := C.sprite(self, C.PATH_BS_PROPS + "hammer_tool.png", Vector2(100, 168), 22)
	hammer.scale = Vector2(1.05, 1.05)
	hammer.rotation_degrees = -28
	var tongs := C.sprite(self, C.PATH_BS_PROPS + "tongs_tool.png", Vector2(224, 168), 22)
	tongs.scale = Vector2(1.05, 1.05)
	tongs.rotation_degrees = 22

	_embers = Node2D.new()
	_embers.name = "Embers"
	_embers.z_index = 6
	add_child(_embers)
	for i in 8:
		var ember := Polygon2D.new()
		ember.color = Color("ffaa44")
		ember.polygon = PackedVector2Array([Vector2(0, 0), Vector2(2, 0), Vector2(2, 2), Vector2(0, 2)])
		ember.position = Vector2(148 + randf() * 24, 90 + randf() * 10)
		ember.set_meta("spd", 6.0 + randf() * 10.0)
		_embers.add_child(ember)


func _build_forge_light() -> void:
	_forge_light = PointLight2D.new()
	_forge_light.name = "ForgeLight"
	_forge_light.position = Vector2(160, 92)
	_forge_light.color = Color("ff8a3a")
	_forge_light.energy = 1.15
	_forge_light.texture_scale = 1.8
	var img := Image.create(64, 64, false, Image.FORMAT_RGBA8)
	for y in 64:
		for x in 64:
			var d := Vector2(x - 32, y - 32).length() / 32.0
			var a := clampf(1.0 - d, 0.0, 1.0)
			a *= a
			img.set_pixel(x, y, Color(1, 1, 1, a))
	_forge_light.texture = ImageTexture.create_from_image(img)
	add_child(_forge_light)
