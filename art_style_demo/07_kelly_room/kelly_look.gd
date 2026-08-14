extends RefCounted
## Procedural room look: wood planks, metal glass frame, marker labels.
## Optional Aseprite tiles replace the runtime grain when present.

const Assets := preload("res://art_style_demo/07_kelly_room/kelly_assets.gd")

const WOOD_D := Color8(62, 38, 28)
const WOOD_M := Color8(118, 72, 42)
const WOOD_L := Color8(176, 118, 62)
const METAL_D := Color8(48, 46, 58)
const METAL_M := Color8(92, 90, 102)
const METAL_L := Color8(168, 158, 148)
const METAL_HI := Color8(232, 214, 176)
const OUTLINE := Color8(28, 22, 26)
const INK := Color(0.12, 0.09, 0.10, 1.0)
const INK_BLEED := Color(0.12, 0.09, 0.10, 0.45)
const GLASS := Color(0.58, 0.76, 0.72, 0.13)
const NIGHT := Color8(22, 32, 52)

const FLOOR_Y := 0.02
const ROOM_X0 := -2.42
const ROOM_X1 := 2.07
const ROOM_Z0 := -2.87
const ROOM_Z1 := 2.55
const ROOM_Y1 := 2.49

const GLASS_Z := -1.40
const FRAME_X0 := -1.88
const FRAME_X1 := 1.52
const FRAME_Y0 := 0.05
const FRAME_Y1 := 2.26
const FRAME_BAR := 0.11
const FRAME_DEPTH := 0.16

const DIGIT_ORDER := "0123456789/×%.= "

static var _floor_tex: Texture2D
static var _wall_tex: Texture2D
static var _digit_tex: Texture2D
static var _mats_ready := false
static var _wall_official := false
static var _floor_mats: Array[StandardMaterial3D] = []
static var _wall_mats: Array[StandardMaterial3D] = []
static var _metal_d: StandardMaterial3D
static var _metal_m: StandardMaterial3D
static var _metal_l: StandardMaterial3D
static var _metal_hi: StandardMaterial3D
static var _gap_mat: StandardMaterial3D
static var _glass_mat: StandardMaterial3D
static var _marker_font: Font


static func ensure_mats() -> void:
	if _mats_ready:
		return
	_floor_tex = Assets.tex(Assets.WOOD_FLOOR)
	if _floor_tex == null:
		_floor_tex = _grain_tex(11, false)
	_wall_tex = Assets.tex(Assets.WOOD_WALL)
	_wall_official = _wall_tex != null
	if _wall_tex == null:
		_wall_tex = _grain_tex(23, true)
	_digit_tex = Assets.tex(Assets.MARKER_DIGITS)
	_floor_mats = _wood_set(_floor_tex, true, Vector3(0.55, 0.55, 0.55))
	_wall_mats = _wood_set(
			_wall_tex,
			not _wall_official,
			Vector3(1.4, 1.4, 1.4) if _wall_official else Vector3(0.55, 0.55, 0.55))
	_metal_d = _metal(METAL_D, 0.82, 0.38)
	_metal_m = _metal(METAL_M, 0.78, 0.32)
	_metal_l = _metal(METAL_L, 0.70, 0.28)
	_metal_hi = _metal(METAL_HI, 0.55, 0.22)
	_gap_mat = _lit(OUTLINE, 0.95, 0.0)
	_glass_mat = StandardMaterial3D.new()
	_glass_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_glass_mat.albedo_color = GLASS
	_glass_mat.roughness = 0.06
	_glass_mat.metallic = 0.18
	_glass_mat.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_DISABLED
	var base: Font = ThemeDB.fallback_font
	if base != null:
		var fv := FontVariation.new()
		fv.base_font = base
		fv.variation_embolden = 0.62
		fv.spacing_glyph = 1
		_marker_font = fv
	_mats_ready = true


