extends Node2D
## Sample-driven Kelly room built from generated pixel assets.
##
## Target look: art_style_demo/references/kelly_room/fp_idle.png. Layout numbers
## are normalized to the 1152x648 baseline frame. Lighting lives in the art
## (baked); the engine only adds a warm accent glow at the lantern plus a dark
## vignette for mood, matching the diorama decision.

const DESIGN := Vector2(1152.0, 648.0)
const A := "res://art_style_demo/07_kelly_room/gen_assets/"

var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.seed = 20260814
	_build_background()
	_build_glass_and_market()
	_build_apron_and_outlet()
	_build_frame()
	_build_props()
	_build_text()
	_build_mood()


func _tex(name: String) -> Texture2D:
	return load(A + name) as Texture2D


func _px(nx: float, ny: float) -> Vector2:
	return Vector2(nx * DESIGN.x, ny * DESIGN.y)


## Sprite placed by normalized centre, scaled to a target height in px.
func _sprite_h(name: String, cx: float, cy: float, target_h_px: float, z: int = 0) -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = _tex(name)
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	s.centered = true
	s.position = _px(cx, cy)
	var k: float = target_h_px / float(maxi(s.texture.get_height(), 1))
	s.scale = Vector2(k, k)
	s.z_index = z
	add_child(s)
	return s


func _sprite_w(name: String, cx: float, cy: float, target_w_px: float, z: int = 0) -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = _tex(name)
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	s.centered = true
	s.position = _px(cx, cy)
	var k: float = target_w_px / float(maxi(s.texture.get_width(), 1))
	s.scale = Vector2(k, k)
	s.z_index = z
	add_child(s)
	return s


## Tiled background rectangle in screen space, drawn at `tile_px` per tile.
func _tiled(name: String, rect: Rect2, tile_px: float, z: int) -> void:
	var tex := _tex(name)
	var s := Sprite2D.new()
	s.texture = tex
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	s.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	s.centered = false
	s.region_enabled = true
	var k: float = tile_px / float(tex.get_width())
	s.scale = Vector2(k, k)
	s.position = rect.position
	s.region_rect = Rect2(Vector2.ZERO, rect.size / k)
	s.z_index = z
	add_child(s)


func _build_background() -> void:
	_tiled("wood_wall.png", Rect2(Vector2.ZERO, Vector2(DESIGN.x, DESIGN.y * 0.80)), 192.0, -100)
	_tiled("wood_floor.png", Rect2(Vector2(0, DESIGN.y * 0.78), Vector2(DESIGN.x, DESIGN.y * 0.22)), 192.0, -99)


func _build_glass_and_market() -> void:
	var g0 := _px(0.195, 0.085)
	var g1 := _px(0.845, 0.655)
	var glass := ColorRect.new()
	glass.color = Color8(14, 18, 28, 205)
	glass.position = g0
	glass.size = g1 - g0
	glass.z_index = -50
	add_child(glass)

	# Coin market: discrete edge-on coin sprites stacked into ragged columns,
	# clipped to the glass. The pile is instances, not a texture.
	var clip := Control.new()
	clip.clip_contents = true
	clip.position = g0
	clip.size = g1 - g0
	clip.z_index = -40
	add_child(clip)
	var market := Node2D.new()
	market.position = -g0
	clip.add_child(market)

	# Single flat coin, stacked into ragged columns to read as a coin sea.
	var tex := _tex("coin_flat.png")
	var base_y: float = 0.635 * DESIGN.y
	var mx0: float = g0.x + 6.0
	var mx1: float = g1.x - 6.0
	var coin_w: float = 0.021 * DESIGN.x
	var k: float = coin_w / float(tex.get_width())
	var ch: float = float(tex.get_height()) * k
	var step: float = maxf(3.0, ch * 0.45)
	var x: float = mx0
	while x < mx1:
		var peak: float = (x - mx0) / (mx1 - mx0)
		var env: float = 0.5 + 0.5 * sin(peak * PI)
		var col_h: float = 0.09 * DESIGN.y + 0.14 * DESIGN.y * env * _rng.randf_range(0.7, 1.1)
		var y: float = base_y
		while y > base_y - col_h:
			var c := Sprite2D.new()
			c.texture = tex
			c.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			c.centered = false
			c.scale = Vector2(k, k)
			c.position = Vector2(x + _rng.randf_range(-1.0, 1.0), y)
			market.add_child(c)
			y -= step
		x += coin_w * _rng.randf_range(0.85, 1.0)


func _build_apron_and_outlet() -> void:
	# One metal base under the glass; its central slot is the single outlet.
	var apron := _sprite_w("iron_apron.png", 0.52, 0.660, 0.66 * DESIGN.x, -30)
	var max_h: float = 0.12 * DESIGN.y
	if apron.scale.y * apron.texture.get_height() > max_h:
		var k: float = max_h / float(apron.texture.get_height())
		apron.scale = Vector2(k, k)


func _build_frame() -> void:
	# Posts run the full height, joining floor to the ceiling beam.
	_sprite_h("post.png", 0.170, 0.50, 1.0 * DESIGN.y, 10)
	_sprite_h("post.png", 0.830, 0.50, 1.0 * DESIGN.y, 10)
	_tiled("beam.png", Rect2(Vector2.ZERO, Vector2(DESIGN.x, DESIGN.y * 0.085)), 192.0, 20)


