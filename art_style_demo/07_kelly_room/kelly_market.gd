extends RefCounted
## The hoard behind the glass.
##
## Density is a texture, not instances: one `level` value drives a tileable fill
## and an irregular crest strip, drawn on parallax layers at different depths, so
## "thousands of coins" costs three quads. Only coins that move are sprites, and
## they hand off to the level when they land — a falling coin despawns and raises
## the level by its share, an ejected coin lowers it. Nothing is grid-placed.

const Assets := preload("res://art_style_demo/07_kelly_room/kelly_assets.gd")
const Layout := preload("res://art_style_demo/07_kelly_room/kelly_layout.gd")

const GOLD_D := Color8(148, 96, 24)
const GOLD_M := Color8(214, 152, 44)
const GOLD_L := Color8(255, 214, 120)
const OUTLINE := Color8(28, 22, 26)

## Depth behind the glass for the front layer, then one layer per step back.
const LAYER_STEP := 0.42
const LAYERS := 3
## Coins per spawned sprite when a batch is too large to animate one by one.
const MAX_SPRITES := 36
const WAVE := 6
const WAVE_GAP := 0.045

var layout: Layout
var host: Node3D
var root: Node3D
var level: float = 1.0

var _tree: SceneTree
var _fill: Array[MeshInstance3D] = []
var _crest: Array[MeshInstance3D] = []
var _layer_depth: PackedFloat32Array = []
var _rect_size: Vector2
var _rect_origin: Vector3
var _crest_h: float
var _pool: Array[Sprite3D] = []
var _coin_tex: Texture2D
var _rng := RandomNumberGenerator.new()


func _init(layout_data: Layout) -> void:
	layout = layout_data
	_rng.randomize()


func build(parent: Node3D) -> Node3D:
	host = parent
	_tree = parent.get_tree()
	_coin_tex = Assets.tex(Assets.COIN_EDGE)
	root = Node3D.new()
	root.name = "CoinMass"
	parent.add_child(root)
	var front_depth: float = layout.wall_depth() + 0.25
	var item: Dictionary = layout.fit.items["coin_mass"]
	_rect_size = layout.size_at(item["size"], front_depth)
	_rect_origin = layout.world_at(item["centre"], front_depth)
	# The crest strip is the ragged top; the fill is everything under it.
	_crest_h = _rect_size.y * 0.42
	var crest_a := Assets.tex(Assets.COIN_MASS_CREST_A)
	var crest_b := Assets.tex(Assets.COIN_MASS_CREST_B)
	for i in LAYERS:
		var depth: float = front_depth + float(i) * LAYER_STEP
		_layer_depth.append(depth)
		var shade: float = 1.0 - float(i) * 0.28
		var scale: float = layout.size_at(item["size"], depth).x / _rect_size.x
		var fill := _layer_quad("MassFill%d" % i, Assets.tex(Assets.COIN_MASS_FILL),
				shade, false, i)
		var crest := _layer_quad("MassCrest%d" % i,
				crest_b if (i % 2 == 1 and crest_b != null) else crest_a, shade, true, i)
		fill.scale = Vector3(scale, 1.0, 1.0)
		crest.scale = Vector3(scale, 1.0, 1.0)
		_fill.append(fill)
		_crest.append(crest)
	set_level(level)
	return root


func _layer_quad(node_name: String, tex: Texture2D, shade: float, is_crest: bool,
		index: int) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.name = node_name
	mi.mesh = QuadMesh.new()
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(shade, shade, shade)
	mat.roughness = 0.42
	mat.metallic = 0.55
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	if tex == null:
		tex = _greybox_crest_tex(index) if is_crest else _greybox_fill_tex()
	mat.albedo_texture = tex
	mat.uv1_scale = Vector3(_rect_size.x / 0.64, 1.0, 1.0)
	# The hoard is the bright subject of the frame; a little emission carries that
	# without a light that would wash the room out.
	mat.emission_enabled = true
	mat.emission = GOLD_D
	mat.emission_energy_multiplier = 0.22 * shade
	if is_crest:
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
		mat.alpha_scissor_threshold = 0.5
	# Layers behind read darker and are nudged sideways so the silhouettes differ.
	mat.uv1_offset = Vector3(float(index) * 0.37, 0.0, 0.0)
	mi.material_override = mat
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	root.add_child(mi)
	return mi


static var _fill_tex: Texture2D
static var _crest_tex: Dictionary = {}


