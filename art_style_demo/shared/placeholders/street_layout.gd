class_name StreetLayout
extends RefCounted
## Shop-front street using Kenney buildings + Poly Haven ground/props.


static func build(parent: Node2D) -> Dictionary:
	var sky := PlateUtil.rect(parent, "Sky", Vector2(0, 0), Vector2(1280, 420), ArtPalette.COOL_SKY_DAY, 0)

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
	var cloud := DemoAssets.tex(DemoAssets.CLOUD_1)
	var cloud2 := DemoAssets.tex(DemoAssets.CLOUD_3)
	var sun := DemoAssets.tex(DemoAssets.SUN)
	var tower := DemoAssets.tex(DemoAssets.TOWER)
	var tower_alt := DemoAssets.tex(DemoAssets.TOWER_ALT)
	var house_small := DemoAssets.tex(DemoAssets.HOUSE_SMALL)

	if sun:
		PlateUtil.sprite(layer, "Sun", sun, Vector2(1080, 90), Vector2(0.35, 0.35), 0, Color(1, 1, 1, 0.9))
	if cloud:
		PlateUtil.sprite(layer, "CloudA", cloud, Vector2(220, 80), Vector2(0.45, 0.45), 1, Color(1, 1, 1, 0.75))
	if cloud2:
		PlateUtil.sprite(layer, "CloudB", cloud2, Vector2(720, 60), Vector2(0.4, 0.4), 1, Color(1, 1, 1, 0.65))

	if tower:
		PlateUtil.sprite(layer, "NeighborTower", tower, Vector2(980, 250), Vector2(0.55, 0.55), 2)
	if tower_alt:
		PlateUtil.sprite(layer, "NeighborTowerAlt", tower_alt, Vector2(1180, 280), Vector2(0.45, 0.45), 2, Color(0.85, 0.88, 0.95))
	if house_small:
		PlateUtil.sprite(layer, "NeighborHouse", house_small, Vector2(820, 300), Vector2(0.7, 0.7), 3)


static func _build_mid(layer: Node2D) -> void:
	var cobble := DemoAssets.tex(DemoAssets.COBBLE)
	var wood := DemoAssets.tex(DemoAssets.WOOD)
	var wood_dark := DemoAssets.tex(DemoAssets.WOOD_DARK)
	var brick := DemoAssets.tex(DemoAssets.BRICK)
	var metal := DemoAssets.tex(DemoAssets.METAL)
	var roof := DemoAssets.tex(DemoAssets.ROOF)
	var house1 := DemoAssets.tex(DemoAssets.HOUSE_1)
	var house2 := DemoAssets.tex(DemoAssets.HOUSE_2)
	var house_alt := DemoAssets.tex(DemoAssets.HOUSE_ALT_1)
	var fence := DemoAssets.tex(DemoAssets.FENCE)
	var castle_wall := DemoAssets.tex(DemoAssets.CASTLE_WALL)

	PlateUtil.textured_rect(layer, "Street", Vector2(0, 400), Vector2(1280, 320), cobble, 0, Color(0.7, 0.72, 0.78), 0.003)

	# Smithy: Kenney house as main facade + textured porch/forge
	if house1:
		PlateUtil.sprite(layer, "FacadeHouse", house1, Vector2(280, 250), Vector2(1.15, 1.15), 2)
	if castle_wall:
		PlateUtil.sprite(layer, "FacadeStoneBase", castle_wall, Vector2(250, 390), Vector2(0.9, 0.55), 1, Color(0.85, 0.85, 0.9))

	# Neighbor facade hint
	if house_alt:
		PlateUtil.sprite(layer, "SideHouse", house_alt, Vector2(620, 280), Vector2(0.75, 0.75), 2, Color(0.9, 0.92, 0.98))
	if house2:
		PlateUtil.sprite(layer, "FarHouse", house2, Vector2(1100, 300), Vector2(0.65, 0.65), 1, Color(0.8, 0.84, 0.95))

	# Door / porch forge bay (textured props in front of house sprite)
	PlateUtil.textured_rect(layer, "Door", Vector2(175, 300), Vector2(100, 160), wood_dark, 5, Color(0.55, 0.4, 0.25), 0.01)
	PlateUtil.rect(layer, "DoorWindow", Vector2(210, 330), Vector2(30, 30), ArtPalette.COOL_WINDOW, 6)

	PlateUtil.textured_rect(layer, "PorchPostL", Vector2(420, 250), Vector2(22, 210), wood, 5, Color(0.75, 0.6, 0.4), 0.02)
	PlateUtil.textured_rect(layer, "PorchPostR", Vector2(560, 250), Vector2(22, 210), wood, 5, Color(0.75, 0.6, 0.4), 0.02)
	PlateUtil.textured_rect(layer, "PorchRoof", Vector2(400, 230), Vector2(200, 28), roof, 6, Color(0.45, 0.5, 0.7), 0.01)
	PlateUtil.textured_rect(layer, "ForgeMouth", Vector2(450, 290), Vector2(110, 100), wood_dark, 6, Color(0.15, 0.12, 0.1), 0.01)
	PlateUtil.ellipse(layer, "ForgeDayGlow", Vector2(505, 340), Vector2(40, 28), ArtPalette.WARM_EMBER, 7)
	var flash := DemoAssets.tex(DemoAssets.FLASH)
	if flash:
		PlateUtil.sprite(layer, "ForgeFlash", flash, Vector2(505, 335), Vector2(0.28, 0.22), 8, Color(1.0, 0.5, 0.15, 0.9))

	PlateUtil.textured_poly(layer, "AnvilStump", _ellipse_pts(Vector2(505, 430), Vector2(40, 22)), wood_dark, 7, Color(0.65, 0.5, 0.3), 0.02)
	PlateUtil.textured_rect(layer, "Anvil", Vector2(475, 395), Vector2(60, 30), metal, 8, Color(0.4, 0.42, 0.48), 0.02)

	# Hanging sign
	PlateUtil.textured_rect(layer, "SignArm", Vector2(300, 150), Vector2(120, 12), wood_dark, 8, Color.WHITE, 0.02)
	PlateUtil.textured_rect(layer, "SignBoard", Vector2(380, 155), Vector2(90, 70), wood_dark, 9, Color(0.45, 0.3, 0.18), 0.015)
	PlateUtil.textured_rect(layer, "SignHammer", Vector2(412, 175), Vector2(26, 35), metal, 10, Color(0.85, 0.88, 0.95), 0.04)
	PlateUtil.textured_rect(layer, "SignHead", Vector2(400, 170), Vector2(50, 16), metal, 11, Color(0.9, 0.92, 0.98), 0.04)

	if fence:
		PlateUtil.sprite(layer, "Fence", fence, Vector2(750, 430), Vector2(0.7, 0.7), 4, Color(0.85, 0.85, 0.9))


