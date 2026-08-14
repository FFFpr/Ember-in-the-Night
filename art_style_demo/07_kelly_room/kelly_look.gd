extends RefCounted
## Room shell for the Kelly room: timber box, posts and beam around the glass,
## riveted apron, glass pane with the frosted writing patch, lantern, side window.
##
## Geometry comes from kelly_layout, which resolves fit-list screen anchors. Wall
## props (lantern, side window) are camera-facing sprites: at those anchors the
## side walls are almost edge-on, so a wall-aligned quad would be a sliver.

const Assets := preload("res://art_style_demo/07_kelly_room/kelly_assets.gd")
const Layout := preload("res://art_style_demo/07_kelly_room/kelly_layout.gd")

const WOOD_D := Color8(62, 38, 28)
const WOOD_M := Color8(118, 72, 42)
const WOOD_L := Color8(176, 118, 62)
const METAL_D := Color8(48, 46, 58)
const METAL_M := Color8(92, 90, 102)
const METAL_L := Color8(168, 158, 148)
const METAL_HI := Color8(232, 214, 176)
const OUTLINE := Color8(28, 22, 26)
const NIGHT := Color8(22, 32, 52)
const EMBER_L := Color8(255, 186, 72)
const EMBER_M := Color8(220, 96, 28)

## Wall tiles are authored at this density; see pixel-art-standard.md.
const WALL_PX_PER_M := 100.0

var layout: Layout
var glass_rect: Dictionary
var _wall_mat: StandardMaterial3D
var _floor_mat: StandardMaterial3D
var _iron_mat: StandardMaterial3D
var _glass_mat: StandardMaterial3D
var _frost_mat: StandardMaterial3D
var _dark_mat: StandardMaterial3D


func _init(layout_data: Layout) -> void:
	layout = layout_data
	glass_rect = layout.place("glass", layout.wall_depth())
	_build_materials()


func _build_materials() -> void:
	_wall_mat = _wood(Assets.tex(Assets.WOOD_WALL), 23, true)
	_floor_mat = _wood(Assets.tex(Assets.WOOD_FLOOR), 11, false)
	_iron_mat = _plain(METAL_D, 0.55, 0.35)
	var iron_tex := Assets.tex(Assets.IRON_APRON)
	if iron_tex != null:
		_iron_mat.albedo_texture = iron_tex
		_iron_mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		_iron_mat.uv1_triplanar = true
		_iron_mat.uv1_world_triplanar = true
		# Same density as the wall/floor tiles: 64 px at 100 px/m → 0.64 m per repeat.
		var repeats: float = WALL_PX_PER_M / 64.0
		_iron_mat.uv1_scale = Vector3(repeats, repeats, repeats)
	_glass_mat = StandardMaterial3D.new()
	_glass_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_glass_mat.albedo_color = Color(0.42, 0.55, 0.52, 0.11)
	_glass_mat.roughness = 0.08
	_glass_mat.metallic = 0.2
	_glass_mat.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_DISABLED
	_glass_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	# Writing patch: less transparent and rougher, so black marker reads on it.
	_frost_mat = StandardMaterial3D.new()
	_frost_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_frost_mat.albedo_color = Color(0.18, 0.20, 0.19, 0.78)
	_frost_mat.roughness = 0.85
	_frost_mat.metallic = 0.0
	_frost_mat.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_DISABLED
	_dark_mat = _plain(Color8(14, 16, 22), 0.95, 0.0)


## Builds the shell and returns the nodes the fit list names.
func build(host: Node3D) -> Dictionary:
	var out := {}
	_floor(host)
	_side_walls(host)
	_ceiling(host)
	_far_wall(host)
	_market_interior(host)
	_beam(host)
	out["glass"] = _glass(host)
	out["lantern"] = _lantern(host)
	out["side_window"] = _side_window(host)
	return out


func glass_left() -> float:
	return glass_rect["origin"].x - glass_rect["size"].x * 0.5


func glass_right() -> float:
	return glass_rect["origin"].x + glass_rect["size"].x * 0.5


func glass_bottom() -> float:
	return glass_rect["origin"].y - glass_rect["size"].y * 0.5


func glass_top() -> float:
	return glass_rect["origin"].y + glass_rect["size"].y * 0.5


func _floor(host: Node3D) -> void:
	var depth: float = 1.6 - Layout.WALL_Z
	var mi := _box(host, "Floor",
			Vector3(Layout.ROOM_HALF_W * 2.0, 0.12, depth),
			Vector3(0.0, -0.06, Layout.WALL_Z + depth * 0.5), _floor_mat)
	# Boards run toward the camera, so the texture's long axis follows z.
	mi.rotation_degrees.y = 90.0


func _side_walls(host: Node3D) -> void:
	var depth: float = 1.6 - Layout.WALL_Z
	var z: float = Layout.WALL_Z + depth * 0.5
	for sx in [-1.0, 1.0]:
		_box(host, "SideWall", Vector3(0.16, Layout.CEIL_Y, depth),
				Vector3(sx * (Layout.ROOM_HALF_W + 0.08), Layout.CEIL_Y * 0.5, z), _wall_mat)


