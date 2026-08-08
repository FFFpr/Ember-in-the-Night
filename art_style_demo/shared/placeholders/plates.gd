class_name ArtDemoPlates
extends RefCounted

## Builds shared workshop / street placeholder plates for approaches 01 and 02.


static func poly(parent: Node, name: String, points: PackedVector2Array, color: Color, z: int = 0) -> Polygon2D:
	var node := Polygon2D.new()
	node.name = name
	node.polygon = points
	node.color = color
	node.z_index = z
	parent.add_child(node)
	return node


static func rect_poly(origin: Vector2, size: Vector2) -> PackedVector2Array:
	return PackedVector2Array([
		origin,
		origin + Vector2(size.x, 0),
		origin + size,
		origin + Vector2(0, size.y),
	])


static func build_workshop(root: Node2D) -> Dictionary:
	var far := Node2D.new()
	far.name = "LayerFar"
	root.add_child(far)

	var mid := Node2D.new()
	mid.name = "LayerMid"
	root.add_child(mid)

	var near := Node2D.new()
	near.name = "LayerNear"
	root.add_child(near)

	# Back wall + floor plane (FP bench framing).
	poly(far, "BackWall", rect_poly(Vector2(0, 0), Vector2(1280, 430)), ArtDemoPalette.STONE_DARK, 0)
	poly(far, "Floor", PackedVector2Array([
		Vector2(0, 420), Vector2(1280, 420), Vector2(1280, 720), Vector2(0, 720),
	]), ArtDemoPalette.STONE, 1)
	poly(far, "FloorPerspective", PackedVector2Array([
		Vector2(180, 420), Vector2(1100, 420), Vector2(1280, 720), Vector2(0, 720),
	]), ArtDemoPalette.COBBLE, 2)

	# Cool window (left).
	poly(far, "WindowFrame", rect_poly(Vector2(70, 120), Vector2(150, 190)), ArtDemoPalette.WOOD_DARK, 3)
	var window_pane := poly(far, "WindowPane", rect_poly(Vector2(85, 135), Vector2(120, 160)), Color("1a3048"), 4)
	poly(far, "WindowMullionV", rect_poly(Vector2(140, 135), Vector2(8, 160)), ArtDemoPalette.WOOD, 5)
	poly(far, "WindowMullionH", rect_poly(Vector2(85, 210), Vector2(120, 8)), ArtDemoPalette.WOOD, 5)

	# Forge mouth (warm key).
	poly(far, "ForgeStone", PackedVector2Array([
		Vector2(470, 180), Vector2(810, 180), Vector2(830, 430), Vector2(450, 430),
	]), ArtDemoPalette.STONE, 3)
	poly(far, "ForgeArch", PackedVector2Array([
		Vector2(520, 230), Vector2(760, 230), Vector2(780, 410), Vector2(500, 410),
	]), ArtDemoPalette.WOOD_DARK, 4)
	var forge_fire := poly(far, "ForgeFire", PackedVector2Array([
		Vector2(545, 270), Vector2(735, 270), Vector2(750, 400), Vector2(530, 400),
	]), ArtDemoPalette.EMBER, 5)
	poly(far, "ForgeCore", PackedVector2Array([
		Vector2(585, 300), Vector2(695, 300), Vector2(705, 385), Vector2(575, 385),
	]), ArtDemoPalette.EMBER_CORE, 6)
	var forge_glow := poly(far, "ForgeGlow", PackedVector2Array([
		Vector2(480, 250), Vector2(800, 250), Vector2(860, 450), Vector2(420, 450),
	]), ArtDemoPalette.FORGE_GLOW, 2)

	# Rafters / ceiling mass.
	poly(far, "RafterL", PackedVector2Array([
		Vector2(-20, -10), Vector2(520, 90), Vector2(500, 130), Vector2(-20, 40),
	]), ArtDemoPalette.WOOD_DARK, 7)
	poly(far, "RafterR", PackedVector2Array([
		Vector2(760, 90), Vector2(1300, -10), Vector2(1300, 40), Vector2(780, 130),
	]), ArtDemoPalette.WOOD_DARK, 7)
	poly(far, "BeamCenter", rect_poly(Vector2(560, 40), Vector2(160, 36)), ArtDemoPalette.WOOD, 7)

	# Mid props: anvil, bellows, barrel, racks, ore, horseshoes.
	# Anvil sits forward of the forge mouth so the silhouette reads in FP.
	poly(mid, "AnvilBase", PackedVector2Array([
		Vector2(500, 520), Vector2(780, 520), Vector2(800, 620), Vector2(480, 620),
	]), ArtDemoPalette.WOOD_LIGHT, 1)
	poly(mid, "AnvilBody", PackedVector2Array([
		Vector2(530, 470), Vector2(750, 470), Vector2(770, 520), Vector2(510, 520),
	]), ArtDemoPalette.METAL_DARK, 2)
	poly(mid, "AnvilTop", PackedVector2Array([
		Vector2(520, 445), Vector2(760, 445), Vector2(750, 480), Vector2(530, 480),
	]), Color("8a8e92"), 3)
	poly(mid, "AnvilHorn", PackedVector2Array([
		Vector2(760, 450), Vector2(860, 475), Vector2(760, 490),
	]), Color("8a8e92"), 3)
	poly(mid, "AnvilHeel", PackedVector2Array([
		Vector2(490, 450), Vector2(530, 450), Vector2(530, 495), Vector2(475, 485),
	]), ArtDemoPalette.METAL_DARK, 3)

	poly(mid, "Bellows", PackedVector2Array([
		Vector2(860, 340), Vector2(1060, 310), Vector2(1100, 460), Vector2(880, 500),
	]), ArtDemoPalette.WOOD_LIGHT, 1)
	poly(mid, "BellowsLeather", PackedVector2Array([
		Vector2(885, 365), Vector2(1035, 340), Vector2(1065, 440), Vector2(900, 475),
	]), Color("6a4028"), 2)
	poly(mid, "BellowsNozzle", PackedVector2Array([
		Vector2(820, 390), Vector2(885, 385), Vector2(890, 420), Vector2(825, 425),
	]), ArtDemoPalette.METAL, 3)

	poly(mid, "QuenchBarrel", PackedVector2Array([
		Vector2(150, 430), Vector2(330, 430), Vector2(355, 620), Vector2(125, 620),
	]), ArtDemoPalette.WOOD, 1)
	poly(mid, "QuenchBand", rect_poly(Vector2(145, 520), Vector2(195, 16)), ArtDemoPalette.METAL, 2)
	poly(mid, "QuenchBand2", rect_poly(Vector2(140, 570), Vector2(200, 14)), ArtDemoPalette.METAL, 2)
	poly(mid, "QuenchWater", PackedVector2Array([
		Vector2(170, 450), Vector2(315, 450), Vector2(325, 510), Vector2(160, 510),
	]), Color("4a7a8a"), 2)

	poly(mid, "ToolRack", rect_poly(Vector2(980, 160), Vector2(220, 18)), ArtDemoPalette.WOOD, 1)
	for i in 4:
		var x := 1000.0 + i * 48.0
		poly(mid, "Hammer%d" % i, PackedVector2Array([
			Vector2(x, 178), Vector2(x + 14, 178), Vector2(x + 14, 320), Vector2(x, 320),
		]), ArtDemoPalette.WOOD_LIGHT if i % 2 == 0 else ArtDemoPalette.METAL, 2)
		poly(mid, "HammerHead%d" % i, rect_poly(Vector2(x - 10, 178), Vector2(34, 22)), ArtDemoPalette.METAL_DARK, 3)

	poly(mid, "OrePile", PackedVector2Array([
		Vector2(360, 520), Vector2(470, 505), Vector2(500, 560), Vector2(350, 570),
	]), Color("4a3a2a"), 1)
	poly(mid, "IngotA", rect_poly(Vector2(380, 530), Vector2(50, 16)), ArtDemoPalette.METAL, 2)
	poly(mid, "IngotB", rect_poly(Vector2(420, 545), Vector2(55, 16)), ArtDemoPalette.METAL_DARK, 2)

	for i in 3:
		var hx := 260.0 + i * 42.0
		poly(mid, "Horseshoe%d" % i, PackedVector2Array([
			Vector2(hx, 205), Vector2(hx + 10, 200), Vector2(hx + 20, 205),
			Vector2(hx + 24, 245), Vector2(hx + 16, 252), Vector2(hx + 12, 228),
			Vector2(hx + 8, 228), Vector2(hx + 4, 252), Vector2(hx - 4, 245),
		]), ArtDemoPalette.METAL, 2)

	# Near: hanging tools / frame / bench edge (FP foreground).
	poly(near, "LeftPost", rect_poly(Vector2(0, 0), Vector2(55, 720)), ArtDemoPalette.WOOD_DARK, 1)
	poly(near, "RightPost", rect_poly(Vector2(1225, 0), Vector2(55, 720)), ArtDemoPalette.WOOD_DARK, 1)
	poly(near, "TopBeam", rect_poly(Vector2(0, 0), Vector2(1280, 48)), ArtDemoPalette.WOOD_DARK, 2)
	poly(near, "HangingTong", PackedVector2Array([
		Vector2(900, 48), Vector2(912, 48), Vector2(920, 210), Vector2(892, 210),
	]), ArtDemoPalette.METAL, 3)
	poly(near, "BenchEdge", PackedVector2Array([
		Vector2(80, 640), Vector2(1200, 640), Vector2(1280, 720), Vector2(0, 720),
	]), ArtDemoPalette.WOOD, 4)
	poly(near, "GloveHintL", PackedVector2Array([
		Vector2(220, 660), Vector2(320, 650), Vector2(340, 720), Vector2(200, 720),
	]), Color("6a4a30"), 5)
	poly(near, "GloveHintR", PackedVector2Array([
		Vector2(900, 655), Vector2(1040, 645), Vector2(1060, 720), Vector2(880, 720),
	]), Color("6a4a30"), 5)
	poly(near, "HammerHint", PackedVector2Array([
		Vector2(980, 620), Vector2(1100, 600), Vector2(1110, 625), Vector2(990, 645),
	]), ArtDemoPalette.METAL_DARK, 6)

	return {
		"far": far,
		"mid": mid,
		"near": near,
		"forge_fire": forge_fire,
		"forge_glow": forge_glow,
		"window_pane": window_pane,
	}


