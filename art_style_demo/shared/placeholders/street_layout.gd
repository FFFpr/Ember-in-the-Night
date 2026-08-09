class_name StreetLayout
extends RefCounted
## Shop-front street — buildings/props from packs; sky/glow may use primitives.


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


static func _pixel_sprite(parent: Node, name: String, path: String, pos: Vector2, scale: float, z: int, modulate: Color = Color.WHITE) -> Sprite2D:
	var tex := DemoAssets.tex(path)
	if tex == null:
		return null
	var node := PlateUtil.sprite(parent, name, tex, pos, Vector2(scale, scale), z, modulate)
	node.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	return node


static func _build_far(layer: Node2D) -> void:
	var sun := DemoAssets.tex(DemoAssets.SUN)
	var cloud := DemoAssets.tex(DemoAssets.CLOUD_1)
	var cloud2 := DemoAssets.tex(DemoAssets.CLOUD_3)
	if sun:
		PlateUtil.sprite(layer, "Sun", sun, Vector2(1080, 90), Vector2(0.35, 0.35), 0, Color(1, 1, 1, 0.95))
	if cloud:
		PlateUtil.sprite(layer, "CloudA", cloud, Vector2(240, 70), Vector2(0.45, 0.45), 1, Color(1, 1, 1, 0.8))
	if cloud2:
		PlateUtil.sprite(layer, "CloudB", cloud2, Vector2(700, 55), Vector2(0.4, 0.4), 1, Color(1, 1, 1, 0.7))

	# Neighbor masses from medieval RTS pack sprites (authored), not soft vector houses
	_pixel_sprite(layer, "RtsStructFarA", DemoAssets.RTS_STRUCT_01, Vector2(980, 300), 2.2, 2)
	_pixel_sprite(layer, "RtsStructFarB", DemoAssets.RTS_STRUCT_08, Vector2(1140, 320), 2.0, 2)
	_pixel_sprite(layer, "RtsStructFarC", DemoAssets.RTS_STRUCT_12, Vector2(860, 310), 1.9, 2)
	_pixel_sprite(layer, "RtsEnvFar", DemoAssets.RTS_ENV_01, Vector2(1020, 400), 1.8, 3)


static func _build_mid(layer: Node2D) -> void:
	var cobble := DemoAssets.tex(DemoAssets.COBBLE)
	PlateUtil.textured_rect(layer, "Street", Vector2(0, 420), Vector2(1280, 300), cobble, 0, Color(0.68, 0.7, 0.76), 0.003)

	# Hero smithy: authored isometric blacksmith building
	var iso := DemoAssets.tex(DemoAssets.ISO_SMITHY)
	if iso:
		PlateUtil.sprite(layer, "SmithyBuilding", iso, Vector2(300, 270), Vector2(1.7, 1.7), 3)

	# Second building mass from RTS pack
	_pixel_sprite(layer, "SideWorkshop", DemoAssets.RTS_STRUCT_15, Vector2(620, 300), 2.4, 2)

	# Outdoor forge bay props (pack sprites)
	_pixel_sprite(layer, "ForgeBay", DemoAssets.FORGE_FIRE, Vector2(520, 360), 1.8, 5)
	_pixel_sprite(layer, "StumpOut", DemoAssets.STONE_STUMP, Vector2(500, 455), 2.4, 5)
	_pixel_sprite(layer, "AnvilOut", DemoAssets.ANVIL, Vector2(500, 415), 3.8, 6)

	var sign := DemoAssets.tex(DemoAssets.SIGN)
	if sign:
		PlateUtil.sprite(layer, "SignBoard", sign, Vector2(400, 170), Vector2(1.6, 1.6), 7)
	_pixel_sprite(layer, "HammerSign", DemoAssets.HAMMER, Vector2(400, 200), 2.5, 9)

	_pixel_sprite(layer, "RtsEnvBarrels", DemoAssets.RTS_ENV_08, Vector2(700, 430), 2.2, 4)
	_pixel_sprite(layer, "RtsEnvB", DemoAssets.RTS_ENV_12, Vector2(780, 420), 2.0, 4)


static func _build_near(layer: Node2D) -> void:
	_pixel_sprite(layer, "CrateA", DemoAssets.QUENCH_BOX, Vector2(140, 500), 2.6, 1)
	_pixel_sprite(layer, "CoalNear", DemoAssets.COAL, Vector2(240, 520), 2.4, 1)
	_pixel_sprite(layer, "QuenchNear", DemoAssets.QUENCH, Vector2(340, 510), 2.6, 1)
	_pixel_sprite(layer, "EnvProp", DemoAssets.RTS_ENV_12, Vector2(600, 480), 2.0, 1)
	_pixel_sprite(layer, "EnvPropB", DemoAssets.RTS_ENV_08, Vector2(820, 490), 1.9, 1)
	_pixel_sprite(layer, "EnvPropC", DemoAssets.RTS_ENV_01, Vector2(980, 470), 1.8, 1)

	var torch := DemoAssets.tex(DemoAssets.TORCH)
	if torch:
		PlateUtil.sprite(layer, "TorchDay", torch, Vector2(700, 360), Vector2(1.5, 1.5), 3)


static func _build_night_glows(layer: Node2D) -> void:
	var moon := DemoAssets.tex(DemoAssets.MOON)
	var puff := DemoAssets.tex(DemoAssets.PUFF)
	if moon:
		PlateUtil.sprite(layer, "Moon", moon, Vector2(1040, 90), Vector2(0.3, 0.3), 0, Color(0.85, 0.9, 1.0, 0.95))

	# Allowed glow overlays only
	PlateUtil.ellipse(layer, "ForgeSpill", Vector2(520, 370), Vector2(110, 80), Color(1.0, 0.45, 0.12, 0.5), 20)
	PlateUtil.ellipse(layer, "DoorGlow", Vector2(280, 340), Vector2(50, 70), Color(1.0, 0.55, 0.2, 0.35), 20)
	PlateUtil.rect(layer, "WindowWarm1", Vector2(250, 200), Vector2(40, 36), Color(1.0, 0.6, 0.25, 0.7), 20)
	PlateUtil.rect(layer, "WindowWarm2", Vector2(330, 200), Vector2(40, 36), Color(1.0, 0.55, 0.2, 0.55), 20)
	if puff:
		PlateUtil.sprite(layer, "LanternGlow", puff, Vector2(700, 340), Vector2(0.35, 0.35), 19, Color(1.0, 0.65, 0.25, 0.55))
	var torch := DemoAssets.tex(DemoAssets.TORCH)
	if torch:
		PlateUtil.sprite(layer, "LanternTorch", torch, Vector2(700, 300), Vector2(1.6, 1.6), 20)
