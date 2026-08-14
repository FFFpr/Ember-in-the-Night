extends Node3D
## Locked-camera Kelly gambling room.
##
## Round rules live in kelly_round.gd. Everything visual is positioned from the
## approved fit list through kelly_layout, so the scene cannot drift from the
## target: art_style_demo/references/kelly_room/fit_list.md.

const Round := preload("res://art_style_demo/07_kelly_room/kelly_round.gd")
const CoinActor := preload("res://art_style_demo/07_kelly_room/coin_actor.gd")
const Assets := preload("res://art_style_demo/07_kelly_room/kelly_assets.gd")
const Fit := preload("res://art_style_demo/07_kelly_room/kelly_fit.gd")
const Layout := preload("res://art_style_demo/07_kelly_room/kelly_layout.gd")
const Look := preload("res://art_style_demo/07_kelly_room/kelly_look.gd")
const Market := preload("res://art_style_demo/07_kelly_room/kelly_market.gd")
const Marker := preload("res://art_style_demo/07_kelly_room/kelly_marker.gd")

## Marker ink reads dark on the whiteboard and the wooden box, and light on the
## dark frosted glass — the sample shows both, and legibility decides which.
const INK_DARK := Color8(28, 22, 26)
const INK_LIGHT := Color8(226, 222, 208)
const OUTLINE := Color8(28, 22, 26)
const PAPER := Color8(236, 232, 222)
const METAL_D := Color8(48, 46, 58)
const METAL_M := Color8(92, 90, 102)
const KRAFT := Color8(198, 158, 106)
const EMBER_L := Color8(255, 186, 72)

const DRAG_PX := 6.0
const FLOOR_Y := 0.02

var _fit: Fit
var _layout: Layout
var _look: Look
var _market: Market
var _round: Round
var _rng := RandomNumberGenerator.new()

var _busy := false
var _pressing := false
var _dragging := false
var _drag_start := Vector2.ZERO

var _camera: Camera3D
var _fit_nodes: Dictionary = {}
var _box: Node3D
var _box_marker_root: Node3D
var _box_digits  # kelly_marker.gd
var _box_marker_fallback: Label3D
var _box_slot: Vector3
var _lever: Node3D
var _lever_arm: Node3D
var _lever_sprite: Sprite3D
var _outlet: Node3D
var _valve: Node3D
var _sticker: Node3D
var _board_label: Label3D
var _formula_l1: Label3D
var _formula_l2: Label3D
var _kelly_digits  # kelly_marker.gd
var _kelly_root: Node3D
var _kelly_fallback: Label3D
var _count_label: Label
var _select_rect: ColorRect
var _floor_coins: Array[Node3D] = []
var _selected_coins: Array[Node3D] = []
var _player_coins: Node3D
var _coin_diameter: float
var _coin_tex: Texture2D


func _ready() -> void:
	_rng.randomize()
	_fit = Fit.new()
	if not _fit.ok():
		for problem in _fit.errors:
			push_error("Kelly room fit list: %s" % problem)
		return
	_layout = Layout.new(_fit, Vector2(get_viewport().size))
	_camera = _layout.build_camera(self)
	_coin_tex = Assets.tex(Assets.COIN_FLAT)
	_round = Round.new()
	_build_world()
	_build_hud()
	_round.begin_round(1, _rng)
	_spawn_player_coins(_round.floor_count)
	_refresh_diegetic()


func _process(delta: float) -> void:
	_follow_selected(delta)
	_update_box_hover()
	_update_count_label()
	if _dragging:
		_update_select_rect(get_viewport().get_mouse_position())


## Node that the fit list item `id` refers to. Used by the acceptance check.
func fit_node(id: String) -> Node3D:
	return _fit_nodes.get(id)


## Screen rect of a node, same computation the hit tests use.
func screen_rect(node: Node3D) -> Rect2:
	return _layout.screen_rect(node)


func _build_world() -> void:
	_make_env()
	_look = Look.new(_layout)
	var shell: Dictionary = _look.build(self)
	for id in shell:
		_fit_nodes[id] = shell[id]
	_market = Market.new(_layout)
	_fit_nodes["coin_mass"] = _market.build(self)
	_player_coins = Node3D.new()
	_player_coins.name = "PlayerCoins"
	add_child(_player_coins)
	_make_outlet()
	_make_box()
	_make_lever()
	_make_board()
	_make_formula()
	_report_missing_art()