static func build_street(root: Node2D) -> Dictionary:
	var sky := poly(root, "Sky", rect_poly(Vector2(0, 0), Vector2(1280, 720)), ArtDemoPalette.SKY_DAY, -10)

	var far := Node2D.new()
	far.name = "LayerFar"
	root.add_child(far)

	var mid := Node2D.new()
	mid.name = "LayerMid"
	root.add_child(mid)

	var near := Node2D.new()
	near.name = "LayerNear"
	root.add_child(near)

	# Neighboring masses.
	poly(far, "NeighborL", PackedVector2Array([
		Vector2(-40, 180), Vector2(260, 160), Vector2(280, 520), Vector2(-40, 540),
	]), ArtDemoPalette.STONE_DARK, 0)
	poly(far, "NeighborLRoof", PackedVector2Array([
		Vector2(-60, 180), Vector2(110, 90), Vector2(280, 160),
	]), ArtDemoPalette.ROOF, 1)
	poly(far, "NeighborR", PackedVector2Array([
		Vector2(980, 150), Vector2(1320, 130), Vector2(1320, 560), Vector2(1000, 540),
	]), ArtDemoPalette.STONE_DARK, 0)
	poly(far, "NeighborRRoof", PackedVector2Array([
		Vector2(960, 150), Vector2(1140, 70), Vector2(1340, 130),
	]), ArtDemoPalette.ROOF, 1)
	poly(far, "Banner", rect_poly(Vector2(620, 140), Vector2(40, 90)), Color("3a5a7a"), 2)

	# Road / cobbles.
	poly(far, "Road", PackedVector2Array([
		Vector2(0, 500), Vector2(1280, 480), Vector2(1280, 720), Vector2(0, 720),
	]), ArtDemoPalette.COBBLE, 1)
	for i in 8:
		var cx := 80.0 + i * 150.0
		poly(far, "Cobble%d" % i, PackedVector2Array([
			Vector2(cx, 560 + (i % 3) * 20),
			Vector2(cx + 70, 555 + (i % 3) * 20),
			Vector2(cx + 65, 590 + (i % 3) * 20),
			Vector2(cx - 5, 595 + (i % 3) * 20),
		]), ArtDemoPalette.COBBLE_LIGHT if i % 2 == 0 else ArtDemoPalette.DIRT, 2)

	# Smithy facade (shop-front framing).
	poly(mid, "FacadeStone", PackedVector2Array([
		Vector2(320, 200), Vector2(920, 190), Vector2(940, 560), Vector2(300, 570),
	]), ArtDemoPalette.STONE, 0)
	poly(mid, "FacadeTimber", PackedVector2Array([
		Vector2(340, 200), Vector2(900, 192), Vector2(900, 320), Vector2(340, 330),
	]), ArtDemoPalette.PLASTER, 1)
	poly(mid, "TimberBeamH", rect_poly(Vector2(340, 250), Vector2(560, 16)), ArtDemoPalette.WOOD_DARK, 2)
	poly(mid, "TimberBeamV1", rect_poly(Vector2(480, 200), Vector2(16, 130)), ArtDemoPalette.WOOD_DARK, 2)
	poly(mid, "TimberBeamV2", rect_poly(Vector2(700, 198), Vector2(16, 130)), ArtDemoPalette.WOOD_DARK, 2)
	poly(mid, "Roof", PackedVector2Array([
		Vector2(280, 210), Vector2(620, 80), Vector2(980, 200), Vector2(940, 230), Vector2(620, 120), Vector2(320, 235),
	]), ArtDemoPalette.ROOF, 3)

	# Door + open forge bay.
	poly(mid, "DoorRecess", PackedVector2Array([
		Vector2(355, 350), Vector2(510, 345), Vector2(515, 565), Vector2(350, 570),
	]), ArtDemoPalette.WOOD_DARK, 3)
	poly(mid, "Door", PackedVector2Array([
		Vector2(370, 365), Vector2(495, 360), Vector2(498, 555), Vector2(367, 560),
	]), ArtDemoPalette.WOOD, 4)
	poly(mid, "DoorArch", PackedVector2Array([
		Vector2(370, 365), Vector2(432, 315), Vector2(495, 360),
	]), ArtDemoPalette.WOOD_LIGHT, 5)
	poly(mid, "DoorHandle", rect_poly(Vector2(455, 450), Vector2(18, 18)), ArtDemoPalette.METAL, 6)
	var door_glow := poly(mid, "DoorGlow", PackedVector2Array([
		Vector2(380, 380), Vector2(485, 375), Vector2(488, 540), Vector2(378, 545),
	]), ArtDemoPalette.WINDOW_GLOW, 5)
	door_glow.visible = false

	poly(mid, "ForgeBay", PackedVector2Array([
		Vector2(560, 340), Vector2(860, 330), Vector2(870, 555), Vector2(550, 560),
	]), ArtDemoPalette.WOOD_DARK, 3)
	var street_fire := poly(mid, "StreetForgeFire", PackedVector2Array([
		Vector2(620, 390), Vector2(800, 385), Vector2(810, 520), Vector2(610, 525),
	]), ArtDemoPalette.EMBER, 4)
	poly(mid, "StreetAnvilBase", PackedVector2Array([
		Vector2(670, 515), Vector2(800, 510), Vector2(810, 560), Vector2(660, 565),
	]), ArtDemoPalette.WOOD, 5)
	poly(mid, "StreetAnvil", PackedVector2Array([
		Vector2(685, 490), Vector2(790, 485), Vector2(800, 520), Vector2(675, 525),
	]), ArtDemoPalette.METAL, 6)
	var forge_spill := poly(mid, "ForgeSpill", PackedVector2Array([
		Vector2(540, 450), Vector2(900, 440), Vector2(960, 620), Vector2(480, 630),
	]), ArtDemoPalette.FORGE_GLOW, 2)

	# Sign, barrels, crates, wheel.
	poly(mid, "SignBracket", rect_poly(Vector2(430, 270), Vector2(110, 12)), ArtDemoPalette.WOOD_DARK, 6)
	poly(mid, "Sign", PackedVector2Array([
		Vector2(500, 282), Vector2(610, 282), Vector2(610, 370), Vector2(555, 395), Vector2(500, 370),
	]), ArtDemoPalette.WOOD_LIGHT, 6)
	poly(mid, "SignHammer", PackedVector2Array([
		Vector2(530, 310), Vector2(580, 310), Vector2(580, 330), Vector2(560, 330),
		Vector2(560, 355), Vector2(550, 355), Vector2(550, 330), Vector2(530, 330),
	]), ArtDemoPalette.METAL_DARK, 7)

	poly(mid, "BarrelA", PackedVector2Array([
		Vector2(230, 490), Vector2(320, 485), Vector2(335, 595), Vector2(215, 600),
	]), ArtDemoPalette.WOOD, 4)
	poly(mid, "BarrelABand", rect_poly(Vector2(225, 540), Vector2(105, 12)), ArtDemoPalette.METAL, 5)
	poly(mid, "BarrelB", PackedVector2Array([
		Vector2(880, 500), Vector2(980, 495), Vector2(995, 605), Vector2(865, 610),
	]), ArtDemoPalette.WOOD_LIGHT, 4)
	poly(mid, "Crate", rect_poly(Vector2(170, 545), Vector2(85, 60)), ArtDemoPalette.WOOD_DARK, 4)
	poly(mid, "Wheel", PackedVector2Array([
		Vector2(120, 510), Vector2(200, 510), Vector2(210, 600), Vector2(110, 600),
	]), ArtDemoPalette.WOOD, 4)
	poly(mid, "WheelHub", rect_poly(Vector2(150, 540), Vector2(30, 30)), ArtDemoPalette.METAL_DARK, 5)

	# Night-only window glow on upper facade.
	var window_glow := poly(mid, "UpperWindowGlow", rect_poly(Vector2(760, 220), Vector2(70, 55)), ArtDemoPalette.WINDOW_GLOW, 5)
	window_glow.visible = false
	poly(mid, "UpperWindow", rect_poly(Vector2(765, 225), Vector2(60, 45)), Color("2a3a4a"), 6)

	var lantern := poly(near, "Lantern", PackedVector2Array([
		Vector2(160, 360), Vector2(200, 360), Vector2(205, 420), Vector2(155, 420),
	]), ArtDemoPalette.METAL, 1)
	var lantern_glow := poly(near, "LanternGlow", PackedVector2Array([
		Vector2(140, 380), Vector2(220, 380), Vector2(240, 520), Vector2(120, 520),
	]), ArtDemoPalette.GLOW_WARM, 0)
	lantern_glow.visible = false

	return {
		"sky": sky,
		"far": far,
		"mid": mid,
		"near": near,
		"door_glow": door_glow,
		"forge_spill": forge_spill,
		"street_fire": street_fire,
		"window_glow": window_glow,
		"lantern": lantern,
		"lantern_glow": lantern_glow,
	}