## Greybox fill: edge-on coins stacked into columns, tileable both ways. Drawn
## rather than tinted flat so the greybox already reads as a hoard, which is what
## makes the acceptance screenshot worth looking at before the art lands.
func _greybox_fill_tex() -> Texture2D:
	if _fill_tex != null:
		return _fill_tex
	var img := Image.create(64, 64, false, Image.FORMAT_RGBA8)
	for x in 64:
		var col: int = x / 8
		var phase: int = (col * 3) % 4
		for y in 64:
			var band: int = (y + phase) % 4
			var c: Color = GOLD_M
			if band == 0:
				c = OUTLINE
			elif band == 1:
				c = GOLD_L
			elif band == 3:
				c = GOLD_D
			if x % 8 == 0:
				c = OUTLINE
			img.set_pixel(x, y, c)
	_fill_tex = ImageTexture.create_from_image(img)
	return _fill_tex


## Greybox crest: ragged stack tops with transparency above them.
## Matches the fit-list profile: peak near u≈0.36 of the mass, ends lower.
func _greybox_crest_tex(variant: int) -> Texture2D:
	if _crest_tex.has(variant):
		return _crest_tex[variant]
	var w := 64
	var h := 32
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	var n := FastNoiseLite.new()
	n.seed = 4021 + variant * 137
	n.noise_type = FastNoiseLite.TYPE_VALUE
	n.frequency = 0.18
	# Columns are 5–11 px wide so the crest steps unevenly, not a grid.
	var col_x := 0
	var col_w := 7
	var col_i := 0
	while col_x < w:
		col_w = 5 + ((col_i * 5 + variant * 3) % 7)
		var mid: float = (float(col_x) + float(col_w) * 0.5) / float(w)
		# Envelope from the fit list: peak left of centre, lower at both ends.
		var envelope: float = 1.0 - absf(mid - 0.28) * 1.55
		envelope = clampf(envelope, 0.18, 1.0)
		var jitter: float = n.get_noise_2d(float(col_i) * 11.0, float(variant)) * 0.5 + 0.5
		var top: int = int(float(h) * (0.08 + 0.72 * envelope * (0.55 + 0.45 * jitter)))
		var phase: int = (col_i * 3 + variant) % 4
		for x in range(col_x, mini(col_x + col_w, w)):
			for y in h:
				if y < top:
					img.set_pixel(x, y, Color(0, 0, 0, 0))
					continue
				var band: int = (y + phase) % 4
				var c: Color = GOLD_M
				if band == 0:
					c = OUTLINE
				elif band == 1:
					c = GOLD_L
				elif band == 3:
					c = GOLD_D
				if x == col_x:
					c = OUTLINE
				img.set_pixel(x, y, c)
		col_x += col_w
		col_i += 1
	var tex := ImageTexture.create_from_image(img)
	_crest_tex[variant] = tex
	return tex


## Rebuilds the fill and crest geometry for a 0..1 market level.
func set_level(value: float) -> void:
	level = clampf(value, 0.0, 1.4)
	var base_y: float = _rect_origin.y - _rect_size.y * 0.5
	var top_y: float = base_y + _rect_size.y * level
	var fill_h: float = maxf(top_y - _crest_h - base_y, 0.001)
	for i in LAYERS:
		# Deeper layers sit a little higher, as a heap leaning against the back.
		var lift: float = _rect_size.y * 0.06 * float(i) * level
		var quad_fill: QuadMesh = _fill[i].mesh
		quad_fill.size = Vector2(_rect_size.x, fill_h)
		_fill[i].position = Vector3(_rect_origin.x, base_y + fill_h * 0.5 + lift,
				_z_for(_layer_depth[i]))
		var mat_fill: StandardMaterial3D = _fill[i].material_override
		mat_fill.uv1_scale = Vector3(mat_fill.uv1_scale.x, maxf(fill_h / 0.64, 0.25), 1.0)
		var quad_crest: QuadMesh = _crest[i].mesh
		quad_crest.size = Vector2(_rect_size.x, _crest_h)
		_crest[i].position = Vector3(_rect_origin.x, base_y + fill_h + _crest_h * 0.5 + lift,
				_z_for(_layer_depth[i]) + 0.01)


func _z_for(depth: float) -> float:
	return layout.camera.position.z - depth


func crest_y() -> float:
	var base_y: float = _rect_origin.y - _rect_size.y * 0.5
	return base_y + _rect_size.y * level


## Level change worth one coin, given the round's total stake scale.
func level_per_coin(total: int) -> float:
	return 1.0 / float(maxi(total, 1) * 6)