func _make_env() -> void:
	var world := WorldEnvironment.new()
	world.name = "Env"
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color8(10, 12, 18)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color8(30, 38, 54)
	# Night interior: point lights carry the frame, ambient only lifts black.
	# Real wall/floor/apron tiles read darker than greybox; keep mean in 30–50.
	env.ambient_light_energy = 0.14
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.tonemap_exposure = 1.05
	env.glow_enabled = true
	env.glow_intensity = 0.16
	env.glow_bloom = 0.03
	world.environment = env
	add_child(world)


## Small local light so a marked surface stays readable without lifting the frame.
## Kept tight on purpose: a wide fill would fail the edge/P90 gate.
func _add_reading_light(target: Vector3, energy: float, range_m: float) -> void:
	var lamp := OmniLight3D.new()
	lamp.name = "ReadingLight"
	lamp.position = target + Vector3(0.0, 0.06, 0.42)
	lamp.light_color = Color8(255, 232, 198)
	lamp.light_energy = energy
	lamp.omni_range = range_m
	lamp.omni_attenuation = 3.0
	lamp.shadow_enabled = false
	add_child(lamp)


## Placeholder for a pixel sprite: a camera-facing plate of exactly the target
## silhouette, so greybox and the finished art occupy the same screen rect.
func _greybox_plate(parent: Node3D, node_name: String, size: Vector2,
		fill: Color) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.name = node_name
	var quad := QuadMesh.new()
	quad.size = size
	mi.mesh = quad
	var mat := StandardMaterial3D.new()
	mat.albedo_texture = _plate_tex(fill)
	mat.roughness = 0.8
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	mi.material_override = mat
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	parent.add_child(mi)
	return mi


static var _plate_cache: Dictionary = {}


func _plate_tex(fill: Color) -> Texture2D:
	var key := fill.to_rgba32()
	if _plate_cache.has(key):
		return _plate_cache[key]
	var img := Image.create(16, 16, false, Image.FORMAT_RGBA8)
	for y in 16:
		for x in 16:
			var edge: bool = x == 0 or y == 0 or x == 15 or y == 15
			var shade: float = 1.0 - float(y) * 0.012
			img.set_pixel(x, y, OUTLINE if edge else Color(
					fill.r * shade, fill.g * shade, fill.b * shade))
	var tex := ImageTexture.create_from_image(img)
	_plate_cache[key] = tex
	return tex


## Scales a Label3D so its drawn box matches a target rect from the fit list.
func _fit_label(label: Label3D, target_w: float, target_h: float) -> void:
	var aabb: AABB = label.get_aabb()
	if aabb.size.x <= 0.0 or aabb.size.y <= 0.0:
		return
	var sx := 1.0 if target_w <= 0.0 else target_w / aabb.size.x
	var sy := 1.0 if target_h <= 0.0 else target_h / aabb.size.y
	label.pixel_size *= minf(sx, sy)


func _make_outlet() -> void:
	var depth: float = _layout.wall_depth() - 0.10
	var slot: Dictionary = _layout.place("outlet", depth)
	var size: Vector2 = slot["size"]
	_outlet = Node3D.new()
	_outlet.name = "Outlet"
	_outlet.position = slot["origin"]
	add_child(_outlet)
	# Prefer closed for idle; if only open has landed, mount that so fan-in is visible.
	var tex := Assets.tex(Assets.OUTLET_CLOSED)
	if tex == null:
		tex = Assets.tex(Assets.OUTLET_OPEN)
	if tex != null:
		var sprite := Sprite3D.new()
		sprite.name = "OutletSprite"
		sprite.texture = tex
		sprite.shaded = true
		sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
		sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		# Texture pivot is bottom-centre (32,47 on 64x48); fit-list places the
		# hatch by screen centre, so keep Sprite3D centered and stretch to size.
		sprite.centered = true
		_layout.fit_sprite_to(sprite, size)
		_outlet.add_child(sprite)
	else:
		_greybox_plate(_outlet, "OutletHatch", size, METAL_M)
	# Recessed channel behind the hatch so depth occludes coins in transit. Kept
	# outside the fit node: only the hatch face defines the silhouette.
	var channel := _mesh_box(self, "OutletChannel",
			Vector3(size.x * 0.9, size.y * 0.8, 0.5),
			_outlet.position + Vector3(0.0, 0.0, -0.32), Color8(12, 12, 16))
	channel.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_fit_nodes["outlet"] = _outlet


