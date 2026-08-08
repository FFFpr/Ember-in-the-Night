class_name WorkshopLayout
extends RefCounted
## Builds FP workshop plates matching art_style_demo reference framing.


static func build(parent: Node2D) -> void:
	var far := Node2D.new()
	far.name = "LayerFar"
	parent.add_child(far)

	var mid := Node2D.new()
	mid.name = "LayerMid"
	parent.add_child(mid)

	var near := Node2D.new()
	near.name = "LayerNear"
	parent.add_child(near)

	_build_far(far)
	_build_mid(mid)
	_build_near(near)


static func _build_far(layer: Node2D) -> void:
	PlateUtil.rect(layer, "BackWall", Vector2(0, 0), Vector2(1280, 520), ArtPalette.COOL_WALL, 0)
	PlateUtil.rect(layer, "Floor", Vector2(0, 480), Vector2(1280, 240), ArtPalette.FLOOR, 1)
	# Cobble strips
	for i in 8:
		var y := 500.0 + float(i) * 22.0
		PlateUtil.rect(layer, "Cobble_%d" % i, Vector2(0, y), Vector2(1280, 8), ArtPalette.FLOOR_DARK if i % 2 == 0 else ArtPalette.COOL_STONE, 2)

	# Cold window (left)
	PlateUtil.rect(layer, "WindowFrame", Vector2(70, 90), Vector2(170, 200), ArtPalette.WARM_WOOD_DARK, 3)
	PlateUtil.rect(layer, "WindowGlass", Vector2(90, 110), Vector2(130, 160), ArtPalette.COOL_WINDOW, 4)
	PlateUtil.rect(layer, "WindowMullionV", Vector2(148, 110), Vector2(10, 160), ArtPalette.WARM_WOOD_DARK, 5)
	PlateUtil.rect(layer, "WindowMullionH", Vector2(90, 185), Vector2(130, 10), ArtPalette.WARM_WOOD_DARK, 5)

	# Stone forge mass (right)
	PlateUtil.poly(
		layer,
		"ForgeBody",
		PackedVector2Array([
			Vector2(780, 120), Vector2(1180, 100), Vector2(1220, 470),
			Vector2(760, 490), Vector2(740, 280),
		]),
		ArtPalette.COOL_STONE,
		3,
	)
	PlateUtil.poly(
		layer,
		"ForgeArch",
		PackedVector2Array([
			Vector2(820, 180), Vector2(1120, 165), Vector2(1140, 420),
			Vector2(800, 435),
		]),
		ArtPalette.COOL_WALL_DARK,
		4,
	)
	PlateUtil.ellipse(layer, "ForgeGlowOuter", Vector2(970, 340), Vector2(130, 95), ArtPalette.WARM_EMBER_DEEP, 5)
	PlateUtil.ellipse(layer, "ForgeGlowMid", Vector2(970, 345), Vector2(90, 65), ArtPalette.WARM_EMBER, 6)
	PlateUtil.ellipse(layer, "ForgeGlowCore", Vector2(970, 350), Vector2(45, 32), ArtPalette.WARM_EMBER_CORE, 7)
	PlateUtil.rect(layer, "EmberBed", Vector2(880, 380), Vector2(180, 40), ArtPalette.WARM_EMBER_DEEP, 8)

	# Ceiling gloom
	PlateUtil.rect(layer, "Ceiling", Vector2(0, 0), Vector2(1280, 70), ArtPalette.SHADOW, 9)