static func add_room(host: Node3D) -> void:
	ensure_mats()
	_slab(host, Vector3(ROOM_X1 - ROOM_X0 + 0.2, 0.08, ROOM_Z1 - ROOM_Z0 + 0.2),
			Vector3((ROOM_X0 + ROOM_X1) * 0.5, -0.06, (ROOM_Z0 + ROOM_Z1) * 0.5), _gap_mat)
	_floor_planks(host)
	if _wall_official:
		_wall_slabs(host)
	else:
		_wall_planks(host, ROOM_X0 - 0.08, 0.16)
		_wall_planks(host, ROOM_X1 + 0.08, 0.16)
		_back_planks(host)
		_ceiling_planks(host)
	_beam(host, -1.15)
	_beam(host, 0.85)


static func add_glass_wall(host: Node3D) -> void:
	ensure_mats()
	var z: float = GLASS_Z
	var mid_x: float = (FRAME_X0 + FRAME_X1) * 0.5
	var mid_y: float = (FRAME_Y0 + FRAME_Y1) * 0.5
	var outer_w: float = FRAME_X1 - FRAME_X0
	var outer_h: float = FRAME_Y1 - FRAME_Y0
	var bar: float = FRAME_BAR
	var depth: float = FRAME_DEPTH
	# Four frame members sit between wood and glass. Outer bars read as metal, not wood.
	_box(host, Vector3(outer_w, bar, depth), Vector3(mid_x, FRAME_Y0 + bar * 0.5, z), _metal_m)
	_box(host, Vector3(outer_w, bar, depth), Vector3(mid_x, FRAME_Y1 - bar * 0.5, z), _metal_m)
	_box(host, Vector3(bar, outer_h - bar * 2.0, depth), Vector3(FRAME_X0 + bar * 0.5, mid_y, z), _metal_m)
	_box(host, Vector3(bar, outer_h - bar * 2.0, depth), Vector3(FRAME_X1 - bar * 0.5, mid_y, z), _metal_m)
	# Camera-facing highlight so the channel is not lost in shadow.
	var face_z: float = z + depth * 0.42
	_box(host, Vector3(outer_w, bar * 0.35, 0.02), Vector3(mid_x, FRAME_Y0 + bar * 0.35, face_z), _metal_l)
	_box(host, Vector3(outer_w, bar * 0.35, 0.02), Vector3(mid_x, FRAME_Y1 - bar * 0.35, face_z), _metal_l)
	_box(host, Vector3(bar * 0.35, outer_h - bar * 2.0, 0.02), Vector3(FRAME_X0 + bar * 0.35, mid_y, face_z), _metal_l)
	_box(host, Vector3(bar * 0.35, outer_h - bar * 2.0, 0.02), Vector3(FRAME_X1 - bar * 0.35, mid_y, face_z), _metal_l)
	# Inner lip so the pane is held in a metal channel, not flush with wood.
	var lip := 0.035
	var inner_w: float = outer_w - bar * 2.0
	var inner_h: float = outer_h - bar * 2.0
	_box(host, Vector3(inner_w, lip, depth * 0.55), Vector3(mid_x, FRAME_Y0 + bar + lip * 0.5, z + 0.01), _metal_m)
	_box(host, Vector3(inner_w, lip, depth * 0.55), Vector3(mid_x, FRAME_Y1 - bar - lip * 0.5, z + 0.01), _metal_m)
	_box(host, Vector3(lip, inner_h - lip * 2.0, depth * 0.55), Vector3(FRAME_X0 + bar + lip * 0.5, mid_y, z + 0.01), _metal_m)
	_box(host, Vector3(lip, inner_h - lip * 2.0, depth * 0.55), Vector3(FRAME_X1 - bar - lip * 0.5, mid_y, z + 0.01), _metal_m)
	_corner_plates(host, z)
	_rivets(host, z)
	var pane := MeshInstance3D.new()
	var quad := BoxMesh.new()
	quad.size = Vector3(inner_w - lip * 2.0, inner_h - lip * 2.0, 0.03)
	pane.mesh = quad
	pane.material_override = _glass_mat
	pane.position = Vector3(mid_x, mid_y, z + 0.03)
	host.add_child(pane)