func _make_box() -> void:
	var slot: Dictionary = _layout.place_on_floor("coin_box")
	var size: Vector2 = slot["size"]
	_box = Node3D.new()
	_box.name = "CoinBox"
	_box.position = slot["origin"]
	add_child(_box)
	var tex := Assets.tex(Assets.COIN_BOX)
	if tex != null:
		var sprite := Sprite3D.new()
		sprite.name = "CoinBoxSprite"
		sprite.texture = tex
		sprite.shaded = true
		sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
		sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		sprite.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		sprite.centered = true
		_layout.fit_sprite_to(sprite, size)
		_box.add_child(sprite)
	else:
		_greybox_plate(_box, "CoinBoxPlate", size, Color8(122, 78, 46))
		var slot_plate := _greybox_plate(_box, "CoinBoxSlot",
				Vector2(size.x * 0.42, size.y * 0.045), OUTLINE)
		slot_plate.position = Vector3(0.0, size.y * 0.4, 0.01)
	_box_slot = _box.position + Vector3(0.0, size.y * 0.45, 0.0)
	var marker: Dictionary = _layout.fit.items["box_marker"]
	var marker_h: float = marker["text_height"]
	if marker_h <= 0.0:
		marker_h = 0.08
	var marker_pos: Vector3 = _layout.world_at(marker["centre"],
			slot["depth"] - size.x * 0.45)
	var marker_line_h: float = _layout.height_at(marker_h, slot["depth"])
	_box_digits = Marker.new()
	_box_marker_root = _box_digits.build(self, "BoxMarker", marker_line_h, INK_DARK)
	_box_marker_root.position = marker_pos
	if not _box_digits.available():
		_box_marker_fallback = _marker_label("BoxMarkerFallback", Vector3.ZERO,
				marker_line_h, INK_DARK)
		_box_marker_root.add_child(_box_marker_fallback)
	_fit_nodes["coin_box"] = _box
	_fit_nodes["box_marker"] = _box_marker_root
	_add_reading_light(marker_pos, 0.4, 0.9)


func _make_lever() -> void:
	var slot: Dictionary = _layout.place_on_floor("lever")
	var size: Vector2 = slot["size"]
	_lever = Node3D.new()
	_lever.name = "Lever"
	_lever.position = slot["origin"]
	add_child(_lever)
	var tex := Assets.tex(Assets.LEVER)
	if tex != null:
		_lever_sprite = Sprite3D.new()
		_lever_sprite.name = "LeverSprite"
		_lever_sprite.texture = tex
		_lever_sprite.shaded = true
		_lever_sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
		_lever_sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		_lever_sprite.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		_lever_sprite.centered = true
		_layout.fit_sprite_to(_lever_sprite, size)
		_lever.add_child(_lever_sprite)
	else:
		_greybox_plate(_lever, "LeverPlate", size, METAL_M)
	_fit_nodes["lever"] = _lever


func _make_board() -> void:
	var depth: float = _layout.wall_depth() - 0.22
	var slot: Dictionary = _layout.place("whiteboard", depth)
	var size: Vector2 = slot["size"]
	var board := Node3D.new()
	board.name = "Whiteboard"
	board.position = slot["origin"]
	add_child(board)
	var panel: Node3D
	var tex := Assets.tex(Assets.WHITEBOARD)
	if tex != null:
		var sprite := Sprite3D.new()
		sprite.name = "WhiteboardSprite"
		sprite.texture = tex
		sprite.shaded = true
		sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
		sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		sprite.centered = true
		_layout.fit_sprite_to(sprite, size)
		board.add_child(sprite)
		panel = sprite
	else:
		panel = _greybox_plate(board, "WhiteboardPanel", size, PAPER)
		# Greybox only: issue_32 whiteboard.png already paints the dual chains.
		var chain_top: float = maxf(_look.glass_top() - board.position.y, 0.05)
		for sx in [-0.42, 0.42]:
			var chain := _mesh_box(self, "BoardChain",
					Vector3(size.x * 0.022, chain_top, size.x * 0.022),
					board.position + Vector3(size.x * sx, size.y * 0.5 + chain_top * 0.5, -0.02),
					METAL_M)
			chain.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_board_label = _marker_label("BoardText", Vector3(0, 0, 0.03),
			_layout.height_at(0.032, depth), INK_DARK)
	_board_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	board.add_child(_board_label)
	_fit_nodes["whiteboard"] = panel
	_add_reading_light(board.position, 0.55, 1.0)