func _build_props() -> void:
	_sprite_w("whiteboard.png", 0.497, 0.205, 0.22 * DESIGN.x, 30)
	_sprite_w("sticker.png", 0.296, 0.402, 0.05 * DESIGN.x, 5)
	# Coin box (three-quarter view) and side-profile lever rest on the floor.
	var floor_y: float = 0.905
	var cb := _sprite_h("coin_box.png", 0.740, 0.0, 0.28 * DESIGN.y, 40)
	cb.position.y = floor_y * DESIGN.y - cb.scale.y * cb.texture.get_height() * 0.5
	_box_marker(cb)
	var lv := _sprite_h("lever.png", 0.895, 0.0, 0.26 * DESIGN.y, 40)
	lv.position.y = floor_y * DESIGN.y - lv.scale.y * lv.texture.get_height() * 0.5
	_sprite_h("wall_lantern.png", 0.055, 0.335, 0.33 * DESIGN.y, 15)
	_sprite_h("side_window.png", 0.958, 0.300, 0.46 * DESIGN.y, 5)


## Black oil-pen `已投 / 总数` on the coin box front face.
func _box_marker(box: Sprite2D) -> void:
	var lbl := Label.new()
	lbl.text = "0 / 1"
	lbl.add_theme_font_size_override("font_size", 20)
	lbl.add_theme_color_override("font_color", Color8(26, 20, 24))
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var w: float = box.scale.x * box.texture.get_width()
	var h: float = box.scale.y * box.texture.get_height()
	# Front face sits on the lower-right of the three-quarter box.
	lbl.size = Vector2(w * 0.55, 30)
	lbl.position = box.position + Vector2(w * 0.02, h * 0.02) - lbl.size * 0.5
	lbl.z_index = 41
	add_child(lbl)


func _build_text() -> void:
	# Board sprite spans ~182 px tall centred at (0.497, 0.205); the writing
	# lanes sit in its lower ~60%. Centre the two lines there.
	var board := Label.new()
	board.text = "回报倍率 2.0×\n成功概率 60%"
	board.add_theme_font_size_override("font_size", 20)
	board.add_theme_color_override("font_color", Color8(30, 24, 26))
	board.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	board.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	board.size = Vector2(210, 64)
	board.position = _px(0.497, 0.255) - board.size * 0.5
	board.z_index = 31
	add_child(board)

	var formula := Label.new()
	formula.text = "Kelly f* = p - q/b\np = 0.60   b = 2.0"
	formula.add_theme_font_size_override("font_size", 18)
	formula.add_theme_color_override("font_color", Color8(226, 220, 200))
	formula.position = _px(0.235, 0.255)
	formula.z_index = 31
	add_child(formula)


func _build_mood() -> void:
	# Overall dim so the baked art reads moody like the sample.
	var dim := ColorRect.new()
	dim.color = Color8(8, 6, 12, 90)
	dim.position = Vector2.ZERO
	dim.size = DESIGN
	dim.z_index = 88
	add_child(dim)

	# Dark vignette (radial, transparent centre -> dark edge).
	var vg_grad := Gradient.new()
	vg_grad.set_color(0, Color(0, 0, 0, 0.0))
	vg_grad.set_color(1, Color(0, 0, 0, 0.80))
	vg_grad.add_point(0.45, Color(0, 0, 0, 0.0))
	var vg := GradientTexture2D.new()
	vg.gradient = vg_grad
	vg.fill = GradientTexture2D.FILL_RADIAL
	vg.fill_from = Vector2(0.5, 0.5)
	vg.fill_to = Vector2(1.0, 1.0)
	vg.width = 256
	vg.height = 144
	var vgs := Sprite2D.new()
	vgs.texture = vg
	vgs.centered = false
	vgs.scale = DESIGN / Vector2(256, 144)
	vgs.z_index = 90
	add_child(vgs)

	# Warm additive glow at the lantern flame.
	var gl_grad := Gradient.new()
	gl_grad.set_color(0, Color(1.0, 0.6, 0.25, 0.7))
	gl_grad.set_color(1, Color(1.0, 0.6, 0.25, 0.0))
	var gl := GradientTexture2D.new()
	gl.gradient = gl_grad
	gl.fill = GradientTexture2D.FILL_RADIAL
	gl.fill_from = Vector2(0.5, 0.5)
	gl.fill_to = Vector2(1.0, 0.5)
	gl.width = 256
	gl.height = 256
	var glow := Sprite2D.new()
	glow.texture = gl
	glow.centered = true
	glow.position = _px(0.075, 0.40)
	glow.scale = Vector2(3.0, 3.0)
	glow.z_index = 92
	var mat := CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	glow.material = mat
	add_child(glow)

	# Faint neutral fill from the opposite (right) side so shadows are not dead
	# black. No visible fixture: just a soft off-screen gradient, kept low.
	var fl_grad := Gradient.new()
	fl_grad.set_color(0, Color(0.72, 0.75, 0.82, 0.14))
	fl_grad.set_color(1, Color(0.72, 0.75, 0.82, 0.0))
	var fl := GradientTexture2D.new()
	fl.gradient = fl_grad
	fl.fill = GradientTexture2D.FILL_RADIAL
	fl.fill_from = Vector2(0.5, 0.5)
	fl.fill_to = Vector2(1.0, 0.5)
	fl.width = 256
	fl.height = 256
	var fill := Sprite2D.new()
	fill.texture = fl
	fill.centered = true
	fill.position = _px(1.02, 0.62)
	fill.scale = Vector2(4.0, 4.0)
	fill.z_index = 91
	var fmat := CanvasItemMaterial.new()
	fmat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	fill.material = fmat
	add_child(fill)