static func _build_near(layer: Node2D) -> void:
	var wood := DemoAssets.tex(DemoAssets.WOOD)
	var wood_dark := DemoAssets.tex(DemoAssets.WOOD_DARK)
	var tree := DemoAssets.tex(DemoAssets.TREE)

	PlateUtil.textured_poly(layer, "Barrel1", _ellipse_pts(Vector2(120, 500), Vector2(40, 50)), wood, 0, Color(0.8, 0.65, 0.45), 0.015)
	PlateUtil.textured_poly(layer, "Barrel2", _ellipse_pts(Vector2(190, 510), Vector2(36, 45)), wood_dark, 0, Color(0.65, 0.5, 0.32), 0.015)
	PlateUtil.textured_rect(layer, "Crate", Vector2(250, 480), Vector2(70, 55), wood, 1, Color(0.75, 0.6, 0.4), 0.015)
	PlateUtil.textured_poly(layer, "WagonWheel", _ellipse_pts(Vector2(620, 470), Vector2(45, 45)), wood_dark, 1, Color(0.55, 0.4, 0.25), 0.02)
	PlateUtil.ellipse(layer, "WagonWheelInner", Vector2(620, 470), Vector2(18, 18), ArtPalette.FLOOR_DARK, 2)
	PlateUtil.textured_rect(layer, "Curb", Vector2(0, 455), Vector2(700, 12), DemoAssets.tex(DemoAssets.BRICK), 0, Color(0.7, 0.7, 0.75), 0.02)

	if tree:
		PlateUtil.sprite(layer, "TreeEdge", tree, Vector2(1220, 360), Vector2(0.55, 0.55), 3, Color(0.85, 0.9, 0.95))


static func _build_night_glows(layer: Node2D) -> void:
	var moon := DemoAssets.tex(DemoAssets.MOON)
	var puff := DemoAssets.tex(DemoAssets.PUFF)
	if moon:
		PlateUtil.sprite(layer, "Moon", moon, Vector2(1040, 90), Vector2(0.3, 0.3), 0, Color(0.85, 0.9, 1.0, 0.95))

	PlateUtil.ellipse(layer, "ForgeSpill", Vector2(505, 360), Vector2(120, 90), Color(1.0, 0.45, 0.12, 0.55), 20)
	PlateUtil.ellipse(layer, "DoorGlow", Vector2(225, 360), Vector2(55, 80), Color(1.0, 0.55, 0.2, 0.35), 20)
	PlateUtil.rect(layer, "WindowWarm1", Vector2(200, 180), Vector2(50, 40), Color(1.0, 0.6, 0.25, 0.75), 20)
	PlateUtil.rect(layer, "WindowWarm2", Vector2(320, 180), Vector2(50, 40), Color(1.0, 0.55, 0.2, 0.6), 20)
	PlateUtil.rect(layer, "NeighborWindow", Vector2(1080, 220), Vector2(36, 30), Color(1.0, 0.5, 0.18, 0.55), 20)
	if puff:
		PlateUtil.sprite(layer, "LanternGlow", puff, Vector2(700, 340), Vector2(0.35, 0.35), 19, Color(1.0, 0.65, 0.25, 0.55))
	PlateUtil.textured_rect(layer, "LanternPost", Vector2(692, 300), Vector2(10, 100), DemoAssets.tex(DemoAssets.WOOD_DARK), 19, Color.WHITE, 0.05)
	PlateUtil.rect(layer, "Lantern", Vector2(680, 285), Vector2(34, 28), ArtPalette.WARM_EMBER_CORE, 20)


static func _ellipse_pts(center: Vector2, radii: Vector2, segments: int = 16) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in segments:
		var t := TAU * float(i) / float(segments)
		pts.append(center + Vector2(cos(t) * radii.x, sin(t) * radii.y))
	return pts