func _make_formula() -> void:
	# Marker on the glass; the frosted patch behind it is what makes it readable.
	var depth: float = _layout.wall_depth() - 0.05
	_look.add_writing_patch(self, ["formula_l1", "formula_l2", "equals", "sticker"])
	_formula_l1 = _place_marker("FormulaL1", "formula_l1", depth, 0.035)
	_formula_l2 = _place_marker("FormulaL2", "formula_l2", depth, 0.030)
	var equals := _place_marker("Equals", "equals", depth, 0.035)
	equals.text = "="
	_fit_nodes["equals"] = equals
	var sticker_slot: Dictionary = _layout.place("sticker", depth)
	var sticker_size: Vector2 = sticker_slot["size"]
	var tex := Assets.tex(Assets.STICKER)
	if tex != null:
		var sprite := Sprite3D.new()
		sprite.name = "Sticker"
		sprite.texture = tex
		sprite.shaded = true
		sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
		sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		sprite.centered = true
		_layout.fit_sprite_to(sprite, sticker_size)
		sprite.position = sticker_slot["origin"]
		add_child(sprite)
		_sticker = sprite
	else:
		_sticker = _mesh_box(self, "Sticker",
				Vector3(sticker_size.x, sticker_size.y, 0.02),
				sticker_slot["origin"], KRAFT)
	_fit_nodes["sticker"] = _sticker
	_kelly_digits = Marker.new()
	_kelly_root = _kelly_digits.build(self, "KellyStake",
			_layout.height_at(0.045, depth), INK_LIGHT)
	_kelly_root.position = sticker_slot["origin"] + Vector3(0, 0, 0.02)
	if not _kelly_digits.available():
		_kelly_fallback = _marker_label("KellyStakeFallback", Vector3.ZERO,
				_layout.height_at(0.045, depth), INK_LIGHT)
		_kelly_root.add_child(_kelly_fallback)
	_add_reading_light(_formula_l1.position, 0.45, 0.9)


func _place_marker(node_name: String, id: String, depth: float, text_v: float) -> Label3D:
	var slot: Dictionary = _layout.place(id, depth)
	var label := _marker_label(node_name, slot["origin"],
			_layout.height_at(text_v, depth), INK_LIGHT)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(label)
	_fit_nodes[id] = label
	return label


## Oil-marker text. No outline: an outline at this pixel size swallows the glyphs.
func _marker_label(node_name: String, pos: Vector3, line_height: float,
		ink: Color) -> Label3D:
	var label := Label3D.new()
	label.name = node_name
	label.position = pos
	label.font_size = 64
	label.pixel_size = line_height / 64.0
	label.modulate = ink
	label.outline_size = 0
	label.shaded = false
	label.double_sided = false
	label.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	label.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR
	return label


func _report_missing_art() -> void:
	var lines := Assets.audit()
	if lines.is_empty():
		return
	var layer := CanvasLayer.new()
	layer.name = "ArtPipelineWarning"
	layer.layer = 100
	add_child(layer)
	var label := Label.new()
	label.text = "GREYBOX — %s" % lines[0]
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color8(255, 168, 120))
	label.add_theme_color_override("font_outline_color", Color8(20, 16, 20))
	label.add_theme_constant_override("outline_size", 4)
	label.position = Vector2(10, 8)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(label)