## Coins fall from above into the glass and merge into the heap.
func fall_in(count: int, total: int) -> void:
	if count <= 0:
		return
	var per_coin: float = level_per_coin(total)
	var sprites: int = mini(count, MAX_SPRITES)
	var share: float = float(count) / float(sprites)
	var top: float = _rect_origin.y + _rect_size.y * 0.5 + 0.55
	var i := 0
	while i < sprites:
		var batch: int = mini(WAVE, sprites - i)
		for _b in batch:
			var coin := _take()
			var x: float = _rect_origin.x + _rng.randf_range(-0.44, 0.44) * _rect_size.x
			var depth: float = _layer_depth[_rng.randi_range(0, LAYERS - 1)]
			coin.position = Vector3(x, top, _z_for(depth))
			_drop(coin, crest_y(), per_coin * share)
			i += 1
		await _tree.create_timer(WAVE_GAP).timeout


## Coins leave the heap through the outlet; caller places them after `landed`.
func take_out(count: int, total: int) -> float:
	var per_coin: float = level_per_coin(total)
	set_level(level - per_coin * float(count))
	return per_coin


## Edge-on pool sprites fly from the crest to `target` (outlet mouth).
## Drops the water level up front; the room spawns floor coins after this returns.
func pop_out(count: int, total: int, target: Vector3) -> void:
	if count <= 0:
		return
	take_out(count, total)
	var sprites: int = mini(count, MAX_SPRITES)
	var i := 0
	while i < sprites:
		var batch: int = mini(WAVE, sprites - i)
		for _b in batch:
			var coin := _take()
			var x: float = _rect_origin.x + _rng.randf_range(-0.30, 0.30) * _rect_size.x
			coin.position = Vector3(x, crest_y() + 0.04, _z_for(_layer_depth[0]))
			var dest := target + Vector3(
					_rng.randf_range(-0.08, 0.08), _rng.randf_range(-0.03, 0.03), 0.0)
			_fly(coin, dest)
			i += 1
		await _tree.create_timer(WAVE_GAP).timeout
	await _tree.create_timer(0.32).timeout


func _fly(coin: Sprite3D, dest: Vector3) -> void:
	var tw := host.create_tween()
	tw.tween_property(coin, "position", dest, 0.28).set_ease(Tween.EASE_IN) \
			.set_trans(Tween.TRANS_QUAD)
	tw.finished.connect(func() -> void:
		_give_back(coin))


func _drop(coin: Sprite3D, target_y: float, level_gain: float) -> void:
	var fall: float = maxf(coin.position.y - target_y, 0.05)
	var dur: float = sqrt(fall / 4.2) + 0.12
	var tw := host.create_tween()
	tw.tween_property(coin, "position:y", target_y, dur).set_ease(Tween.EASE_IN) \
			.set_trans(Tween.TRANS_QUAD)
	tw.finished.connect(func() -> void:
		_give_back(coin)
		set_level(level + level_gain))


func _take() -> Sprite3D:
	if not _pool.is_empty():
		var reused: Sprite3D = _pool.pop_back()
		reused.visible = true
		return reused
	var coin := Sprite3D.new()
	coin.name = "MarketCoin"
	var diameter: float = layout.size_at(Vector2(0.012, 0.012), _layer_depth[0]).x
	if _coin_tex != null:
		coin.texture = _coin_tex
		coin.pixel_size = diameter / float(_coin_tex.get_width())
	else:
		coin.texture = _greybox_coin()
		coin.pixel_size = diameter / 8.0
	coin.shaded = true
	coin.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	coin.alpha_scissor_threshold = 0.5
	coin.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	coin.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	coin.centered = true
	root.add_child(coin)
	return coin


func _give_back(coin: Sprite3D) -> void:
	coin.visible = false
	_pool.append(coin)


static var _greybox_tex: Texture2D


func _greybox_coin() -> Texture2D:
	if _greybox_tex != null:
		return _greybox_tex
	# Edge-on coin: a wide, short slug, not a face-on disc.
	var img := Image.create(8, 4, false, Image.FORMAT_RGBA8)
	for y in 4:
		for x in 8:
			var edge: bool = x == 0 or x == 7 or y == 0 or y == 3
			img.set_pixel(x, y, OUTLINE if edge else (GOLD_L if y == 1 else GOLD_M))
	_greybox_tex = ImageTexture.create_from_image(img)
	return _greybox_tex
