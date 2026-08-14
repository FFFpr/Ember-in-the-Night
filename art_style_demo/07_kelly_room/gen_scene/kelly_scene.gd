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

	var coins: Array[Texture2D] = [_tex("coin_1.png"), _tex("coin_2.png"), _tex("coin_3.png")]
	var base_y: float = 0.635 * DESIGN.y
	var mx0: float = g0.x + 6.0
	var mx1: float = g1.x - 6.0
	var coin_w: float = 0.013 * DESIGN.x
	var x: float = mx0
	while x < mx1:
		var tex: Texture2D = coins[_rng.randi_range(0, coins.size() - 1)]
		var k: float = coin_w / float(tex.get_width())
		var ch: float = float(tex.get_height()) * k
		var step: float = maxf(3.0, ch - 3.0)
		var peak: float = (x - mx0) / (mx1 - mx0)
		var env: float = 0.5 + 0.5 * sin(peak * PI)
		var col_h: float = 0.10 * DESIGN.y + 0.13 * DESIGN.y * env * _rng.randf_range(0.7, 1.1)
		var y: float = base_y
		while y > base_y - col_h:
			var c := Sprite2D.new()
			c.texture = tex
			c.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			c.centered = false
			c.scale = Vector2(k, k)
			c.position = Vector2(x, y)
			market.add_child(c)
			y -= step
		x += float(tex.get_width()) * k


func _build_apron_and_outlet() -> void:
	# Outlet chute tucked behind the apron so only its slot mouth peeks out.
	_sprite_w("outlet_closed.png", 0.360, 0.720, 0.20 * DESIGN.x, -35)
	var apron := _sprite_w("iron_apron.png", 0.52, 0.660, 0.66 * DESIGN.x, -30)
	var max_h: float = 0.12 * DESIGN.y
	if apron.scale.y * apron.texture.get_height() > max_h:
		var k: float = max_h / float(apron.texture.get_height())
		apron.scale = Vector2(k, k)


func _build_frame() -> void:
	_tiled("beam.png", Rect2(Vector2.ZERO, Vector2(DESIGN.x, DESIGN.y * 0.085)), 192.0, 20)
	_sprite_h("post.png", 0.170, 0.36, 0.58 * DESIGN.y, 10)
	_sprite_h("post.png", 0.830, 0.36, 0.58 * DESIGN.y, 10)


func _build_props() -> void:
	_sprite_w("whiteboard.png", 0.497, 0.205, 0.22 * DESIGN.x, 30)
	_sprite_w("sticker.png", 0.296, 0.402, 0.05 * DESIGN.x, 5)
	# Coin box and lever rest on the floor (feet at the same ground line).
	var floor_y: float = 0.905
	var cb := _sprite_h("coin_box.png", 0.755, 0.0, 0.26 * DESIGN.y, 40)
	cb.position.y = floor_y * DESIGN.y - cb.scale.y * cb.texture.get_height() * 0.5
	var lv := _sprite_h("lever.png", 0.905, 0.0, 0.33 * DESIGN.y, 40)
	lv.position.y = floor_y * DESIGN.y - lv.scale.y * lv.texture.get_height() * 0.5
	_sprite_h("wall_lantern.png", 0.055, 0.335, 0.33 * DESIGN.y, 15)
	_sprite_h("side_window.png", 0.958, 0.300, 0.46 * DESIGN.y, 5)


func _build_text() -> void:
	var board := Label.new()
	board.text = "回报倍率 2.0×\n成功概率 60%"
	board.add_theme_font_size_override("font_size", 22)
	board.add_theme_color_override("font_color", Color8(30, 24, 26))
	board.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	board.position = _px(0.497, 0.205) - Vector2(110, 26)
	board.size = Vector2(220, 60)
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