func _build_hud() -> void:
	var layer := CanvasLayer.new()
	layer.name = "Hud"
	add_child(layer)
	_select_rect = ColorRect.new()
	_select_rect.color = Color(1, 1, 1, 0.12)
	_select_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_select_rect.visible = false
	layer.add_child(_select_rect)
	var border := ReferenceRect.new()
	border.border_color = OUTLINE
	border.editor_only = false
	border.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_select_rect.add_child(border)
	_count_label = Label.new()
	_count_label.visible = false
	# Fit list: count digits are 0.040 of frame height.
	_count_label.add_theme_font_size_override("font_size",
			int(0.040 * float(get_viewport().size.y) / 0.72))
	_count_label.add_theme_color_override("font_color", INK_DARK)
	_count_label.add_theme_color_override("font_outline_color", EMBER_L)
	_count_label.add_theme_constant_override("outline_size", 4)
	_count_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(_count_label)


func _unhandled_input(event: InputEvent) -> void:
	if _busy:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_pressing = true
			_dragging = false
			_drag_start = event.position
			_select_rect.visible = false
		else:
			_on_left_release(event.position)
			_pressing = false
			_dragging = false
			_select_rect.visible = false
	elif event is InputEventMouseMotion and _pressing:
		if not _dragging and event.position.distance_to(_drag_start) >= DRAG_PX:
			_dragging = true
			_select_rect.visible = true


func _on_left_release(pos: Vector2) -> void:
	if _round.phase != Round.Phase.PLAYING:
		return
	if _dragging:
		_box_select(Rect2(_drag_start, pos - _drag_start).abs())
		return
	if _selected_coins.size() > 0:
		if _over(_box, pos):
			_deposit()
		else:
			_drop_at_mouse(pos)
		return
	if _over(_lever, pos):
		_run_invest()
	elif _over(_sticker, pos):
		_round.toggle_sticker()
		_refresh_diegetic()


func _over(node: Node3D, pos: Vector2) -> bool:
	if node == null:
		return false
	return _layout.screen_rect(node).grow(6.0).has_point(pos)


func _box_select(rect: Rect2) -> void:
	if rect.size.x < 2.0 and rect.size.y < 2.0:
		return
	var picked: Array[Node3D] = []
	for coin in _floor_coins:
		if rect.has_point(_camera.unproject_position(coin.global_position)):
			picked.append(coin)
	if picked.is_empty():
		return
	var added: int = _round.add_selection(picked.size())
	for i in added:
		var coin: Node3D = picked[i]
		_floor_coins.erase(coin)
		_selected_coins.append(coin)


func _drop_at_mouse(pos: Vector2) -> void:
	var n: int = _round.drop_selected()
	if n <= 0:
		return
	var origin := _floor_point(pos)
	for i in _selected_coins.size():
		var coin: Node3D = _selected_coins[i]
		_fall_to(coin, origin + _ring(i, _selected_coins.size(), _coin_diameter * 1.6))
		_floor_coins.append(coin)
	_selected_coins.clear()


func _deposit() -> void:
	var n: int = _round.deposit_selected()
	if n <= 0:
		return
	var moving: Array[Node3D] = _selected_coins.duplicate()
	_selected_coins.clear()
	_busy = true
	for coin in moving:
		await _tween_to(coin, _box_slot, 0.22)
		coin.queue_free()
	_busy = false
	_refresh_diegetic()


func _run_invest() -> void:
	if _round.phase != Round.Phase.PLAYING:
		return
	_busy = true
	if _selected_coins.size() > 0:
		_drop_at_mouse(get_viewport().get_mouse_position())
	var stake: int = _round.boxed_count
	var total: int = _round.round_total
	await _pull_lever_anim()
	# Stake leaves the room and lands in the market: coins fall in from above.
	await _market.fall_in(stake, total)
	var result: Dictionary = _round.pull_lever(_rng.randf())
	_refresh_diegetic()
	if bool(result["success"]) and int(result["returned"]) > 0:
		await _eject_coins(int(result["returned"]), total)
	else:
		await get_tree().create_timer(0.7).timeout
	await get_tree().create_timer(0.6).timeout
	var nxt: Dictionary = _round.start_next_round(_rng)
	if bool(nxt["rescue_coin"]):
		await _eject_coins(1, _round.round_total)
	_refresh_diegetic()
	_busy = false


