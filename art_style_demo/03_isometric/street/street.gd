extends Node2D
## Iso shop-front street; day 0–10s / night 10–20s.
## Night darkens `World` via modulate; emissives live on a sibling layer.

const PAL_ROAD_A := Color("3a4552")
const PAL_ROAD_B := Color("323c48")
const PAL_STONE := Color("6a6862")
const PAL_STONE_DK := Color("4a4844")
const PAL_PLASTER := Color("c9c2b4")
const PAL_TIMBER := Color("3a2a1e")
const PAL_ROOF := Color("2a3a55")
const PAL_WOOD := Color("6b4a32")
const PAL_WOOD_DK := Color("4a3222")
const PAL_DOOR := Color("2e2218")
const PAL_SIGN := Color("1e2430")
const PAL_FIRE := Color("ff6a1f")
const PAL_METAL := Color("2a3038")
const PAL_DAY_SKY := Color("8fa3b8")
const PAL_WINDOW_DAY := Color("6a7a90")


func _ready() -> void:
	_build_street()
	_lock_camera()


func _build_street() -> void:
	var sky := Polygon2D.new()
	sky.name = "Sky"
	sky.polygon = PackedVector2Array([
		Vector2(-900, -520),
		Vector2(900, -520),
		Vector2(900, 200),
		Vector2(-900, 200),
	])
	sky.color = PAL_DAY_SKY
	sky.z_index = -40
	add_child(sky)

	var world := Node2D.new()
	world.name = "World"
	add_child(world)

	# Cobble road strip in front of facades.
	for gx in range(-1, 13):
		for gy in range(5, 11):
			var checker := ((gx + gy) % 2) == 0
			IsoDraw.make_diamond(
				world,
				IsoDraw.grid_to_screen(float(gx), float(gy)),
				PAL_ROAD_A if checker else PAL_ROAD_B,
				0,
			)

	_build_smithy(world)
	_build_neighbors(world)
	_build_street_props(world)

	# Emissive overlays — not under World.modulate, so night glow stays warm.
	var emissives := Node2D.new()
	emissives.name = "Emissives"
	emissives.visible = false
	add_child(emissives)
	_add_window_glow(emissives, Vector2(2.55, 2.35), "GlowWindowA")
	_add_window_glow(emissives, Vector2(1.15, 2.55), "GlowWindowB")
	var forge_glow := IsoDraw.make_diamond(
		emissives,
		IsoDraw.grid_to_screen(3.55, 3.55) + Vector2(0, -20),
		Color("ffc56a"),
		50,
		18.0,
		10.0,
	)
	forge_glow.name = "GlowForge"

	var cycle := Node.new()
	cycle.name = "DayNight"
	cycle.set_script(load("res://art_style_demo/03_isometric/street/day_night.gd"))
	add_child(cycle)


func _add_window_glow(parent: Node, grid: Vector2, node_name: String) -> void:
	var glow := IsoDraw.make_box(
		parent,
		grid,
		118.0,
		Color("ffb14a"),
		Color("ff8a2a"),
		48,
		12.0,
		7.0,
	)
	glow.name = node_name


