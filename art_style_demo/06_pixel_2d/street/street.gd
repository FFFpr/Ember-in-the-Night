extends Node2D
## 06 pixel street — fixed shop-front; day 0–10s / night 10–20s.
## Facade/road/props from shared/imported (LPC).

const C := preload("res://art_style_demo/06_pixel_2d/pixel_demo_common.gd")

@onready var _cycle: Node = $DayNight


func _ready() -> void:
	C.apply_pixel_filter(self)
	C.make_locked_camera(self)
	_build_sky()
	_build_street()
	_build_smithy()
	_build_props()
	if _cycle and _cycle.has_method("start_cycle"):
		_cycle.start_cycle(self)


func _build_sky() -> void:
	var sky := C.solid(self, Rect2(0, 0, 320, 90), Color("7ec8e8"), -30)
	sky.name = "Sky"
	C.solid(self, Rect2(20, 62, 90, 28), Color("5a7a5a"), -28)
	C.solid(self, Rect2(180, 55, 120, 35), Color("4f6f4f"), -28)
	var mountains := C.sprite(self, C.PATH_SLICES + "mountains.png", Vector2(160, 70), -25, true, 1)
	mountains.name = "Mountains"
	# mountains sheet is large; keep 1x and center — may overflow; clip via modulate size by region
	mountains.region_enabled = true
	mountains.region_rect = Rect2(0, 0, 320, 100)
	mountains.modulate = Color(0.75, 0.85, 0.95, 0.7)


func _build_street() -> void:
	# Neighbor mass — LPC grey brick
	C.tiled_rect(self, C.PATH_SLICES + "wall_grey_fill.png", Vector2(0, 48), Vector2i(96, 80), -8)
	C.tiled_rect(self, C.PATH_SLICES + "roof_slate.png", Vector2(0, 40), Vector2i(96, 16), -7)
	C.sprite(self, C.PATH_SLICES + "window_house_a.png", Vector2(28, 72), -6, true, 1).name = "NeighborWindow"
	C.sprite(self, C.PATH_SLICES + "door_wood.png", Vector2(64, 96), -6, true, 1)
	# Road — LPC dirt + cobble
	C.tiled_rect(self, C.PATH_SLICES + "dirt_fill.png", Vector2(0, 128), Vector2i(320, 52), -15)
	C.tiled_rect(self, C.PATH_SLICES + "floor_cobble.png", Vector2(0, 128), Vector2i(320, 52), -14, Color(1, 1, 1, 0.65))


func _build_smithy() -> void:
	# Smithy body — LPC red brick
	C.tiled_rect(self, C.PATH_SLICES + "wall_brick_fill.png", Vector2(140, 44), Vector2i(180, 84), -5)
	C.tiled_rect(self, C.PATH_SLICES + "wall_brick_top.png", Vector2(140, 44), Vector2i(180, 32), -4)
	C.tiled_rect(self, C.PATH_SLICES + "roof_slate.png", Vector2(132, 32), Vector2i(196, 16), -3)
	# Open forge bay
	C.solid(self, Rect2(168, 72, 56, 56), Color("1a1210"), 0)
	var forge_glow := C.solid(self, Rect2(172, 76, 48, 48), Color("ff7a30"), 1)
	forge_glow.name = "ForgeGlow"
	forge_glow.color.a = 0.55
	var forge := C.sprite(self, C.PATH_BS_PROPS + "forge_wall_lit.png", Vector2(196, 100), 2, true, 1)
	forge.region_enabled = true
	forge.region_rect = Rect2(32, 16, 64, 64)
	C.sprite(self, C.PATH_BS_PROPS + "anvil_block.png", Vector2(196, 124), 3, true, 2)

	C.sprite(self, C.PATH_SLICES + "door_wood.png", Vector2(252, 92), 2, true, 1)
	var win_a := C.sprite(self, C.PATH_SLICES + "window_house_a.png", Vector2(284, 72), 2, true, 1)
	win_a.name = "WindowA"
	var win_b := C.sprite(self, C.PATH_SLICES + "window_house_b.png", Vector2(308, 72), 2, true, 1)
	win_b.name = "WindowB"

	var window_glow := C.solid(self, Rect2(268, 60, 52, 36), Color("ffcc66"), 1)
	window_glow.name = "WindowGlow"
	window_glow.color.a = 0.2

	var door_glow := C.solid(self, Rect2(236, 90, 32, 38), Color("ff9944"), 1)
	door_glow.name = "DoorGlow"
	door_glow.color.a = 0.15

	# Hanging sign — LPC sword board + blacksmith hammer mark
	C.solid(self, Rect2(150, 48, 3, 28), Color("3a2a1c"), 4)
	C.sprite(self, C.PATH_SLICES + "sign_sword.png", Vector2(166, 58), 5, true, 1)
	C.sprite(self, C.PATH_BS_PROPS + "hammer_tool.png", Vector2(166, 58), 6, true, 1)


func _build_props() -> void:
	C.sprite(self, C.PATH_SLICES + "barrel_0.png", Vector2(118, 140), 8, true, 1)
	C.sprite(self, C.PATH_SLICES + "barrel_1.png", Vector2(138, 142), 8, true, 1)
	C.sprite(self, C.PATH_BS_PROPS + "workbench_b.png", Vector2(98, 142), 7, true, 1)
	C.sprite(self, C.PATH_BS_PROPS + "coal_pile_c.png", Vector2(270, 142), 7, true, 1)

	C.solid(self, Rect2(158, 70, 3, 16), Color("3a2a1c"), 9)
	var lamp := C.solid(self, Rect2(154, 68, 11, 8), Color("ffcc66"), 10)
	lamp.name = "Lamp"
	lamp.color.a = 0.35

	var light := PointLight2D.new()
	light.name = "ShopLight"
	light.position = Vector2(196, 98)
	light.color = Color("ff8a3a")
	light.energy = 0.35
	var img := Image.create(64, 64, false, Image.FORMAT_RGBA8)
	for y in 64:
		for x in 64:
			var d := Vector2(x - 32, y - 32).length() / 32.0
			var a := clampf(1.0 - d, 0.0, 1.0)
			a *= a
			img.set_pixel(x, y, Color(1, 1, 1, a))
	light.texture = ImageTexture.create_from_image(img)
	light.texture_scale = 2.2
	add_child(light)
