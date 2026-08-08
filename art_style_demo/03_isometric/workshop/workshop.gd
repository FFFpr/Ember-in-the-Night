extends Node2D
## Locked iso workshop: forge–anvil cluster, placeholder diamonds/boxes.

const PAL_FLOOR_A := Color("2c3642")
const PAL_FLOOR_B := Color("24303b")
const PAL_WALL := Color("3d4a57")
const PAL_BEAM := Color("1a222b")
const PAL_STONE := Color("5a5854")
const PAL_STONE_DARK := Color("3f3d3a")
const PAL_FIRE := Color("ff6a1f")
const PAL_EMBER := Color("ffb14a")
const PAL_METAL := Color("1b2028")
const PAL_METAL_HI := Color("3a4452")
const PAL_WOOD := Color("6b4a32")
const PAL_WOOD_DK := Color("4a3222")
const PAL_WATER := Color("3a6a7a")
const PAL_COOL := Color("4a78a8")
const PAL_ORE := Color("6a5a4a")


func _ready() -> void:
	_build_room()
	_build_props()
	_lock_camera()


func _build_room() -> void:
	var world := Node2D.new()
	world.name = "World"
	add_child(world)

	# Diamond floor (readable iso grid).
	for gx in range(0, 11):
		for gy in range(0, 11):
			var checker := ((gx + gy) % 2) == 0
			IsoDraw.make_diamond(
				world,
				IsoDraw.grid_to_screen(float(gx), float(gy)),
				PAL_FLOOR_A if checker else PAL_FLOOR_B,
				0,
			)

	# Back / left wall slabs (iso “up” faces as raised diamonds).
	for gx in range(0, 11):
		IsoDraw.make_box(world, Vector2(gx, -0.35), 78.0, PAL_WALL, PAL_WALL.darkened(0.18), 2)
	for gy in range(0, 11):
		IsoDraw.make_box(world, Vector2(-0.35, gy), 78.0, PAL_WALL.lightened(0.05), PAL_WALL.darkened(0.22), 2)

	# Dim rafters / beams across the upper volume.
	for i in range(3):
		var beam := Polygon2D.new()
		var y := 40.0 + float(i) * 54.0
		beam.polygon = PackedVector2Array([
			Vector2(-220.0, y),
			Vector2(420.0, y - 120.0),
			Vector2(420.0, y - 108.0),
			Vector2(-220.0, y + 12.0),
		])
		beam.color = PAL_BEAM
		beam.z_index = 8
		world.add_child(beam)

	# Cool night window on the left wall.
	var window := IsoDraw.make_box(world, Vector2(0.6, 2.2), 44.0, PAL_COOL, PAL_WOOD_DK, 12, 18.0, 10.0)
	window.name = "ColdWindow"
	IsoDraw.make_label(world, "window", IsoDraw.grid_to_screen(0.6, 2.2) + Vector2(0, -58))


func _build_props() -> void:
	var props := Node2D.new()
	props.name = "Props"
	add_child(props)

	# Forge / hearth — warm key, upper-center of cluster.
	var forge := IsoDraw.make_box(props, Vector2(5.0, 2.2), 56.0, PAL_STONE, PAL_STONE_DARK, 10, 48.0, 24.0)
	forge.name = "Forge"
	var mouth := IsoDraw.make_diamond(
		props,
		IsoDraw.grid_to_screen(5.0, 2.55) + Vector2(0, -28),
		PAL_FIRE,
		25,
		28.0,
		14.0,
	)
	mouth.name = "ForgeMouth"
	var coals := IsoDraw.make_diamond(
		props,
		IsoDraw.grid_to_screen(5.0, 2.55) + Vector2(0, -36),
		PAL_EMBER,
		26,
		14.0,
		8.0,
	)
	coals.name = "Coals"
	IsoDraw.make_label(props, "forge", IsoDraw.grid_to_screen(5.0, 2.2) + Vector2(0, -78))

	# Anvil — lower-center, in front of forge (viewer side).
	var anvil_base := IsoDraw.make_box(props, Vector2(5.2, 4.6), 28.0, PAL_WOOD, PAL_WOOD_DK, 14, 22.0, 12.0)
	anvil_base.name = "AnvilBase"
	var anvil := IsoDraw.make_box(props, Vector2(5.2, 4.6), 46.0, PAL_METAL_HI, PAL_METAL, 16, 30.0, 14.0)
	anvil.name = "Anvil"
	IsoDraw.make_label(props, "anvil", IsoDraw.grid_to_screen(5.2, 4.6) + Vector2(0, -62))

	# Quench barrel (left of anvil).
	var barrel := IsoDraw.make_box(props, Vector2(3.2, 4.8), 40.0, PAL_WATER, PAL_WOOD_DK, 14, 20.0, 12.0)
	barrel.name = "QuenchBarrel"
	IsoDraw.make_label(props, "quench", IsoDraw.grid_to_screen(3.2, 4.8) + Vector2(0, -56))

	# Bellows (right of forge).
	var bellows := IsoDraw.make_box(props, Vector2(7.0, 3.0), 34.0, PAL_WOOD, PAL_WOOD_DK, 14, 26.0, 14.0)
	bellows.name = "Bellows"
	IsoDraw.make_label(props, "bellows", IsoDraw.grid_to_screen(7.0, 3.0) + Vector2(0, -52))

	# Tool rack on left wall.
	var rack := IsoDraw.make_box(props, Vector2(1.4, 1.6), 50.0, PAL_WOOD, PAL_WOOD_DK, 12, 34.0, 12.0)
	rack.name = "ToolRack"
	for i in range(3):
		var tool := IsoDraw.make_box(
			props,
			Vector2(1.1 + float(i) * 0.35, 1.85),
			38.0 + float(i) * 4.0,
			PAL_METAL_HI,
			PAL_METAL,
			18,
			6.0,
			4.0,
		)
		tool.name = "Tool_%d" % i
	IsoDraw.make_label(props, "tools", IsoDraw.grid_to_screen(1.4, 1.6) + Vector2(0, -66))

	# Ore / ingots near forge.
	for i in range(3):
		var ingot := IsoDraw.make_box(
			props,
			Vector2(6.4 + float(i) * 0.25, 4.9 + float(i) * 0.15),
			12.0,
			PAL_ORE.lightened(0.08 * float(i)),
			PAL_ORE.darkened(0.1),
			15,
			14.0,
			8.0,
		)
		ingot.name = "Ingot_%d" % i
	IsoDraw.make_label(props, "ore", IsoDraw.grid_to_screen(6.6, 5.0) + Vector2(0, -28))

	# Hanging horseshoes on wall near window.
	for i in range(3):
		var shoe := IsoDraw.make_diamond(
			props,
			IsoDraw.grid_to_screen(0.9, 3.4) + Vector2(float(i) * 10.0, -48.0 - float(i) * 14.0),
			PAL_METAL_HI,
			20,
			8.0,
			6.0,
		)
		shoe.name = "Horseshoe_%d" % i
	IsoDraw.make_label(props, "shoes", IsoDraw.grid_to_screen(0.9, 3.4) + Vector2(12, -78))


func _lock_camera() -> void:
	var cam := Camera2D.new()
	cam.name = "Camera2D"
	# Focus forge–anvil cluster (lower-center of the iso read).
	cam.position = IsoDraw.grid_to_screen(5.1, 3.6) + Vector2(0, -20)
	cam.enabled = true
	add_child(cam)
