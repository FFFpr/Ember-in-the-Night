class_name WorkshopLayout
extends RefCounted
## FP workshop — hero props are pack sprites; floor/wall may use textures; glow may use primitives.


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


static func _pixel_sprite(parent: Node, name: String, path: String, pos: Vector2, scale: float, z: int, modulate: Color = Color.WHITE) -> Sprite2D:
	var tex := DemoAssets.tex(path)
	if tex == null:
		return null
	var node := PlateUtil.sprite(parent, name, tex, pos, Vector2(scale, scale), z, modulate)
	node.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	return node


static func _build_far(layer: Node2D) -> void:
	var plaster := DemoAssets.tex(DemoAssets.PLASTER)
	var cobble := DemoAssets.tex(DemoAssets.COBBLE)
	var wood_dark := DemoAssets.tex(DemoAssets.WOOD_DARK)

	# Allowed: floor/wall texture washes
	PlateUtil.textured_rect(layer, "BackWall", Vector2(0, 0), Vector2(1280, 520), plaster, 0, Color(0.5, 0.56, 0.68), 0.0025)
	PlateUtil.textured_rect(layer, "Floor", Vector2(0, 470), Vector2(1280, 250), cobble, 1, Color(0.7, 0.72, 0.8), 0.003)
	PlateUtil.textured_rect(layer, "CeilingBeamTex", Vector2(0, 0), Vector2(1280, 60), wood_dark, 2, Color(0.35, 0.28, 0.2), 0.004)

	# Cold window — framed with wood texture plate only as aperture; glass = glow exception
	PlateUtil.textured_rect(layer, "WindowFrame", Vector2(60, 80), Vector2(180, 210), wood_dark, 3, Color(0.65, 0.5, 0.35), 0.008)
	PlateUtil.rect(layer, "WindowGlass", Vector2(85, 105), Vector2(130, 160), ArtPalette.COOL_WINDOW, 4)

	# Hero forge = pack kiln sprite
	_pixel_sprite(layer, "ForgeKiln", DemoAssets.FORGE_KILN, Vector2(980, 300), 3.2, 5)
	_pixel_sprite(layer, "ForgeFire", DemoAssets.FORGE_FIRE, Vector2(980, 360), 2.4, 6)
	# Allowed glow overlay
	PlateUtil.ellipse(layer, "ForgeGlow", Vector2(980, 360), Vector2(140, 100), Color(1.0, 0.45, 0.12, 0.35), 4)
	var flash := DemoAssets.tex(DemoAssets.FLASH)
	if flash:
		PlateUtil.sprite(layer, "ForgeFlash", flash, Vector2(980, 340), Vector2(0.5, 0.4), 7, Color(1.0, 0.55, 0.2, 0.75))


static func _build_mid(layer: Node2D) -> void:
	_pixel_sprite(layer, "QuenchTrough", DemoAssets.QUENCH, Vector2(160, 430), 3.5, 0)
	_pixel_sprite(layer, "QuenchBox", DemoAssets.QUENCH_BOX, Vector2(250, 470), 3.0, 0)
	_pixel_sprite(layer, "CoalHeap", DemoAssets.COAL, Vector2(330, 500), 2.8, 0)

	_pixel_sprite(layer, "ToolBench", DemoAssets.TOOL_BENCH, Vector2(420, 280), 3.4, 1)
	_pixel_sprite(layer, "WallTools", DemoAssets.WALL_TOOLS, Vector2(520, 180), 3.5, 1)
	_pixel_sprite(layer, "HammerA", DemoAssets.HAMMER, Vector2(560, 230), 3.0, 2)
	_pixel_sprite(layer, "HammerB", DemoAssets.HAMMER, Vector2(600, 235), 2.8, 2)
	_pixel_sprite(layer, "ToolStand", DemoAssets.TOOL_STAND, Vector2(360, 360), 3.0, 1)

	_pixel_sprite(layer, "StoneStump", DemoAssets.STONE_STUMP, Vector2(560, 475), 3.5, 2)
	_pixel_sprite(layer, "Anvil", DemoAssets.ANVIL, Vector2(560, 425), 5.5, 3)

	_pixel_sprite(layer, "Bellows", DemoAssets.BELLOWS, Vector2(1140, 360), 4.5, 4)
	_pixel_sprite(layer, "WorkBenchSide", DemoAssets.WORK_BENCH, Vector2(720, 480), 3.0, 2)


static func _build_near(layer: Node2D) -> void:
	var wood := DemoAssets.tex(DemoAssets.WOOD)
	var wood_dark := DemoAssets.tex(DemoAssets.WOOD_DARK)
	# Beam wash (texture strip OK) + pack props in front
	PlateUtil.textured_rect(layer, "BeamAcross", Vector2(40, 50), Vector2(1200, 28), wood_dark, 0, Color(0.55, 0.4, 0.28), 0.004)
	_pixel_sprite(layer, "HangingTools", DemoAssets.WALL_TOOLS, Vector2(700, 90), 2.8, 1)

	# FP bench surface — textured board (floor-like plate), gloves from wood texture are forbidden as drawn props;
	# use pack work bench sprites as near props instead.
	PlateUtil.textured_rect(layer, "BenchBoard", Vector2(0, 560), Vector2(1280, 160), wood, 2, Color(0.8, 0.65, 0.45), 0.002)
	_pixel_sprite(layer, "NearHammer", DemoAssets.HAMMER, Vector2(920, 600), 5.0, 4)
	_pixel_sprite(layer, "NearTongsRack", DemoAssets.TOOL_STAND, Vector2(200, 600), 3.5, 4)
	_pixel_sprite(layer, "NearCoal", DemoAssets.COAL, Vector2(1080, 640), 2.5, 3)
	_pixel_sprite(layer, "NearQuench", DemoAssets.QUENCH_BOX, Vector2(1180, 620), 2.8, 3)