func _build_smithy(world: Node2D) -> void:
	# One readable facade mass (stone body + timber band + roof cap).
	var body := IsoDraw.make_box(world, Vector2(2.0, 2.4), 88.0, PAL_STONE, PAL_STONE_DK, 8, 72.0, 36.0)
	body.name = "SmithyBody"
	var timber := IsoDraw.make_box(world, Vector2(2.0, 2.25), 130.0, PAL_PLASTER, PAL_TIMBER, 9, 70.0, 34.0)
	timber.name = "SmithyTimber"
	var roof := IsoDraw.make_box(world, Vector2(2.0, 2.05), 158.0, PAL_ROOF, PAL_ROOF.darkened(0.12), 10, 76.0, 30.0)
	roof.name = "SmithyRoof"

	var door := IsoDraw.make_box(world, Vector2(1.45, 3.15), 48.0, PAL_DOOR, PAL_WOOD_DK, 14, 15.0, 9.0)
	door.name = "Door"

	var arm := Polygon2D.new()
	arm.polygon = PackedVector2Array([
		Vector2(0, 0), Vector2(52, -10), Vector2(52, -5), Vector2(0, 5),
	])
	arm.position = IsoDraw.grid_to_screen(2.7, 2.7) + Vector2(0, -64)
	arm.color = PAL_WOOD_DK
	arm.z_index = 22
	world.add_child(arm)
	var sign := IsoDraw.make_box(world, Vector2(3.45, 2.55), 64.0, PAL_SIGN, PAL_METAL, 22, 16.0, 9.0)
	sign.name = "Sign"
	IsoDraw.make_label(world, "sign", IsoDraw.grid_to_screen(3.45, 2.55) + Vector2(0, -80))

	var forge := IsoDraw.make_box(world, Vector2(3.55, 3.45), 34.0, PAL_STONE, PAL_STONE_DK, 16, 26.0, 13.0)
	forge.name = "OutdoorForge"
	var forge_mouth := IsoDraw.make_diamond(
		world,
		IsoDraw.grid_to_screen(3.55, 3.55) + Vector2(0, -20),
		PAL_FIRE,
		24,
		14.0,
		8.0,
	)
	forge_mouth.name = "ForgeMouth"

	var win_a := IsoDraw.make_box(world, Vector2(2.55, 2.35), 118.0, PAL_WINDOW_DAY, PAL_TIMBER, 18, 12.0, 7.0)
	win_a.name = "WindowA"
	var win_b := IsoDraw.make_box(world, Vector2(1.15, 2.55), 118.0, PAL_WINDOW_DAY, PAL_TIMBER, 18, 12.0, 7.0)
	win_b.name = "WindowB"

	IsoDraw.make_label(world, "smithy", IsoDraw.grid_to_screen(2.0, 2.4) + Vector2(0, -168))


func _build_neighbors(world: Node2D) -> void:
	var n1 := IsoDraw.make_box(world, Vector2(7.2, 2.0), 100.0, PAL_PLASTER.darkened(0.06), PAL_TIMBER, 6, 52.0, 28.0)
	n1.name = "NeighborA"
	var n1_roof := IsoDraw.make_box(world, Vector2(7.2, 1.85), 128.0, PAL_ROOF.lightened(0.06), PAL_ROOF, 7, 56.0, 24.0)
	n1_roof.name = "NeighborARoof"

	var n2 := IsoDraw.make_box(world, Vector2(10.2, 2.6), 86.0, PAL_STONE.lightened(0.06), PAL_STONE_DK, 6, 46.0, 24.0)
	n2.name = "NeighborB"
	var n2_roof := IsoDraw.make_box(world, Vector2(10.2, 2.45), 114.0, PAL_ROOF, PAL_ROOF.darkened(0.1), 7, 50.0, 22.0)
	n2_roof.name = "NeighborBRoof"


func _build_street_props(world: Node2D) -> void:
	IsoDraw.make_box(world, Vector2(4.5, 5.2), 28.0, PAL_WOOD, PAL_WOOD_DK, 12, 16.0, 10.0).name = "BarrelA"
	IsoDraw.make_box(world, Vector2(5.15, 5.45), 22.0, PAL_WOOD.lightened(0.05), PAL_WOOD_DK, 12, 14.0, 9.0).name = "BarrelB"
	IsoDraw.make_box(world, Vector2(5.9, 5.0), 20.0, PAL_WOOD.darkened(0.05), PAL_WOOD_DK, 12, 18.0, 11.0).name = "Crate"
	IsoDraw.make_box(world, Vector2(4.05, 4.35), 30.0, PAL_METAL.lightened(0.15), PAL_METAL, 14, 18.0, 10.0).name = "StreetAnvil"
	IsoDraw.make_label(world, "props", IsoDraw.grid_to_screen(5.1, 5.2) + Vector2(0, -40))


func _lock_camera() -> void:
	var cam := Camera2D.new()
	cam.name = "Camera2D"
	cam.position = IsoDraw.grid_to_screen(4.8, 4.0) + Vector2(10, -55)
	cam.enabled = true
	add_child(cam)