func _ceiling(host: Node3D) -> void:
	var depth: float = 1.6 - Layout.WALL_Z
	_box(host, "Ceiling", Vector3(Layout.ROOM_HALF_W * 2.0 + 0.16, 0.12, depth),
			Vector3(0.0, Layout.CEIL_Y + 0.06, Layout.WALL_Z + depth * 0.5), _wall_mat)


func _far_wall(host: Node3D) -> void:
	var z: float = Layout.WALL_Z - 0.08
	var w: float = Layout.ROOM_HALF_W * 2.0 + 0.16
	# Riveted iron apron under the sill, timber lintel above, timber posts beside.
	_box(host, "Apron", Vector3(w, glass_bottom(), 0.16),
			Vector3(0.0, glass_bottom() * 0.5, z), _iron_mat)
	var lintel_h: float = Layout.CEIL_Y - glass_top()
	_box(host, "Lintel", Vector3(w, lintel_h, 0.16),
			Vector3(0.0, glass_top() + lintel_h * 0.5, z), _wall_mat)
	var post_w: float = Layout.ROOM_HALF_W - glass_right()
	for sx in [-1.0, 1.0]:
		var cx: float = sx * (glass_right() + post_w * 0.5)
		_box(host, "Post", Vector3(post_w, glass_rect["size"].y, 0.24),
				Vector3(cx, glass_rect["origin"].y, Layout.WALL_Z - 0.04), _wall_mat)


func _market_interior(host: Node3D) -> void:
	# The volume seen through the glass. Dark, so the gold reads as the bright mass.
	var depth := 2.2
	var z: float = Layout.WALL_Z - depth * 0.5
	_box(host, "MarketBack", Vector3(glass_rect["size"].x + 0.6, 0.12, depth),
			Vector3(glass_rect["origin"].x, glass_top() + 0.06, z), _dark_mat)
	_box(host, "MarketFloor", Vector3(glass_rect["size"].x + 0.6, 0.12, depth),
			Vector3(glass_rect["origin"].x, -0.06, z), _dark_mat)
	_box(host, "MarketWall", Vector3(glass_rect["size"].x + 0.6, glass_top() + 0.2, 0.12),
			Vector3(glass_rect["origin"].x, (glass_top() + 0.2) * 0.5, Layout.WALL_Z - depth), _dark_mat)
	for sx in [-1.0, 1.0]:
		_box(host, "MarketSide", Vector3(0.12, glass_top() + 0.2, depth),
				Vector3(glass_rect["origin"].x + sx * (glass_rect["size"].x * 0.5 + 0.24),
						(glass_top() + 0.2) * 0.5, z), _dark_mat)


func _beam(host: Node3D) -> void:
	var h := 0.30
	var y: float = Layout.CEIL_Y - h * 0.5 - 0.04
	var mi := _box(host, "Beam", Vector3(Layout.ROOM_HALF_W * 2.0 + 0.16, h, 0.34),
			Vector3(0.0, y, Layout.WALL_Z + 0.55), _wall_mat)
	var beam_tex := Assets.tex(Assets.BEAM)
	if beam_tex != null:
		var mat := _plain(Color.WHITE, 0.85, 0.0)
		mat.albedo_texture = beam_tex
		mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		mat.uv1_scale = Vector3(8.0, 1.0, 1.0)
		mi.material_override = mat


func _glass(host: Node3D) -> MeshInstance3D:
	var pane := _quad(host, "GlassPane", glass_rect["size"],
			glass_rect["origin"] + Vector3(0, 0, 0.03), _glass_mat)
	pane.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return pane


## Frosted patch behind the formula, the equals sign and the sticker.
func add_writing_patch(host: Node3D, ids: PackedStringArray) -> MeshInstance3D:
	var lo := Vector2(INF, INF)
	var hi := Vector2(-INF, -INF)
	for id in ids:
		var item: Dictionary = layout.fit.items[id]
		var centre: Vector2 = item["centre"]
		var size: Vector2 = item["size"]
		if size.x < 0.0:
			size = Vector2(0.03, 0.03)
		lo = Vector2(minf(lo.x, centre.x - size.x * 0.5), minf(lo.y, centre.y - size.y * 0.5))
		hi = Vector2(maxf(hi.x, centre.x + size.x * 0.5), maxf(hi.y, centre.y + size.y * 0.5))
	var pad := Vector2(0.022, 0.030)
	lo -= pad
	hi += pad
	var depth: float = layout.wall_depth() - 0.06
	var centre_uv: Vector2 = (lo + hi) * 0.5
	var patch := _quad(host, "WritingPatch", layout.size_at(hi - lo, depth),
			layout.world_at(centre_uv, depth), _frost_mat)
	patch.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return patch