## Payout: the market level drops and coins come out through the hatch.
func _eject_coins(n: int, total: int) -> void:
	_set_outlet_open(true)
	_market.take_out(n, total)
	var mouth: Vector3 = _outlet.position + Vector3(0.0, 0.0, 0.16)
	for i in n:
		var coin := _make_coin()
		coin.position = mouth + Vector3(_rng.randf_range(-0.35, 0.35), 0.0, 0.0)
		_player_coins.add_child(coin)
		_floor_coins.append(coin)
		_fall_to(coin, _floor_point_random())
		await get_tree().create_timer(0.05).timeout
	await get_tree().create_timer(0.35).timeout
	_set_outlet_open(false)


func _set_outlet_open(open: bool) -> void:
	var sprite := _outlet.get_node_or_null("OutletSprite") as Sprite3D
	if sprite != null:
		var tex := Assets.tex(Assets.OUTLET_OPEN if open else Assets.OUTLET_CLOSED)
		if tex != null:
			sprite.texture = tex
			var slot: Dictionary = _layout.place("outlet", _layout.wall_depth() - 0.10)
			_layout.fit_sprite_to(sprite, slot["size"])
		return
	if _valve != null:
		_valve.visible = not open


func _pull_lever_anim() -> void:
	if _lever_sprite != null:
		var down := Assets.tex(Assets.LEVER_DOWN)
		if down != null:
			var up: Texture2D = _lever_sprite.texture
			var slot: Dictionary = _layout.place_on_floor("lever")
			_lever_sprite.texture = down
			_layout.fit_sprite_to(_lever_sprite, slot["size"])
			await get_tree().create_timer(0.45).timeout
			_lever_sprite.texture = up
			_layout.fit_sprite_to(_lever_sprite, slot["size"])
			return
	if _lever_arm != null:
		var tw := create_tween()
		tw.tween_property(_lever_arm, "rotation_degrees:x", 68.0, 0.22)
		tw.tween_property(_lever_arm, "rotation_degrees:x", 0.0, 0.18).set_delay(0.1)
		await tw.finished
		return
	await get_tree().create_timer(0.3).timeout


func _follow_selected(delta: float) -> void:
	if _selected_coins.is_empty():
		return
	var origin := _floor_point(get_viewport().get_mouse_position())
	var k := 1.0 - exp(-14.0 * delta)
	for i in _selected_coins.size():
		var coin: Node3D = _selected_coins[i]
		var target := origin + _ring(i, _selected_coins.size(), _coin_diameter * 1.2)
		coin.global_position = coin.global_position.lerp(target, k)


func _update_box_hover() -> void:
	if _box == null:
		return
	var hot: bool = (not _busy) and _round != null and _round.phase == Round.Phase.PLAYING \
			and _selected_coins.size() > 0 and _over(_box, get_viewport().get_mouse_position())
	_box.scale = Vector3(1.1, 1.1, 1.1) if hot else Vector3.ONE


func _update_count_label() -> void:
	if _round == null:
		return
	var show_count: bool = _round.show_selected_count() and not _selected_coins.is_empty()
	_count_label.visible = show_count
	if show_count:
		_count_label.text = str(_round.selected_count)
		_count_label.position = get_viewport().get_mouse_position() + Vector2(14, -30)


func _update_select_rect(pos: Vector2) -> void:
	var r := Rect2(_drag_start, pos - _drag_start).abs()
	_select_rect.position = r.position
	_select_rect.size = r.size


func _refresh_diegetic() -> void:
	if _box_digits != null and _box_digits.available():
		_box_digits.set_text(_round.box_label())
	elif _box_marker_fallback != null:
		_box_marker_fallback.text = _round.box_label()
	if _round.phase == Round.Phase.PLAYING:
		_board_label.text = "回报倍率 %.1f×\n成功概率 %d%%" % [
				_round.b, int(round(_round.p * 100.0))]
	elif _round.last_success:
		_board_label.text = "投资成功"
	else:
		_board_label.text = "投资失败"
	_formula_l1.text = "Kelly  f* = p - q/b"
	# Atlas has 0–9 and slash only — letters/decimals stay on Label3D; integer
	# odds percentages can still use the board Label3D copy above.
	_formula_l2.text = "p = %.2f   b = %.1f" % [_round.p, _round.b]
	var stake := str(_round.recommended_stake())
	if _kelly_digits != null and _kelly_digits.available():
		_kelly_digits.set_text(stake)
		_kelly_root.visible = _round.sticker_revealed
	elif _kelly_fallback != null:
		_kelly_fallback.text = stake
		_kelly_root.visible = _round.sticker_revealed
	_sticker.visible = not _round.sticker_revealed
	call_deferred("_scale_labels")


