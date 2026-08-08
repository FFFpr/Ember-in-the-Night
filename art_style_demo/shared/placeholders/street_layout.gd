class_name StreetLayout
extends RefCounted
## Builds fixed shop-front street plates (day/night driven by scene script).


static func build(parent: Node2D) -> Dictionary:
	var sky := PlateUtil.rect(parent, "Sky", Vector2(0, 0), Vector2(1280, 320), ArtPalette.COOL_SKY_DAY, 0)

	var far := Node2D.new()
	far.name = "LayerFar"
	parent.add_child(far)
	_build_far(far)

	var mid := Node2D.new()
	mid.name = "LayerMid"
	parent.add_child(mid)
	_build_mid(mid)

	var near := Node2D.new()
	near.name = "LayerNear"
	parent.add_child(near)
	_build_near(near)

	var night_glows := Node2D.new()
	night_glows.name = "NightGlows"
	night_glows.visible = false
	parent.add_child(night_glows)
	_build_night_glows(night_glows)

	return {"sky": sky, "night_glows": night_glows}


static func _build_far(layer: Node2D) -> void:
	PlateUtil.rect(layer, "NeighborA", Vector2(780, 120), Vector2(220, 280), ArtPalette.COOL_WALL, 0)
	PlateUtil.poly(
		layer,
		"NeighborARoof",
		PackedVector2Array([
			Vector2(770, 120), Vector2(890, 40), Vector2(1010, 120),
		]),
		ArtPalette.COOL_WALL_DARK,
		1,
	)
	PlateUtil.rect(layer, "NeighborB", Vector2(980, 150), Vector2(300, 270), ArtPalette.COOL_STONE, 0)
	PlateUtil.poly(
		layer,
		"NeighborBRoof",
		PackedVector2Array([
			Vector2(970, 150), Vector2(1130, 55), Vector2(1290, 150),
		]),
		Color(0.22, 0.26, 0.40, 1.0),
		1,
	)
	PlateUtil.rect(layer, "DistantBanner", Vector2(860, 180), Vector2(90, 50), ArtPalette.COOL_WINDOW, 2)


static func _build_mid(layer: Node2D) -> void:
	PlateUtil.rect(layer, "Street", Vector2(0, 400), Vector2(1280, 320), ArtPalette.FLOOR, 0)
	for i in 10:
		var y := 420.0 + float(i) * 28.0
		PlateUtil.rect(layer, "StreetLine_%d" % i, Vector2(0, y), Vector2(1280, 6), ArtPalette.FLOOR_DARK, 1)

	PlateUtil.rect(layer, "FacadeStone", Vector2(40, 180), Vector2(520, 280), ArtPalette.COOL_STONE_LIGHT, 2)
	PlateUtil.rect(layer, "FacadeTimber", Vector2(60, 80), Vector2(480, 120), ArtPalette.WARM_PLASTER, 3)
	PlateUtil.rect(layer, "BeamH1", Vector2(60, 80), Vector2(480, 14), ArtPalette.WARM_WOOD_DARK, 4)
	PlateUtil.rect(layer, "BeamH2", Vector2(60, 140), Vector2(480, 12), ArtPalette.WARM_WOOD_DARK, 4)
	PlateUtil.rect(layer, "BeamV1", Vector2(60, 80), Vector2(14, 120), ArtPalette.WARM_WOOD_DARK, 4)
	PlateUtil.rect(layer, "BeamV2", Vector2(290, 80), Vector2(14, 120), ArtPalette.WARM_WOOD_DARK, 4)
	PlateUtil.rect(layer, "BeamV3", Vector2(526, 80), Vector2(14, 120), ArtPalette.WARM_WOOD_DARK, 4)

	PlateUtil.poly(
		layer,
		"Roof",
		PackedVector2Array([
			Vector2(20, 90), Vector2(300, 10), Vector2(580, 90),
			Vector2(560, 110), Vector2(300, 40), Vector2(40, 110),
		]),
		Color(0.18, 0.22, 0.38, 1.0),
		5,
	)

	PlateUtil.poly(
		layer,
		"DoorArch",
		PackedVector2Array([
			Vector2(160, 260), Vector2(300, 250), Vector2(310, 460),
			Vector2(150, 460),
		]),
		ArtPalette.COOL_WALL_DARK,
		5,
	)
	PlateUtil.rect(layer, "Door", Vector2(175, 280), Vector2(120, 180), ArtPalette.WARM_WOOD_DARK, 6)
	PlateUtil.rect(layer, "DoorWindow", Vector2(215, 310), Vector2(40, 40), ArtPalette.COOL_WINDOW, 7)

	PlateUtil.rect(layer, "PorchPostL", Vector2(420, 250), Vector2(22, 210), ArtPalette.WARM_WOOD, 5)
	PlateUtil.rect(layer, "PorchPostR", Vector2(560, 250), Vector2(22, 210), ArtPalette.WARM_WOOD, 5)
	PlateUtil.rect(layer, "PorchRoof", Vector2(400, 230), Vector2(200, 28), ArtPalette.WARM_WOOD_DARK, 6)
	PlateUtil.rect(layer, "ForgeMouth", Vector2(450, 290), Vector2(110, 100), ArtPalette.SHADOW, 6)
	PlateUtil.ellipse(layer, "ForgeDayGlow", Vector2(505, 340), Vector2(40, 28), ArtPalette.WARM_EMBER, 7)

	PlateUtil.ellipse(layer, "AnvilStump", Vector2(505, 430), Vector2(40, 22), ArtPalette.WARM_WOOD_DARK, 7)
	PlateUtil.rect(layer, "Anvil", Vector2(475, 395), Vector2(60, 30), ArtPalette.METAL, 8)

	PlateUtil.rect(layer, "SignArm", Vector2(300, 150), Vector2(120, 12), ArtPalette.WARM_WOOD_DARK, 8)
	PlateUtil.rect(layer, "SignBoard", Vector2(380, 155), Vector2(90, 70), ArtPalette.SIGN_FACE, 9)
	PlateUtil.poly(
		layer,
		"SignHammer",
		PackedVector2Array([
			Vector2(410, 175), Vector2(440, 175), Vector2(438, 210),
			Vector2(412, 210),
		]),
		ArtPalette.WARM_PLASTER,
		10,
	)
	PlateUtil.rect(layer, "SignHead", Vector2(400, 170), Vector2(50, 16), ArtPalette.WARM_PLASTER, 11)