func _lantern(host: Node3D) -> Node3D:
	var item: Dictionary = layout.fit.items["lantern"]
	var centre: Vector2 = item["centre"]
	var depth: float = layout.depth_on_side_wall(centre.x, -Layout.ROOM_HALF_W + 0.14)
	var size: Vector2 = layout.size_at(item["size"], depth)
	var pos: Vector3 = layout.world_at(centre, depth)
	var node := Node3D.new()
	node.name = "Lantern"
	node.position = pos
	host.add_child(node)
	var tex := Assets.tex(Assets.WALL_LANTERN)
	if tex != null:
		var sprite := _sprite(tex, size.y / float(tex.get_height()))
		sprite.name = "LanternSprite"
		layout.fit_sprite_to(sprite, size)
		node.add_child(sprite)
	else:
		var body := _quad(node, "LanternBox", size, Vector3.ZERO, _plain(METAL_D, 0.7, 0.4))
		body.position = Vector3.ZERO
		var flame := _quad(node, "LanternFlame", size * Vector2(0.45, 0.22),
				Vector3(0.0, -size.y * 0.19, 0.02), _emissive(EMBER_L, EMBER_M, 2.0))
		flame.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var lamp := OmniLight3D.new()
	lamp.name = "LanternLight"
	# Sibling of the lantern node so its radius is not part of the silhouette.
	lamp.position = pos + Vector3(0.08, -size.y * 0.19, 0.18)
	lamp.light_color = EMBER_L
	lamp.light_energy = 1.55
	lamp.omni_range = 2.6
	lamp.omni_attenuation = 2.2
	lamp.shadow_enabled = true
	host.add_child(lamp)
	return node


func _side_window(host: Node3D) -> Node3D:
	var item: Dictionary = layout.fit.items["side_window"]
	var centre: Vector2 = item["centre"]
	var depth: float = layout.depth_on_side_wall(centre.x, Layout.ROOM_HALF_W - 0.14)
	var size: Vector2 = layout.size_at(item["size"], depth)
	var pos: Vector3 = layout.world_at(centre, depth)
	var node := Node3D.new()
	node.name = "SideWindow"
	node.position = pos
	host.add_child(node)
	var tex := Assets.tex(Assets.SIDE_WINDOW)
	if tex != null:
		var sprite := _sprite(tex, size.y / float(tex.get_height()))
		sprite.name = "SideWindowSprite"
		layout.fit_sprite_to(sprite, size)
		node.add_child(sprite)
	else:
		var pane := _quad(node, "SideWindowPane", size, Vector3.ZERO,
				_emissive(Color8(96, 132, 186), NIGHT, 0.55))
		pane.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	# Cool spill so the lever and coin box read on the dark right wall without
	# lifting the whole frame (lantern stays the only warm bright source).
	var spill := OmniLight3D.new()
	spill.name = "WindowFill"
	spill.position = pos + Vector3(-0.35, -0.05, 0.22)
	spill.light_color = Color8(110, 148, 198)
	spill.light_energy = 0.55
	spill.omni_range = 1.8
	spill.omni_attenuation = 2.6
	spill.shadow_enabled = false
	host.add_child(spill)
	return node


func _sprite(tex: Texture2D, pixel_size: float) -> Sprite3D:
	var s := Sprite3D.new()
	s.texture = tex
	s.pixel_size = pixel_size
	s.shaded = true
	s.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	s.alpha_scissor_threshold = 0.5
	s.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	s.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	s.centered = true
	return s


func _wood(tex: Texture2D, seed_n: int, vertical: bool) -> StandardMaterial3D:
	var mat := _plain(Color(0.55, 0.48, 0.42), 0.92, 0.0)
	mat.albedo_texture = tex if tex != null else _grain(seed_n, vertical)
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	mat.uv1_triplanar = true
	mat.uv1_world_triplanar = true
	mat.uv1_triplanar_sharpness = 4.0
	# 64 px tile at WALL_PX_PER_M covers 0.64 m, so one repeat per 0.64 m.
	var repeats: float = WALL_PX_PER_M / 64.0
	mat.uv1_scale = Vector3(repeats, repeats, repeats)
	return mat


func _plain(color: Color, rough: float, metallic: float) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = rough
	mat.metallic = metallic
	return mat


func _emissive(albedo: Color, emit: Color, energy: float) -> StandardMaterial3D:
	var mat := _plain(albedo, 0.6, 0.0)
	mat.emission_enabled = true
	mat.emission = emit
	mat.emission_energy_multiplier = energy
	return mat


func _box(host: Node3D, name_hint: String, size: Vector3, pos: Vector3,
		mat: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.name = name_hint
	var box := BoxMesh.new()
	box.size = size
	mi.mesh = box
	mi.material_override = mat
	mi.position = pos
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	host.add_child(mi)
	return mi


func _quad(host: Node3D, name_hint: String, size: Vector2, pos: Vector3,
		mat: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.name = name_hint
	var quad := QuadMesh.new()
	quad.size = size
	mi.mesh = quad
	mi.material_override = mat
	mi.position = pos
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	host.add_child(mi)
	return mi


func _grain(seed_n: int, vertical: bool) -> ImageTexture:
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
			var c: Color = WOOD_D
			if t < -0.18:
				c = OUTLINE
			elif t > 0.22:
				c = WOOD_M
			# Long boards: one seam per tile, not a staggered brick grid.
			var seam: int = (x if vertical else y) % 32
			if seam == 0:
				c = OUTLINE
			img.set_pixel(x, y, c)
	return ImageTexture.create_from_image(img)