static func _build_mid(layer: Node2D) -> void:
	# Quench barrel (left)
	PlateUtil.ellipse(layer, "BarrelBody", Vector2(160, 470), Vector2(70, 85), ArtPalette.WARM_WOOD, 0)
	PlateUtil.ellipse(layer, "BarrelRim", Vector2(160, 400), Vector2(72, 22), ArtPalette.WARM_WOOD_DARK, 1)
	PlateUtil.ellipse(layer, "BarrelWater", Vector2(160, 405), Vector2(55, 14), ArtPalette.COOL_WINDOW, 2)
	PlateUtil.rect(layer, "Bucket", Vector2(230, 470), Vector2(45, 55), ArtPalette.WARM_WOOD_DARK, 0)

	# Tool rack
	PlateUtil.rect(layer, "RackBoard", Vector2(300, 140), Vector2(200, 18), ArtPalette.WARM_WOOD, 0)
	for i in 4:
		var x := 330.0 + float(i) * 42.0
		PlateUtil.poly(
			layer,
			"Hammer_%d" % i,
			PackedVector2Array([
				Vector2(x, 158), Vector2(x + 14, 158), Vector2(x + 12, 250),
				Vector2(x + 2, 250),
			]),
			ArtPalette.WARM_WOOD_DARK,
			1,
		)
		PlateUtil.rect(layer, "HammerHead_%d" % i, Vector2(x - 10, 155), Vector2(34, 18), ArtPalette.METAL, 2)

	# Tongs on rack
	PlateUtil.rect(layer, "TongsA", Vector2(320, 270), Vector2(8, 90), ArtPalette.METAL_LIGHT, 1)
	PlateUtil.rect(layer, "TongsB", Vector2(340, 275), Vector2(8, 85), ArtPalette.METAL, 1)

	# Horseshoes
	for i in 3:
		var hx := 520.0 + float(i) * 40.0
		PlateUtil.poly(
			layer,
			"Horseshoe_%d" % i,
			PackedVector2Array([
				Vector2(hx, 160), Vector2(hx + 22, 160), Vector2(hx + 26, 200),
				Vector2(hx + 18, 210), Vector2(hx + 14, 190), Vector2(hx + 8, 190),
				Vector2(hx + 4, 210), Vector2(hx - 4, 200),
			]),
			ArtPalette.METAL_LIGHT,
			1,
		)

	# Ore / ingots
	PlateUtil.rect(layer, "IngotPile", Vector2(250, 500), Vector2(90, 40), ArtPalette.METAL, 0)
	PlateUtil.rect(layer, "IngotTop", Vector2(260, 485), Vector2(70, 20), ArtPalette.METAL_LIGHT, 1)

	# Anvil on stump (center hero)
	PlateUtil.ellipse(layer, "Stump", Vector2(560, 470), Vector2(95, 55), ArtPalette.WARM_WOOD_DARK, 2)
	PlateUtil.rect(layer, "StumpFace", Vector2(480, 430), Vector2(160, 55), ArtPalette.WARM_WOOD, 3)
	PlateUtil.poly(
		layer,
		"AnvilBody",
		PackedVector2Array([
			Vector2(470, 390), Vector2(660, 385), Vector2(670, 420),
			Vector2(620, 435), Vector2(600, 470), Vector2(520, 470),
			Vector2(500, 435), Vector2(460, 420),
		]),
		ArtPalette.METAL,
		4,
	)
	PlateUtil.poly(
		layer,
		"AnvilHorn",
		PackedVector2Array([
			Vector2(460, 400), Vector2(470, 390), Vector2(430, 405),
			Vector2(435, 418),
		]),
		ArtPalette.METAL_LIGHT,
		5,
	)
	PlateUtil.rect(layer, "AnvilHighlight", Vector2(520, 392), Vector2(90, 10), Color(ArtPalette.METAL_LIGHT, 0.55), 6)

	# Bellows (right of forge mouth)
	PlateUtil.poly(
		layer,
		"Bellows",
		PackedVector2Array([
			Vector2(1100, 300), Vector2(1240, 280), Vector2(1250, 400),
			Vector2(1110, 430), Vector2(1080, 360),
		]),
		ArtPalette.WARM_WOOD,
		3,
	)
	PlateUtil.poly(
		layer,
		"BellowsLeather",
		PackedVector2Array([
			Vector2(1120, 320), Vector2(1225, 305), Vector2(1230, 380),
			Vector2(1125, 400),
		]),
		ArtPalette.WARM_WOOD_DARK,
		4,
	)
	PlateUtil.rect(layer, "BellowsHandle", Vector2(1235, 250), Vector2(18, 60), ArtPalette.WARM_WOOD_DARK, 5)


static func _build_near(layer: Node2D) -> void:
	# Rafters / beams
	for i in 5:
		var x := 80.0 + float(i) * 240.0
		PlateUtil.poly(
			layer,
			"Rafter_%d" % i,
			PackedVector2Array([
				Vector2(x, 0), Vector2(x + 40, 0), Vector2(x + 70, 90),
				Vector2(x + 30, 95),
			]),
			ArtPalette.WARM_WOOD_DARK,
			0,
		)
	PlateUtil.rect(layer, "BeamAcross", Vector2(40, 55), Vector2(1200, 22), ArtPalette.WARM_WOOD, 1)

	# Hanging tongs near top
	PlateUtil.rect(layer, "HangChain", Vector2(700, 70), Vector2(6, 50), ArtPalette.METAL_LIGHT, 2)
	PlateUtil.rect(layer, "HangTool", Vector2(685, 115), Vector2(36, 14), ArtPalette.METAL, 3)

	# Workbench edge (FP foreground)
	PlateUtil.poly(
		layer,
		"BenchTop",
		PackedVector2Array([
			Vector2(0, 560), Vector2(1280, 540), Vector2(1280, 720),
			Vector2(0, 720),
		]),
		ArtPalette.WARM_WOOD,
		4,
	)
	PlateUtil.poly(
		layer,
		"BenchLip",
		PackedVector2Array([
			Vector2(0, 560), Vector2(1280, 540), Vector2(1280, 565),
			Vector2(0, 585),
		]),
		ArtPalette.WARM_WOOD_DARK,
		5,
	)

	# Simple glove / hand blocks (FP cue, not gameplay)
	PlateUtil.poly(
		layer,
		"LeftGlove",
		PackedVector2Array([
			Vector2(200, 610), Vector2(380, 585), Vector2(410, 690),
			Vector2(230, 715),
		]),
		Color(0.48, 0.30, 0.18, 1.0),
		6,
	)
	PlateUtil.poly(
		layer,
		"RightGlove",
		PackedVector2Array([
			Vector2(800, 590), Vector2(1000, 575), Vector2(1035, 705),
			Vector2(830, 720),
		]),
		Color(0.44, 0.27, 0.16, 1.0),
		6,
	)
	PlateUtil.rect(layer, "HammerHandleFP", Vector2(900, 520), Vector2(24, 130), ArtPalette.WARM_WOOD_DARK, 7)
	PlateUtil.rect(layer, "HammerHeadFP", Vector2(870, 500), Vector2(84, 34), ArtPalette.METAL, 8)
	PlateUtil.rect(layer, "TongsOnBench", Vector2(120, 575), Vector2(130, 16), ArtPalette.METAL_LIGHT, 7)
