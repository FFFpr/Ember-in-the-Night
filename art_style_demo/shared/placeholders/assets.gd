class_name ArtDemoAssets
extends Object

## Paths into free-store imported packs (see shared/imported/CREDITS.md).

const IMPORTED := "res://art_style_demo/shared/imported"

const TEX_WOOD := IMPORTED + "/ambientcg/WoodFloor051/WoodFloor051_1K-JPG_Color.jpg"
const TEX_ROCK := IMPORTED + "/ambientcg/Rock023/Rock023_1K-JPG_Color.jpg"
const TEX_ROCK2 := IMPORTED + "/ambientcg/Rock022/Rock022_1K-JPG_Color.jpg"
const TEX_METAL := IMPORTED + "/ambientcg/Metal032/Metal032_1K-JPG_Color.jpg"
const TEX_PAVE := IMPORTED + "/ambientcg/PavingStones130/PavingStones130_1K-JPG_Color.jpg"

const LPC := IMPORTED + "/lpc_blacksmith/sprites"
const CA := IMPORTED + "/calciumtrice_medieval_tileset/sprites"
const ORE := IMPORTED + "/lpc_ore_and_forge"
const KENNEY := IMPORTED + "/kenney_platformer_pack_medieval"


static func load_tex(path: String) -> Texture2D:
	var tex := load(path) as Texture2D
	if tex == null:
		push_error("ArtDemoAssets: missing texture %s" % path)
	return tex


static func sprite(parent: Node, name: String, tex: Texture2D, pos: Vector2, scale := Vector2.ONE, z := 0, centered := true) -> Sprite2D:
	var s := Sprite2D.new()
	s.name = name
	s.texture = tex
	s.position = pos
	s.scale = scale
	s.z_index = z
	s.centered = centered
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	parent.add_child(s)
	return s


static func textured_rect(parent: Node, name: String, tex: Texture2D, rect: Rect2, modulate := Color.WHITE, z := 0) -> Sprite2D:
	## Stretch a texture to cover a screen rect (soft plate / floor / wall).
	var s := Sprite2D.new()
	s.name = name
	s.texture = tex
	s.centered = false
	s.position = rect.position
	s.scale = Vector2(rect.size.x / float(tex.get_width()), rect.size.y / float(tex.get_height()))
	s.modulate = modulate
	s.z_index = z
	s.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	parent.add_child(s)
	return s
