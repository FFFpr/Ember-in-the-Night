extends Node2D
## Iso shop-front street; day 0–10s / night 10–20s via CanvasModulate + window glow.

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
const PAL_EMBER := Color("ffb14a")
const PAL_METAL := Color("2a3038")
const PAL_DAY_SKY := Color("9eb0c2")
const PAL_NIGHT_SKY := Color("1a2436")


func _ready() -> void:
	_build_street()
	_lock_camera()


func _build_street() -> void:
	var world := Node2D.new()
	world.name = "World"
	add_child(world)

	var sky := Polygon2D.new()
	sky.name = "Sky"
	sky.polygon = PackedVector2Array([
		Vector2(-700, -420),
		Vector2(700, -420),
		Vector2(700, 80),
		Vector2(-700, 80),
	])
	sky.color = PAL_DAY_SKY
	sky.z_index = -20
	world.add_child(sky)

	# Cobble / dirt road strip.
	for gx in range(-2, 14):
		for gy in range(4, 10):
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

	var modulate := CanvasModulate.new()
	modulate.name = "CanvasModulate"
	modulate.color = Color(1, 1, 1, 1)
	add_child(modulate)

	var cycle := Node.new()
	cycle.name = "DayNight"
	cycle.set_script(load("res://art_style_demo/03_isometric/street/day_night.gd"))
	add_child(cycle)


func _build_smithy(world: Node2D) -> void:
	# Ground floor stone mass.
	var facade := IsoDraw.make_box(world, Vector2(2.0, 2.2), 90.0, PAL_STONE, PAL_STONE_DK, 8, 70.0, 36.0)
	facade.name = "SmithyFacade"

	# Upper half-timber.
	var upper := IsoDraw.make_box(world, Vector2(2.0, 2.0), 150.0, PAL_PLASTER, PAL_TIMBER, 6, 68.0, 34.0)
	upper.name = "SmithyUpper"

	# Roof slab.
	var roof := IsoDraw.make_box(world, Vector2(2.0, 1.7), 175.0, PAL_ROOF, PAL_ROOF.darkened(0.15), 5, 76.0, 30.0)
	roof.name = "SmithyRoof"

	# Door.
	var door := IsoDraw.make_box(world, Vector2(1.5, 3.0), 52.0, PAL_DOOR, PAL_WOOD_DK, 14, 16.0, 10.0)
	door.name = "Door"

	# Hanging sign.
	var arm := Polygon2D.new()
	arm.polygon = PackedVector2Array([
		Vector2(0, 0), Vector2(48, -8), Vector2(48, -4), Vector2(0, 4),
	])
	arm.position = IsoDraw.grid_to_screen(2.8, 2.6) + Vector2(0, -70)
	arm.color = PAL_WOOD_DK
	arm.z_index = 22
	world.add_child(arm)
	var sign := IsoDraw.make_box(world, Vector2(3.4, 2.5), 70.0, PAL_SIGN, PAL_METAL, 22, 18.0, 10.0)
	sign.name = "Sign"
	IsoDraw.make_label(world, "sign", IsoDraw.grid_to_screen(3.4, 2.5) + Vector2(0, -86))

	# Outdoor forge mouth under porch read.
	var forge := IsoDraw.make_box(world, Vector2(3.6, 3.4), 36.0, PAL_STONE, PAL_STONE_DK, 16, 28.0, 14.0)
	forge.name = "OutdoorForge"
	var glow := IsoDraw.make_diamond(
		world,
		IsoDraw.grid_to_screen(3.6, 3.55) + Vector2(0, -22),
		PAL_FIRE,
		24,
		16.0,
		9.0,
	)
	glow.name = "ForgeGlow"

	# Windows (emissive at night via DayNight script).
	var win_a := IsoDraw.make_box(world, Vector2(2.6, 2.4), 118.0, Color("7a8aa0"), PAL_TIMBER, 18, 14.0, 8.0)
	win_a.name = "WindowA"
	var win_b := IsoDraw.make_box(world, Vector2(1.2, 2.6), 118.0, Color("7a8aa0"), PAL_TIMBER, 18, 14.0, 8.0)
	win_b.name = "WindowB"

	IsoDraw.make_label(world, "smithy", IsoDraw.grid_to_screen(2.0, 2.2) + Vector2(0, -120))


func _build_neighbors(world: Node2D) -> void:
	var n1 := IsoDraw.make_box(world, Vector2(7.5, 1.8), 110.0, PAL_PLASTER.darkened(0.05), PAL_TIMBER, 4, 55.0, 28.0)
	n1.name = "NeighborA"
	var n1_roof := IsoDraw.make_box(world, Vector2(7.5, 1.5), 145.0, PAL_ROOF.lightened(0.05), PAL_ROOF, 3, 60.0, 26.0)
	n1_roof.name = "NeighborARoof"

	var n2 := IsoDraw.make_box(world, Vector2(10.5, 2.5), 95.0, PAL_STONE.lightened(0.08), PAL_STONE_DK, 4, 48.0, 26.0)
	n2.name = "NeighborB"
	var n2_roof := IsoDraw.make_box(world, Vector2(10.5, 2.2), 130.0, PAL_ROOF, PAL_ROOF.darkened(0.1), 3, 52.0, 24.0)
	n2_roof.name = "NeighborBRoof"


func _build_street_props(world: Node2D) -> void:
	var barrel_a := IsoDraw.make_box(world, Vector2(4.4, 5.0), 28.0, PAL_WOOD, PAL_WOOD_DK, 12, 16.0, 10.0)
	barrel_a.name = "BarrelA"
	var barrel_b := IsoDraw.make_box(world, Vector2(5.0, 5.3), 22.0, PAL_WOOD.lightened(0.05), PAL_WOOD_DK, 12, 14.0, 9.0)
	barrel_b.name = "BarrelB"
	var crate := IsoDraw.make_box(world, Vector2(5.8, 4.8), 20.0, PAL_WOOD.darkened(0.05), PAL_WOOD_DK, 12, 18.0, 11.0)
	crate.name = "Crate"
	var anvil := IsoDraw.make_box(world, Vector2(4.0, 4.2), 30.0, PAL_METAL.lightened(0.15), PAL_METAL, 14, 18.0, 10.0)
	anvil.name = "StreetAnvil"
	IsoDraw.make_label(world, "props", IsoDraw.grid_to_screen(5.0, 5.1) + Vector2(0, -36))


func _lock_camera() -> void:
	var cam := Camera2D.new()
	cam.name = "Camera2D"
	cam.position = IsoDraw.grid_to_screen(4.5, 3.8) + Vector2(20, -40)
	cam.enabled = true
	add_child(cam)
