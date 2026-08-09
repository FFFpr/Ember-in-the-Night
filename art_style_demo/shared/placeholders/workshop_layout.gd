class_name WorkshopLayout
extends RefCounted
## FP workshop plates using imported pack textures (compare pass).


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
	var plaster := DemoAssets.tex(DemoAssets.PLASTER)
	var cobble := DemoAssets.tex(DemoAssets.COBBLE)
	var wood := DemoAssets.tex(DemoAssets.WOOD)
	var brick := DemoAssets.tex(DemoAssets.BRICK)
	var wood_dark := DemoAssets.tex(DemoAssets.WOOD_DARK)

	PlateUtil.textured_rect(layer, "BackWall", Vector2(0, 0), Vector2(1280, 520), plaster, 0, Color(0.55, 0.62, 0.75), 0.003)
	PlateUtil.textured_rect(layer, "Floor", Vector2(0, 480), Vector2(1280, 240), cobble, 1, Color(0.75, 0.78, 0.85), 0.0035)
	PlateUtil.textured_rect(layer, "Ceiling", Vector2(0, 0), Vector2(1280, 70), wood_dark, 2, Color(0.25, 0.2, 0.16), 0.004)

	# Cold window
	PlateUtil.textured_rect(layer, "WindowFrame", Vector2(70, 90), Vector2(170, 200), wood_dark, 3, Color(0.7, 0.55, 0.4), 0.006)
	PlateUtil.rect(layer, "WindowGlass", Vector2(90, 110), Vector2(130, 160), ArtPalette.COOL_WINDOW, 4)
	PlateUtil.textured_rect(layer, "WindowMullionV", Vector2(148, 110), Vector2(10, 160), wood_dark, 5, Color.WHITE, 0.01)
	PlateUtil.textured_rect(layer, "WindowMullionH", Vector2(90, 185), Vector2(130, 10), wood_dark, 5, Color.WHITE, 0.01)

	# Stone forge mass
	PlateUtil.textured_poly(
		layer,
		"ForgeBody",
		PackedVector2Array([
			Vector2(780, 120), Vector2(1180, 100), Vector2(1220, 470),
			Vector2(760, 490), Vector2(740, 280),
		]),
		brick,
		3,
		Color(0.85, 0.8, 0.75),
		0.0035,
	)
	PlateUtil.textured_poly(
		layer,
		"ForgeArch",
		PackedVector2Array([
			Vector2(820, 180), Vector2(1120, 165), Vector2(1140, 420),
			Vector2(800, 435),
		]),
		wood_dark,
		4,
		Color(0.2, 0.16, 0.12),
		0.004,
	)
	PlateUtil.ellipse(layer, "ForgeGlowOuter", Vector2(970, 340), Vector2(130, 95), ArtPalette.WARM_EMBER_DEEP, 5)
	PlateUtil.ellipse(layer, "ForgeGlowMid", Vector2(970, 345), Vector2(90, 65), ArtPalette.WARM_EMBER, 6)
	PlateUtil.ellipse(layer, "ForgeGlowCore", Vector2(970, 350), Vector2(45, 32), ArtPalette.WARM_EMBER_CORE, 7)
	var flash := DemoAssets.tex(DemoAssets.FLASH)
	if flash:
		PlateUtil.sprite(layer, "ForgeFlash", flash, Vector2(970, 340), Vector2(0.55, 0.45), 8, Color(1.0, 0.55, 0.2, 0.85))
	PlateUtil.textured_rect(layer, "EmberBed", Vector2(880, 380), Vector2(180, 40), brick, 8, Color(1.0, 0.35, 0.1), 0.008)