static func _build_near(layer: Node2D) -> void:
	PlateUtil.ellipse(layer, "Barrel1", Vector2(120, 500), Vector2(40, 50), ArtPalette.WARM_WOOD, 0)
	PlateUtil.ellipse(layer, "Barrel2", Vector2(190, 510), Vector2(36, 45), ArtPalette.WARM_WOOD_DARK, 0)
	PlateUtil.rect(layer, "Crate", Vector2(250, 480), Vector2(70, 55), ArtPalette.WARM_WOOD, 1)
	PlateUtil.ellipse(layer, "WagonWheel", Vector2(620, 470), Vector2(45, 45), ArtPalette.WARM_WOOD_DARK, 1)
	PlateUtil.ellipse(layer, "WagonWheelInner", Vector2(620, 470), Vector2(18, 18), ArtPalette.FLOOR_DARK, 2)
	PlateUtil.rect(layer, "Curb", Vector2(0, 455), Vector2(700, 12), ArtPalette.COOL_STONE, 0)


static func _build_night_glows(layer: Node2D) -> void:
	PlateUtil.ellipse(layer, "ForgeSpill", Vector2(505, 360), Vector2(120, 90), Color(1.0, 0.45, 0.12, 0.55), 20)
	PlateUtil.ellipse(layer, "DoorGlow", Vector2(235, 360), Vector2(55, 80), Color(1.0, 0.55, 0.2, 0.35), 20)
	PlateUtil.rect(layer, "WindowWarm1", Vector2(100, 100), Vector2(50, 40), Color(1.0, 0.6, 0.25, 0.7), 20)
	PlateUtil.rect(layer, "WindowWarm2", Vector2(360, 100), Vector2(50, 40), Color(1.0, 0.55, 0.2, 0.55), 20)
	PlateUtil.rect(layer, "NeighborWindow", Vector2(1040, 200), Vector2(36, 30), Color(1.0, 0.5, 0.18, 0.5), 20)
	PlateUtil.ellipse(layer, "StreetLanternGlow", Vector2(700, 380), Vector2(50, 40), Color(1.0, 0.7, 0.3, 0.35), 20)
	PlateUtil.rect(layer, "LanternPost", Vector2(692, 300), Vector2(10, 100), ArtPalette.WARM_WOOD_DARK, 19)
	PlateUtil.rect(layer, "Lantern", Vector2(680, 285), Vector2(34, 28), ArtPalette.WARM_EMBER_CORE, 20)