func _scale_labels() -> void:
	if _formula_l1 == null:
		return
	var f1: Dictionary = _layout.place("formula_l1", _layout.wall_depth() - 0.05)
	_fit_label(_formula_l1, f1["size"].x, f1["size"].y)
	var f2: Dictionary = _layout.place("formula_l2", _layout.wall_depth() - 0.05)
	_fit_label(_formula_l2, f2["size"].x, f2["size"].y)
	var board_slot: Dictionary = _layout.place("whiteboard", _layout.wall_depth() - 0.22)
	_fit_label(_board_label, board_slot["size"].x * 0.88, board_slot["size"].y * 0.7)


func _spawn_player_coins(n: int) -> void:
	for coin in _floor_coins:
		coin.queue_free()
	_floor_coins.clear()
	for coin in _selected_coins:
		coin.queue_free()
	_selected_coins.clear()
	for i in n:
		var coin := _make_coin()
		coin.position = _floor_point_random()
		_player_coins.add_child(coin)
		_floor_coins.append(coin)


func _make_coin() -> Node3D:
	var coin: Node3D = CoinActor.new()
	if _coin_diameter <= 0.0:
		# Fit list: floor coins are 0.022 of frame width where the player sees them.
		_coin_diameter = _layout.size_at(Vector2(0.022, 0.022),
				_layout.depth_on_floor("coin_box")).x
	coin.configure(_coin_tex, _coin_diameter)
	return coin


func _floor_point_random() -> Vector3:
	var depth: float = _layout.depth_on_floor("coin_box")
	var uv := Vector2(_rng.randf_range(0.34, 0.60), _rng.randf_range(0.84, 0.95))
	var p := _layout.world_at(uv, depth)
	p.y = FLOOR_Y
	return p


func _floor_point(screen: Vector2) -> Vector3:
	var origin := _camera.project_ray_origin(screen)
	var dir := _camera.project_ray_normal(screen)
	if absf(dir.y) < 0.0001:
		return Vector3(0, FLOOR_Y, Layout.WALL_Z * 0.5)
	var t := (FLOOR_Y - origin.y) / dir.y
	var p := origin + dir * t
	p.y = FLOOR_Y
	p.x = clampf(p.x, -Layout.ROOM_HALF_W + 0.2, Layout.ROOM_HALF_W - 0.2)
	p.z = clampf(p.z, Layout.WALL_Z + 0.25, 0.9)
	return p


func _ring(i: int, n: int, radius: float) -> Vector3:
	if n <= 1:
		return Vector3.ZERO
	var a := TAU * float(i) / float(n)
	return Vector3(cos(a) * radius, 0.0, sin(a) * radius)


func _tween_to(node: Node3D, dest: Vector3, dur: float) -> void:
	var tw := create_tween()
	tw.tween_property(node, "global_position", dest, dur)
	await tw.finished


func _fall_to(node: Node3D, dest: Vector3) -> void:
	var start := node.global_position
	var peak := (start + dest) * 0.5
	peak.y = maxf(start.y, dest.y) + 0.3
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_QUAD)
	tw.tween_property(node, "global_position", peak, 0.13).set_ease(Tween.EASE_OUT)
	tw.tween_property(node, "global_position", dest, 0.21).set_ease(Tween.EASE_IN)


func _mesh_box(host: Node3D, node_name: String, size: Vector3, pos: Vector3,
		color: Color) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.name = node_name
	var box := BoxMesh.new()
	box.size = size
	mi.mesh = box
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.75
	mi.material_override = mat
	mi.position = pos
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	host.add_child(mi)
	return mi