static func _build_mid(layer: Node2D) -> void:
	var wood := DemoAssets.tex(DemoAssets.WOOD)
	var wood_dark := DemoAssets.tex(DemoAssets.WOOD_DARK)
	var metal := DemoAssets.tex(DemoAssets.METAL)

	# Quench barrel
	PlateUtil.textured_poly(
		layer,
		"BarrelBody",
		_ellipse_pts(Vector2(160, 470), Vector2(70, 85)),
		wood,
		0,
		Color(0.85, 0.7, 0.5),
		0.006,
	)
	PlateUtil.textured_poly(
		layer,
		"BarrelRim",
		_ellipse_pts(Vector2(160, 400), Vector2(72, 22)),
		wood_dark,
		1,
		Color.WHITE,
		0.008,
	)
	PlateUtil.ellipse(layer, "BarrelWater", Vector2(160, 405), Vector2(55, 14), ArtPalette.COOL_WINDOW, 2)
	PlateUtil.textured_rect(layer, "Bucket", Vector2(230, 470), Vector2(45, 55), wood_dark, 0, Color(0.7, 0.55, 0.35), 0.01)

	# Tool rack + hammers
	PlateUtil.textured_rect(layer, "RackBoard", Vector2(300, 140), Vector2(200, 18), wood, 0, Color.WHITE, 0.01)
	for i in 4:
		var x := 330.0 + float(i) * 42.0
		PlateUtil.textured_poly(
			layer,
			"Hammer_%d" % i,
			PackedVector2Array([
				Vector2(x, 158), Vector2(x + 14, 158), Vector2(x + 12, 250),
				Vector2(x + 2, 250),
			]),
			wood_dark,
			1,
			Color.WHITE,
			0.02,
		)
		PlateUtil.textured_rect(layer, "HammerHead_%d" % i, Vector2(x - 10, 155), Vector2(34, 18), metal, 2, Color(0.7, 0.72, 0.78), 0.02)

	PlateUtil.textured_rect(layer, "TongsA", Vector2(320, 270), Vector2(8, 90), metal, 1, Color(0.75, 0.78, 0.85), 0.03)
	PlateUtil.textured_rect(layer, "TongsB", Vector2(340, 275), Vector2(8, 85), metal, 1, Color(0.55, 0.58, 0.65), 0.03)

	for i in 3:
		var hx := 520.0 + float(i) * 40.0
		PlateUtil.textured_poly(
			layer,
			"Horseshoe_%d" % i,
			PackedVector2Array([
				Vector2(hx, 160), Vector2(hx + 22, 160), Vector2(hx + 26, 200),
				Vector2(hx + 18, 210), Vector2(hx + 14, 190), Vector2(hx + 8, 190),
				Vector2(hx + 4, 210), Vector2(hx - 4, 200),
			]),
			metal,
			1,
			Color(0.8, 0.82, 0.88),
			0.02,
		)

	PlateUtil.textured_rect(layer, "IngotPile", Vector2(250, 500), Vector2(90, 40), metal, 0, Color(0.45, 0.48, 0.55), 0.01)
	PlateUtil.textured_rect(layer, "IngotTop", Vector2(260, 485), Vector2(70, 20), metal, 1, Color(0.7, 0.72, 0.78), 0.015)

	# Anvil on stump
	PlateUtil.textured_poly(layer, "Stump", _ellipse_pts(Vector2(560, 470), Vector2(95, 55)), wood_dark, 2, Color(0.7, 0.55, 0.35), 0.006)
	PlateUtil.textured_rect(layer, "StumpFace", Vector2(480, 430), Vector2(160, 55), wood, 3, Color(0.85, 0.7, 0.5), 0.008)
	PlateUtil.textured_poly(
		layer,
		"AnvilBody",
		PackedVector2Array([
			Vector2(470, 390), Vector2(660, 385), Vector2(670, 420),
			Vector2(620, 435), Vector2(600, 470), Vector2(520, 470),
			Vector2(500, 435), Vector2(460, 420),
		]),
		metal,
		4,
		Color(0.35, 0.36, 0.4),
		0.005,
	)
	PlateUtil.textured_poly(
		layer,
		"AnvilHorn",
		PackedVector2Array([
			Vector2(460, 400), Vector2(470, 390), Vector2(430, 405),
			Vector2(435, 418),
		]),
		metal,
		5,
		Color(0.55, 0.58, 0.65),
		0.01,
	)
	PlateUtil.rect(layer, "AnvilHighlight", Vector2(520, 392), Vector2(90, 10), Color(0.75, 0.78, 0.85, 0.45), 6)

	# Bellows
	PlateUtil.textured_poly(
		layer,
		"Bellows",
		PackedVector2Array([
			Vector2(1100, 300), Vector2(1240, 280), Vector2(1250, 400),
			Vector2(1110, 430), Vector2(1080, 360),
		]),
		wood,
		3,
		Color(0.8, 0.65, 0.45),
		0.005,
	)
	PlateUtil.textured_poly(
		layer,
		"BellowsLeather",
		PackedVector2Array([
			Vector2(1120, 320), Vector2(1225, 305), Vector2(1230, 380),
			Vector2(1125, 400),
		]),
		wood_dark,
		4,
		Color(0.45, 0.28, 0.18),
		0.006,
	)
	PlateUtil.textured_rect(layer, "BellowsHandle", Vector2(1235, 250), Vector2(18, 60), wood_dark, 5, Color.WHITE, 0.02)


