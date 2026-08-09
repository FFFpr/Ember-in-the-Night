class_name ArtDemoPlates
extends RefCounted

## Builds shared workshop / street plates from imported free packs (compare pass).


static func poly(parent: Node, name: String, points: PackedVector2Array, color: Color, z: int = 0) -> Polygon2D:
	## Soft accent / glow only — not the main look.
	var node := Polygon2D.new()
	node.name = name
	node.polygon = points
	node.color = color
	node.z_index = z
	parent.add_child(node)
	return node


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

	var tex_rock := ArtDemoAssets.load_tex(ArtDemoAssets.TEX_ROCK)
	var tex_wood := ArtDemoAssets.load_tex(ArtDemoAssets.TEX_WOOD)
	var tex_metal := ArtDemoAssets.load_tex(ArtDemoAssets.TEX_METAL)

	# Soft illustrative plates (ambientCG albedo).
	ArtDemoAssets.textured_rect(far, "BackWall", tex_rock, Rect2(0, 0, 1280, 430), Color(0.55, 0.58, 0.65), 0)
	ArtDemoAssets.textured_rect(far, "Floor", tex_wood, Rect2(0, 400, 1280, 320), Color(0.7, 0.55, 0.4), 1)

	# Cool window.
	var win := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/window_int.png")
	ArtDemoAssets.sprite(far, "Window", win, Vector2(160, 220), Vector2(1.6, 1.6), 3)
	poly(far, "WindowNightHint", PackedVector2Array([
		Vector2(110, 170), Vector2(210, 170), Vector2(210, 270), Vector2(110, 270),
	]), Color(0.15, 0.25, 0.4, 0.35), 2)

	# Hero forge (LPC blacksmith) + warm glow.
	var forge_tex := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/forge_chimney_big.png")
	var forge := ArtDemoAssets.sprite(far, "Forge", forge_tex, Vector2(640, 300), Vector2(0.95, 0.95), 4)
	var forge_glow := poly(far, "ForgeGlow", PackedVector2Array([
		Vector2(520, 250), Vector2(760, 250), Vector2(800, 430), Vector2(480, 430),
	]), Color(1.0, 0.45, 0.12, 0.22), 3)
	var forge_fire := poly(far, "ForgeFire", PackedVector2Array([
		Vector2(590, 300), Vector2(690, 300), Vector2(700, 380), Vector2(580, 380),
	]), Color(1.0, 0.55, 0.15, 0.2), 5)

	# Secondary kiln for depth.
	var kiln_tex := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/forge_kiln_big.png")
	ArtDemoAssets.sprite(far, "Kiln", kiln_tex, Vector2(980, 310), Vector2(0.55, 0.55), 3)

	# Rafters (wood texture strips).
	ArtDemoAssets.textured_rect(far, "RafterL", tex_wood, Rect2(-20, -10, 560, 90), Color(0.35, 0.22, 0.12), 6)
	ArtDemoAssets.textured_rect(far, "RafterR", tex_wood, Rect2(740, -10, 560, 90), Color(0.35, 0.22, 0.12), 6)
	ArtDemoAssets.textured_rect(far, "BeamCenter", tex_wood, Rect2(560, 40, 160, 36), Color(0.4, 0.25, 0.14), 6)

	# Mid props — LPC + Calciumtrice.
	var anvil_tex := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/anvil.png")
	var anvil := ArtDemoAssets.sprite(mid, "Anvil", anvil_tex, Vector2(640, 500), Vector2(1.8, 1.8), 3)
	ArtDemoAssets.textured_rect(mid, "AnvilBase", tex_wood, Rect2(560, 530, 160, 70), Color(0.55, 0.35, 0.2), 2)

	var bellows_tex := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/bellows_big.png")
	ArtDemoAssets.sprite(mid, "Bellows", bellows_tex, Vector2(920, 430), Vector2(1.1, 1.1), 2)

	var quench_tex := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/quench.png")
	ArtDemoAssets.sprite(mid, "QuenchBarrel", quench_tex, Vector2(250, 500), Vector2(1.0, 1.0), 2)

	var coal_tex := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/coal_big.png")
	ArtDemoAssets.sprite(mid, "CoalPile", coal_tex, Vector2(430, 540), Vector2(1.0, 1.0), 2)

	var bench_tex := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/workbench_big.png")
	ArtDemoAssets.sprite(mid, "ToolBench", bench_tex, Vector2(1080, 480), Vector2(0.85, 0.85), 2)

	var wall_forge := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/forge_wall_lit.png")
	ArtDemoAssets.sprite(mid, "WallForge", wall_forge, Vector2(400, 360), Vector2(1.2, 1.2), 1)

	var tools := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/tools2.png")
	ArtDemoAssets.sprite(mid, "HangingTools", tools, Vector2(300, 250), Vector2(1.4, 1.4), 2)

	# Ore / ingots strip.
	var ore_tex := ArtDemoAssets.load_tex(ArtDemoAssets.ORE + "/ore_chunks_strip.png")
	if ore_tex != null:
		ArtDemoAssets.sprite(mid, "OreStrip", ore_tex, Vector2(480, 580), Vector2(0.55, 0.55), 2)
	var ingot_tex := ArtDemoAssets.load_tex(ArtDemoAssets.ORE + "/ingots_strip.png")
	if ingot_tex != null:
		ArtDemoAssets.sprite(mid, "IngotStrip", ingot_tex, Vector2(700, 575), Vector2(0.45, 0.45), 2)

	# Horseshoes as metal accents.
	for i in 3:
		ArtDemoAssets.textured_rect(mid, "Horseshoe%d" % i, tex_metal, Rect2(240 + i * 40, 200, 28, 36), Color(0.7, 0.7, 0.75), 2)

	# Near frame / bench edge.
	ArtDemoAssets.textured_rect(near, "LeftPost", tex_wood, Rect2(0, 0, 55, 720), Color(0.25, 0.15, 0.08), 1)
	ArtDemoAssets.textured_rect(near, "RightPost", tex_wood, Rect2(1225, 0, 55, 720), Color(0.25, 0.15, 0.08), 1)
	ArtDemoAssets.textured_rect(near, "TopBeam", tex_wood, Rect2(0, 0, 1280, 48), Color(0.25, 0.15, 0.08), 2)
	ArtDemoAssets.textured_rect(near, "BenchEdge", tex_wood, Rect2(80, 640, 1120, 80), Color(0.45, 0.28, 0.14), 4)
	ArtDemoAssets.textured_rect(near, "GloveHintL", tex_wood, Rect2(200, 660, 120, 60), Color(0.5, 0.35, 0.2), 5)
	ArtDemoAssets.textured_rect(near, "GloveHintR", tex_wood, Rect2(900, 655, 140, 65), Color(0.5, 0.35, 0.2), 5)
	ArtDemoAssets.textured_rect(near, "HammerHint", tex_metal, Rect2(980, 620, 120, 30), Color(0.4, 0.42, 0.45), 6)

	return {
		"far": far,
		"mid": mid,
		"near": near,
		"forge": forge,
		"forge_fire": forge_fire,
		"forge_glow": forge_glow,
		"anvil": anvil,
	}


