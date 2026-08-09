class_name ArtDemoPlates
extends RefCounted

## Builds workshop / street plates from imported pack sprites.
## Polygon2D is limited to sky wash + soft glow overlays (review bar).


static func poly(parent: Node, name: String, points: PackedVector2Array, color: Color, z: int = 0) -> Polygon2D:
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

	# Floor / wall = authored pack tile panels (not coded prop silhouettes).
	var wall := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/wall_stone_panel.png")
	ArtDemoAssets.sprite(far, "BackWall", wall, Vector2(640, 250), Vector2(1.05, 0.95), 0)
	var floor := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/floor_stone_panel.png")
	ArtDemoAssets.sprite(far, "Floor", floor, Vector2(640, 560), Vector2(1.15, 1.0), 1)

	var win := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/window_int.png")
	ArtDemoAssets.sprite(far, "Window", win, Vector2(150, 200), Vector2(1.8, 1.8), 3)

	# Hero forge: LPC kiln silhouette (fire is painted in the sprite).
	var forge_tex := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/kiln_fire.png")
	var forge := ArtDemoAssets.sprite(far, "Forge", forge_tex, Vector2(640, 290), Vector2(1.05, 1.05), 4)
	# Allowed soft glow overlay only.
	var forge_glow := poly(far, "ForgeGlow", PackedVector2Array([
		Vector2(540, 260), Vector2(740, 260), Vector2(780, 420), Vector2(500, 420),
	]), Color(1.0, 0.45, 0.12, 0.18), 3)
	var forge_fire := forge_glow # 02 flicker modulates glow; no solid fire rects.

	var wall_forge := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/forge_wall_lit.png")
	ArtDemoAssets.sprite(far, "WallForge", wall_forge, Vector2(380, 330), Vector2(1.4, 1.4), 3)

	var beam_h := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/wood_beam_h.png")
	ArtDemoAssets.sprite(far, "RafterL", beam_h, Vector2(320, 50), Vector2(0.9, 1.2), 6)
	ArtDemoAssets.sprite(far, "RafterR", beam_h, Vector2(960, 50), Vector2(0.9, 1.2), 6)
	var beam_v := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/wood_beam_v.png")
	ArtDemoAssets.sprite(far, "BeamCenter", beam_v, Vector2(640, 80), Vector2(1.0, 0.45), 6)

	# Mid hero props — pack sprites only.
	var anvil_tex := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/anvil.png")
	var anvil := ArtDemoAssets.sprite(mid, "Anvil", anvil_tex, Vector2(640, 500), Vector2(2.0, 2.0), 3)

	var bellows_tex := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/bellows_big.png")
	ArtDemoAssets.sprite(mid, "Bellows", bellows_tex, Vector2(930, 430), Vector2(1.15, 1.15), 2)

	var quench_tex := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/quench.png")
	ArtDemoAssets.sprite(mid, "QuenchBarrel", quench_tex, Vector2(240, 500), Vector2(1.05, 1.05), 2)

	var coal_tex := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/coal_big.png")
	ArtDemoAssets.sprite(mid, "CoalPile", coal_tex, Vector2(420, 540), Vector2(1.05, 1.05), 2)

	var bench_tex := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/workbench_big.png")
	ArtDemoAssets.sprite(mid, "ToolBench", bench_tex, Vector2(1080, 470), Vector2(0.9, 0.9), 2)

	var tools := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/tools2.png")
	ArtDemoAssets.sprite(mid, "HangingTools", tools, Vector2(280, 240), Vector2(1.5, 1.5), 2)
	var tools_b := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/tools.png")
	ArtDemoAssets.sprite(mid, "HangingToolsB", tools_b, Vector2(360, 250), Vector2(1.3, 1.3), 2)

	var ore_tex := ArtDemoAssets.load_tex(ArtDemoAssets.ORE + "/ore_chunks_strip.png")
	if ore_tex != null:
		ArtDemoAssets.sprite(mid, "OreStrip", ore_tex, Vector2(480, 585), Vector2(0.55, 0.55), 2)
	var ingot_tex := ArtDemoAssets.load_tex(ArtDemoAssets.ORE + "/ingots_strip.png")
	if ingot_tex != null:
		ArtDemoAssets.sprite(mid, "IngotStrip", ingot_tex, Vector2(720, 580), Vector2(0.5, 0.5), 2)

	var barrel := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/barrel_a.png")
	ArtDemoAssets.sprite(mid, "SideBarrel", barrel, Vector2(160, 540), Vector2(1.4, 1.4), 2)

	# Near frame from pack beams/counter (not textured boxes).
	ArtDemoAssets.sprite(near, "LeftPost", beam_v, Vector2(40, 360), Vector2(1.1, 1.15), 1)
	ArtDemoAssets.sprite(near, "RightPost", beam_v, Vector2(1240, 360), Vector2(1.1, 1.15), 1)
	ArtDemoAssets.sprite(near, "TopBeam", beam_h, Vector2(640, 30), Vector2(1.2, 1.0), 2)
	var counter := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/wood_counter.png")
	ArtDemoAssets.sprite(near, "BenchEdge", counter, Vector2(640, 680), Vector2(2.2, 1.6), 4)

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
		Vector2(0, 0), Vector2(1280, 0), Vector2(1280, 520), Vector2(0, 520),
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

	var road := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/path_dirt_panel.png")
	ArtDemoAssets.sprite(far, "Road", road, Vector2(640, 600), Vector2(1.2, 1.1), 1)

	var neighbor := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/stone_neighbor.png")
	ArtDemoAssets.sprite(far, "NeighborL", neighbor, Vector2(130, 340), Vector2(0.75, 0.9), 0)
	ArtDemoAssets.sprite(far, "NeighborR", neighbor, Vector2(1150, 335), Vector2(-0.75, 0.95), 0)

	var facade := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/smithy_facade.png")
	ArtDemoAssets.sprite(mid, "Facade", facade, Vector2(620, 310), Vector2(1.1, 1.05), 1)

	var sign := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/sign_hammer.png")
	ArtDemoAssets.sprite(mid, "Sign", sign, Vector2(500, 245), Vector2(1.35, 1.35), 6)

	var kiln := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/kiln_fire.png")
	ArtDemoAssets.sprite(mid, "StreetForge", kiln, Vector2(760, 420), Vector2(0.7, 0.7), 3)

	var wall_forge := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/forge_wall_lit.png")
	ArtDemoAssets.sprite(mid, "StreetWallForge", wall_forge, Vector2(680, 395), Vector2(1.25, 1.25), 4)

	var anvil := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/anvil.png")
	ArtDemoAssets.sprite(mid, "StreetAnvil", anvil, Vector2(740, 515), Vector2(1.35, 1.35), 5)

	# Soft glow overlays only (allowed).
	var street_fire := poly(mid, "StreetForgeFire", PackedVector2Array([
		Vector2(710, 400), Vector2(810, 400), Vector2(820, 490), Vector2(700, 490),
	]), Color(1, 0.5, 0.15, 0.12), 4)
	var forge_spill := poly(mid, "ForgeSpill", PackedVector2Array([
		Vector2(660, 480), Vector2(860, 470), Vector2(900, 570), Vector2(620, 580),
	]), Color(1.0, 0.45, 0.12, 0.16), 2)

	var door_glow := poly(mid, "DoorGlow", PackedVector2Array([
		Vector2(495, 385), Vector2(545, 380), Vector2(550, 495), Vector2(490, 500),
	]), Color(1.0, 0.7, 0.35, 0.3), 5)
	door_glow.visible = false

	var window_glow := poly(mid, "UpperWindowGlow", PackedVector2Array([
		Vector2(715, 235), Vector2(765, 235), Vector2(765, 270), Vector2(715, 270),
	]), Color(1.0, 0.7, 0.35, 0.35), 5)
	window_glow.visible = false

	var barrel_a := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/barrel_a.png")
	var barrel_b := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/barrel_b.png")
	ArtDemoAssets.sprite(mid, "BarrelA", barrel_a, Vector2(270, 540), Vector2(1.6, 1.6), 4)
	ArtDemoAssets.sprite(mid, "BarrelB", barrel_b, Vector2(990, 545), Vector2(1.6, 1.6), 4)

	var quench := ArtDemoAssets.load_tex(ArtDemoAssets.LPC + "/quench.png")
	ArtDemoAssets.sprite(mid, "StreetQuench", quench, Vector2(200, 555), Vector2(0.6, 0.6), 4)

	var banner_path := ArtDemoAssets.KENNEY + "/PNG/medievalTile_070.png"
	if ResourceLoader.exists(banner_path):
		ArtDemoAssets.sprite(mid, "Banner", ArtDemoAssets.load_tex(banner_path), Vector2(400, 290), Vector2(1.4, 1.4), 5)

	var flower := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/flowerbox.png")
	ArtDemoAssets.sprite(near, "Flowerbox", flower, Vector2(140, 500), Vector2(1.3, 1.3), 1)

	var well := ArtDemoAssets.load_tex(ArtDemoAssets.CA + "/well.png")
	ArtDemoAssets.sprite(near, "Lantern", well, Vector2(180, 420), Vector2(1.1, 1.1), 1)
	var lantern_glow := poly(near, "LanternGlow", PackedVector2Array([
		Vector2(145, 390), Vector2(215, 390), Vector2(235, 500), Vector2(125, 500),
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
		"lantern": null,
		"lantern_glow": lantern_glow,
	}