static func _build_near(layer: Node2D) -> void:
	var wood := DemoAssets.tex(DemoAssets.WOOD)
	var wood_dark := DemoAssets.tex(DemoAssets.WOOD_DARK)
	var metal := DemoAssets.tex(DemoAssets.METAL)

	for i in 5:
		var x := 80.0 + float(i) * 240.0
		PlateUtil.textured_poly(
			layer,
			"Rafter_%d" % i,
			PackedVector2Array([
				Vector2(x, 0), Vector2(x + 40, 0), Vector2(x + 70, 90),
				Vector2(x + 30, 95),
			]),
			wood_dark,
			0,
			Color(0.55, 0.4, 0.28),
			0.008,
		)
	PlateUtil.textured_rect(layer, "BeamAcross", Vector2(40, 55), Vector2(1200, 22), wood, 1, Color(0.7, 0.55, 0.35), 0.004)

	PlateUtil.textured_rect(layer, "HangChain", Vector2(700, 70), Vector2(6, 50), metal, 2, Color(0.7, 0.72, 0.78), 0.05)
	PlateUtil.textured_rect(layer, "HangTool", Vector2(685, 115), Vector2(36, 14), metal, 3, Color(0.5, 0.52, 0.58), 0.03)

	PlateUtil.textured_poly(
		layer,
		"BenchTop",
		PackedVector2Array([
			Vector2(0, 560), Vector2(1280, 540), Vector2(1280, 720),
			Vector2(0, 720),
		]),
		wood,
		4,
		Color(0.85, 0.7, 0.5),
		0.0025,
	)
	PlateUtil.textured_poly(
		layer,
		"BenchLip",
		PackedVector2Array([
			Vector2(0, 560), Vector2(1280, 540), Vector2(1280, 565),
			Vector2(0, 585),
		]),
		wood_dark,
		5,
		Color(0.55, 0.4, 0.25),
		0.004,
	)

	PlateUtil.textured_poly(
		layer,
		"LeftGlove",
		PackedVector2Array([
			Vector2(200, 610), Vector2(380, 585), Vector2(410, 690),
			Vector2(230, 715),
		]),
		wood_dark,
		6,
		Color(0.55, 0.35, 0.22),
		0.008,
	)
	PlateUtil.textured_poly(
		layer,
		"RightGlove",
		PackedVector2Array([
			Vector2(800, 590), Vector2(1000, 575), Vector2(1035, 705),
			Vector2(830, 720),
		]),
		wood_dark,
		6,
		Color(0.5, 0.32, 0.2),
		0.008,
	)
	PlateUtil.textured_rect(layer, "HammerHandleFP", Vector2(900, 520), Vector2(24, 130), wood_dark, 7, Color.WHITE, 0.02)
	PlateUtil.textured_rect(layer, "HammerHeadFP", Vector2(870, 500), Vector2(84, 34), metal, 8, Color(0.55, 0.58, 0.65), 0.015)
	PlateUtil.textured_rect(layer, "TongsOnBench", Vector2(120, 575), Vector2(130, 16), metal, 7, Color(0.75, 0.78, 0.85), 0.02)


static func _ellipse_pts(center: Vector2, radii: Vector2, segments: int = 16) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in segments:
		var t := TAU * float(i) / float(segments)
		pts.append(center + Vector2(cos(t) * radii.x, sin(t) * radii.y))
	return pts
