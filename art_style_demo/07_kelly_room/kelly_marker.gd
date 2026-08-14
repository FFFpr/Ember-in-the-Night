extends RefCounted
## Renders integer / slash strings from the issue_32 marker_digits atlas.
##
## Atlas is 176×16: eleven 16×16 cells (0–9, slash). Each cell's baseline pivot is
## (8, 15). Only forge-night `outline` ink — no halo. Used for the coin-box
## readout and the revealed Kelly stake; letters and decimals stay on Label3D.

const Assets := preload("res://art_style_demo/07_kelly_room/kelly_assets.gd")

const CELL := 16
const CELLS := 11
const PIVOT := Vector2(8, 15)

var root: Node3D
var _atlas: Texture2D
var _glyphs: Array[Sprite3D] = []
var _pixel_size: float = 0.01
var _ink: Color = Color.WHITE


func build(parent: Node3D, node_name: String, line_height_m: float,
		ink: Color = Color.WHITE) -> Node3D:
	root = Node3D.new()
	root.name = node_name
	parent.add_child(root)
	_ink = ink
	_atlas = Assets.tex(Assets.MARKER_DIGITS)
	_pixel_size = line_height_m / float(CELL)
	return root


func available() -> bool:
	return _atlas != null and _atlas.get_width() == CELLS * CELL and _atlas.get_height() == CELL


## Sets the visible string. Allowed characters: digits and '/'. Others are skipped.
func set_text(text: String) -> void:
	if root == null:
		return
	for g in _glyphs:
		root.remove_child(g)
		g.free()
	_glyphs.clear()
	if not available():
		return
	var x := 0.0
	# Fit-list centres are mid-glyph; the atlas pivot is the baseline, 7 px below
	# the cell centre. Lift every glyph so the cell centre sits on y = 0.
	var lift: float = (PIVOT.y - float(CELL) * 0.5) * _pixel_size
	for ch in text:
		var cell := _cell_index(ch)
		if cell < 0:
			continue
		var sprite := Sprite3D.new()
		sprite.texture = _region(cell)
		sprite.pixel_size = _pixel_size
		sprite.centered = false
		sprite.offset = -PIVOT
		sprite.modulate = _ink
		sprite.shaded = false
		sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
		sprite.alpha_scissor_threshold = 0.5
		sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		sprite.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		sprite.position = Vector3(x, lift, 0.0)
		root.add_child(sprite)
		_glyphs.append(sprite)
		x += float(CELL) * _pixel_size
	var width := x
	for g in _glyphs:
		g.position.x -= width * 0.5


func _cell_index(ch: String) -> int:
	if ch == "/":
		return 10
	if ch.length() == 1 and ch >= "0" and ch <= "9":
		return int(ch)
	return -1


func _region(cell: int) -> AtlasTexture:
	var at := AtlasTexture.new()
	at.atlas = _atlas
	at.region = Rect2(cell * CELL, 0, CELL, CELL)
	at.filter_clip = true
	return at