static func add_lantern(host: Node3D, pos: Vector3) -> void:
	ensure_mats()
	var tex := Assets.tex(Assets.WALL_LANTERN)
	if tex != null:
		var sprite := Sprite3D.new()
		sprite.texture = tex
		sprite.pixel_size = 0.014
		sprite.shaded = true
		sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
		sprite.alpha_scissor_threshold = 0.5
		sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		sprite.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		sprite.centered = true
		sprite.position = pos + Vector3(0.06, float(tex.get_height()) * 0.014 * 0.5, 0)
		host.add_child(sprite)
		return
	_box(host, Vector3(0.08, 0.10, 0.08), pos + Vector3(0.02, 0.22, 0), _metal_d)
	_box(host, Vector3(0.16, 0.04, 0.16), pos + Vector3(0.08, 0.28, 0), _metal_m)
	_box(host, Vector3(0.16, 0.04, 0.16), pos + Vector3(0.08, 0.06, 0), _metal_m)
	for dx in [-0.07, 0.07]:
		for dz in [-0.07, 0.07]:
			_box(host, Vector3(0.02, 0.22, 0.02), pos + Vector3(0.08 + dx, 0.17, dz), _metal_l)
	var flame := MeshInstance3D.new()
	var sph := SphereMesh.new()
	sph.radius = 0.035
	sph.height = 0.07
	flame.mesh = sph
	var fmat := StandardMaterial3D.new()
	fmat.albedo_color = Color8(255, 186, 72)
	fmat.emission_enabled = true
	fmat.emission = Color8(220, 96, 28)
	fmat.emission_energy_multiplier = 2.2
	flame.material_override = fmat
	flame.position = pos + Vector3(0.08, 0.16, 0)
	flame.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	host.add_child(flame)


static func marker_label(pos: Vector3, size: int) -> Label3D:
	ensure_mats()
	var lab := Label3D.new()
	lab.position = pos
	lab.font_size = size
	if _marker_font != null:
		lab.font = _marker_font
	lab.modulate = INK
	lab.outline_modulate = INK_BLEED
	lab.outline_size = 16
	lab.pixel_size = 0.0022
	lab.shaded = false
	lab.no_depth_test = true
	lab.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	return lab


static func set_box_marker(host: Node3D, text: String) -> void:
	ensure_mats()
	var stale: Array[Node] = []
	for child in host.get_children():
		if child is Sprite3D and str(child.name).begins_with("Mk"):
			stale.append(child)
	for child in stale:
		child.free()
	if _digit_tex == null:
		return
	var px := 0.0048
	var cell := 16
	var gw: int = _digit_tex.get_width() / cell
	var origin_x: float = -float(text.length() - 1) * cell * px * 0.5
	for i in text.length():
		var ch := text.substr(i, 1)
		var idx := DIGIT_ORDER.find(ch)
		if idx < 0:
			continue
		var sprite := Sprite3D.new()
		sprite.name = "Mk%d" % i
		sprite.texture = _digit_tex
		sprite.region_enabled = true
		sprite.region_rect = Rect2((idx % gw) * cell, (idx / gw) * cell, cell, cell)
		sprite.pixel_size = px
		sprite.shaded = true
		sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
		sprite.alpha_scissor_threshold = 0.5
		sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		sprite.position = Vector3(origin_x + float(i) * cell * px, 0, 0.002)
		host.add_child(sprite)


static func add_board_chains(host: Node3D, board_pos: Vector3) -> void:
	ensure_mats()
	var top_y: float = FRAME_Y1 - FRAME_BAR * 0.5
	for side in [-0.22, 0.22]:
		var x: float = board_pos.x + side
		var y := board_pos.y + 0.20
		while y < top_y:
			_box(host, Vector3(0.018, 0.04, 0.018), Vector3(x, y, board_pos.z - 0.01), _metal_m)
			y += 0.055