static func build_street(root: Node2D) -> Dictionary:
	var sky := poly(root, "Sky", PackedVector2Array([
		Vector2(0, 0), Vector2(1280, 0), Vector2(1280, 720), Vector2(0, 720),
	]), ArtDemoPalette.SKY_DAY, -10)

	var far := Node2D.new()
	far.name = "LayerFar"
	root.add_child(far)
	var mid := Node2D.new()
	mid.name = "LayerMid"
	root.add_child(mid)
	var near := Node2D.new()
	near.name = "LayerNear"
	root.add_child(near)

	var tex_pave := ArtDemoAssets.load_tex(ArtDemoAssets.TEX_PAVE)
	var tex_rock := ArtDemoAssets.load_tex(ArtDemoAssets.TEX_ROCK2)

	ArtDemoAssets.textured_rect(far, "Road", tex_pave, Rect2(0, 480, 1280, 240), Color(0.75, 0.75, 0.78), 1)

	# Neighbor masses.
	var neighbor := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/stone_neighbor.png")
	ArtDemoAssets.sprite(far, "NeighborL", neighbor, Vector2(120, 340), Vector2(0.7, 0.85), 0)
	ArtDemoAssets.sprite(far, "NeighborR", neighbor, Vector2(1160, 330), Vector2(-0.7, 0.9), 0)

	# Smithy facade (Calciumtrice timber house).
	var facade := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/smithy_facade.png")
	ArtDemoAssets.sprite(mid, "Facade", facade, Vector2(620, 320), Vector2(1.05, 1.0), 1)

	var sign := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/sign_hammer.png")
	ArtDemoAssets.sprite(mid, "Sign", sign, Vector2(520, 260), Vector2(1.2, 1.2), 6)

	# Open forge bay — LPC kiln + Calciumtrice wall forge.
	var kiln := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/forge_kiln_big.png")
	ArtDemoAssets.sprite(mid, "StreetForge", kiln, Vector2(760, 430), Vector2(0.55, 0.55), 3)
	var wall_forge := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/forge_wall_lit.png")
	ArtDemoAssets.sprite(mid, "StreetWallForge", wall_forge, Vector2(680, 400), Vector2(1.1, 1.1), 4)

	var anvil := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/anvil.png")
	ArtDemoAssets.sprite(mid, "StreetAnvil", anvil, Vector2(740, 520), Vector2(1.2, 1.2), 5)

	var street_fire := poly(mid, "StreetForgeFire", PackedVector2Array([
		Vector2(700, 390), Vector2(820, 390), Vector2(830, 500), Vector2(690, 500),
	]), Color(1, 0.5, 0.15, 0.15), 4)
	var forge_spill := poly(mid, "ForgeSpill", PackedVector2Array([
		Vector2(640, 470), Vector2(880, 460), Vector2(920, 580), Vector2(600, 590),
	]), Color(1.0, 0.45, 0.12, 0.2), 2)

	# Door glow (night).
	var door_glow := poly(mid, "DoorGlow", PackedVector2Array([
		Vector2(490, 380), Vector2(550, 375), Vector2(555, 500), Vector2(485, 505),
	]), Color(1.0, 0.7, 0.35, 0.35), 5)
	door_glow.visible = false

	var window_glow := poly(mid, "UpperWindowGlow", PackedVector2Array([
		Vector2(710, 230), Vector2(770, 230), Vector2(770, 270), Vector2(710, 270),
	]), Color(1.0, 0.7, 0.35, 0.4), 5)
	window_glow.visible = false

	# Street props.
	var barrel_a := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/barrel_a.png")
	var barrel_b := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/barrel_b.png")
	ArtDemoAssets.sprite(mid, "BarrelA", barrel_a, Vector2(280, 540), Vector2(1.5, 1.5), 4)
	ArtDemoAssets.sprite(mid, "BarrelB", barrel_b, Vector2(980, 545), Vector2(1.5, 1.5), 4)
	var quench := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/quench.png")
	ArtDemoAssets.sprite(mid, "StreetCrate", quench, Vector2(200, 560), Vector2(0.55, 0.55), 4)

	# Kenney banner / torch accent if present.
	var banner_path := ArtDemoAssets.KENNEY + "/PNG/medievalTile_070.png"
	if ResourceLoader.exists(banner_path):
		var banner := ArtDemoAssets.load_tex(banner_path)
		ArtDemoAssets.sprite(mid, "Banner", banner, Vector2(400, 300), Vector2(1.3, 1.3), 5)

	var flower := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/flowerbox.png")
	ArtDemoAssets.sprite(near, "Flowerbox", flower, Vector2(150, 500), Vector2(1.2, 1.2), 1)

	var lantern := poly(near, "Lantern", PackedVector2Array([
		Vector2(160, 360), Vector2(200, 360), Vector2(205, 420), Vector2(155, 420),
	]), ArtDemoPalette.METAL, 1)
	var lantern_glow := poly(near, "LanternGlow", PackedVector2Array([
		Vector2(140, 380), Vector2(220, 380), Vector2(240, 520), Vector2(120, 520),
	]), ArtDemoPalette.GLOW_WARM, 0)
	lantern_glow.visible = false

	# Distant rock mass for skyline.
	ArtDemoAssets.textured_rect(far, "SkylineTint", tex_rock, Rect2(0, 120, 1280, 200), Color(0.35, 0.4, 0.5, 0.25), -1)

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