static func _floor_planks(host: Node3D) -> void:
	var plank_w := 0.19
	var gap := 0.012
	var x := ROOM_X0 + 0.02
	var i := 0
	var depth: float = ROOM_Z1 - ROOM_Z0 - 0.04
	var zmid: float = (ROOM_Z0 + ROOM_Z1) * 0.5
	while x + plank_w < ROOM_X1:
		var h := 0.045 + float(i % 3) * 0.004
		_box(host, Vector3(plank_w, h, depth), Vector3(x + plank_w * 0.5, FLOOR_Y + h * 0.5 - 0.01, zmid),
				_floor_mats[i % _floor_mats.size()])
		x += plank_w + gap
		i += 1


static func _wall_slabs(host: Node3D) -> void:
	var mat: StandardMaterial3D = _wall_mats[0]
	var depth: float = ROOM_Z1 - ROOM_Z0 - 0.02
	var zmid: float = (ROOM_Z0 + ROOM_Z1) * 0.5
	var height: float = ROOM_Y1 - 0.04
	var ymid: float = 0.04 + height * 0.5
	_box(host, Vector3(0.16, height, depth), Vector3(ROOM_X0 - 0.08, ymid, zmid), mat)
	_box(host, Vector3(0.16, height, depth), Vector3(ROOM_X1 + 0.08, ymid, zmid), mat)
	var width: float = ROOM_X1 - ROOM_X0 + 0.16
	var xmid: float = (ROOM_X0 + ROOM_X1) * 0.5
	_box(host, Vector3(width, height, 0.16), Vector3(xmid, ymid, ROOM_Z0 - 0.08), mat)
	_box(host, Vector3(width, 0.08, depth), Vector3(xmid, ROOM_Y1 + 0.04, zmid), mat)


static func _wall_planks(host: Node3D, x_center: float, thick: float) -> void:
	var plank_h := 0.17
	var gap := 0.01
	var y := 0.04
	var i := 0
	var depth: float = ROOM_Z1 - ROOM_Z0 - 0.02
	var zmid: float = (ROOM_Z0 + ROOM_Z1) * 0.5
	while y + plank_h < ROOM_Y1:
		_box(host, Vector3(thick, plank_h, depth), Vector3(x_center, y + plank_h * 0.5, zmid),
				_wall_mats[i % _wall_mats.size()])
		y += plank_h + gap
		i += 1


static func _back_planks(host: Node3D) -> void:
	var plank_h := 0.17
	var gap := 0.01
	var y := 0.04
	var i := 0
	var width: float = ROOM_X1 - ROOM_X0 + 0.16
	var xmid: float = (ROOM_X0 + ROOM_X1) * 0.5
	while y + plank_h < ROOM_Y1:
		_box(host, Vector3(width, plank_h, 0.16), Vector3(xmid, y + plank_h * 0.5, ROOM_Z0 - 0.08),
				_wall_mats[(i + 1) % _wall_mats.size()])
		y += plank_h + gap
		i += 1


static func _ceiling_planks(host: Node3D) -> void:
	var plank_w := 0.20
	var gap := 0.012
	var x := ROOM_X0 + 0.02
	var i := 0
	var depth: float = ROOM_Z1 - ROOM_Z0 - 0.04
	var zmid: float = (ROOM_Z0 + ROOM_Z1) * 0.5
	while x + plank_w < ROOM_X1:
		_box(host, Vector3(plank_w, 0.06, depth), Vector3(x + plank_w * 0.5, ROOM_Y1 + 0.03, zmid),
				_wall_mats[i % _wall_mats.size()])
		x += plank_w + gap
		i += 1


static func _beam(host: Node3D, x: float) -> void:
	_box(host, Vector3(0.16, 0.14, ROOM_Z1 - ROOM_Z0 - 0.2),
			Vector3(x, ROOM_Y1 - 0.08, (ROOM_Z0 + ROOM_Z1) * 0.5), _floor_mats[0])


static func _corner_plates(host: Node3D, z: float) -> void:
	var arm := 0.18
	var t := 0.045
	var d := FRAME_DEPTH + 0.02
	var corners: Array[Vector2] = [
		Vector2(FRAME_X0 + FRAME_BAR, FRAME_Y0 + FRAME_BAR),
		Vector2(FRAME_X1 - FRAME_BAR, FRAME_Y0 + FRAME_BAR),
		Vector2(FRAME_X0 + FRAME_BAR, FRAME_Y1 - FRAME_BAR),
		Vector2(FRAME_X1 - FRAME_BAR, FRAME_Y1 - FRAME_BAR),
	]
	for corner in corners:
		var dx: float = arm * 0.35 if corner.x < 0.0 else -arm * 0.35
		var dy: float = arm * 0.35 if corner.y < 1.0 else -arm * 0.35
		_box(host, Vector3(arm, t, d), Vector3(corner.x + dx, corner.y, z - 0.01), _metal_m)
		_box(host, Vector3(t, arm, d), Vector3(corner.x, corner.y + dy, z - 0.01), _metal_m)


static func _rivets(host: Node3D, z: float) -> void:
	var mid_x: float = (FRAME_X0 + FRAME_X1) * 0.5
	for x in [FRAME_X0 + 0.22, mid_x, FRAME_X1 - 0.22]:
		_rivet(host, Vector3(x, FRAME_Y0 + FRAME_BAR * 0.5, z + 0.09))
		_rivet(host, Vector3(x, FRAME_Y1 - FRAME_BAR * 0.5, z + 0.09))
	for y in [0.55, 1.15, 1.75]:
		_rivet(host, Vector3(FRAME_X0 + FRAME_BAR * 0.5, y, z + 0.09))
		_rivet(host, Vector3(FRAME_X1 - FRAME_BAR * 0.5, y, z + 0.09))


static func _rivet(host: Node3D, pos: Vector3) -> void:
	var mi := MeshInstance3D.new()
	var sph := SphereMesh.new()
	sph.radius = 0.018
	sph.height = 0.036
	mi.mesh = sph
	mi.material_override = _metal_hi
	mi.position = pos
	host.add_child(mi)


static func _wood_set(tex: Texture2D, vary_tint: bool, uv_scale: Vector3) -> Array[StandardMaterial3D]:
	var out: Array[StandardMaterial3D] = []
	var tints: Array[Color] = [Color.WHITE]
	if vary_tint:
		tints = [
			Color(0.78, 0.72, 0.68),
			Color(0.92, 0.88, 0.82),
			Color(1.05, 0.98, 0.90),
		]
	for tint in tints:
		var mat := StandardMaterial3D.new()
		mat.albedo_texture = tex
		mat.albedo_color = tint
		mat.roughness = 0.88
		mat.metallic = 0.0
		mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		mat.uv1_triplanar = true
		mat.uv1_world_triplanar = true
		mat.uv1_triplanar_sharpness = 4.0
		mat.uv1_scale = uv_scale
		out.append(mat)
	return out


static func _metal(color: Color, metallic: float, rough: float) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.metallic = metallic
	mat.roughness = rough
	return mat


static func _lit(color: Color, rough: float, metallic: float) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = rough
	mat.metallic = metallic
	return mat


static func _box(host: Node3D, size: Vector3, pos: Vector3, mat: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mi.mesh = box
	mi.material_override = mat
	mi.position = pos
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	host.add_child(mi)
	return mi


static func _slab(host: Node3D, size: Vector3, pos: Vector3, mat: Material) -> void:
	_box(host, size, pos, mat)


static func _grain_tex(seed_n: int, vertical: bool) -> ImageTexture:
	var img := Image.create(64, 64, false, Image.FORMAT_RGBA8)
	var n := FastNoiseLite.new()
	n.seed = seed_n
	n.noise_type = FastNoiseLite.TYPE_VALUE
	n.frequency = 0.11
	n.fractal_octaves = 3
	for y in 64:
		for x in 64:
			var nx: float = float(x) * (0.35 if vertical else 2.4)
			var ny: float = float(y) * (2.4 if vertical else 0.35)
			var t: float = n.get_noise_2d(nx, ny)
			var c: Color = WOOD_M
			if t < -0.22:
				c = WOOD_D
			elif t > 0.28:
				c = WOOD_L
			var seam: int = (x if vertical else y) % 21
			if seam <= 1:
				c = OUTLINE if seam == 0 else WOOD_D
			img.set_pixel(x, y, c)
	return ImageTexture.create_from_image(img)
