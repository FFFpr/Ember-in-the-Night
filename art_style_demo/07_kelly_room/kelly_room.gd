extends Node3D
## Locked-camera Kelly gambling room. Logic lives in kelly_round.gd.

const Round := preload("res://art_style_demo/07_kelly_room/kelly_round.gd")
const CoinActor := preload("res://art_style_demo/07_kelly_room/coin_actor.gd")
const Assets := preload("res://art_style_demo/07_kelly_room/kelly_assets.gd")

const WOOD_D := Color8(62, 38, 28)
const WOOD_M := Color8(118, 72, 42)
const WOOD_L := Color8(176, 118, 62)
const METAL_D := Color8(48, 46, 58)
const METAL_M := Color8(92, 90, 102)
const METAL_L := Color8(168, 158, 148)
const METAL_HI := Color8(232, 214, 176)
const OUTLINE := Color8(28, 22, 26)
const NIGHT := Color8(22, 32, 52)
const GLASS := Color(0.55, 0.78, 0.72, 0.18)

const DRAG_PX := 6.0
const FLOOR_Y := 0.02

var _round: RefCounted
var _rng := RandomNumberGenerator.new()
var _busy := false
var _pressing := false
var _dragging := false
var _drag_start := Vector2.ZERO

var _camera: Camera3D
var _box: Node3D
var _box_outline: MeshInstance3D
var _lever_arm: Node3D
var _valve: Node3D
var _sticker: Node3D
var _lever_sprite: Sprite3D
var _outlet_root: Node3D
var _board_label: Label3D
var _formula_label: Label3D
var _kelly_label: Label3D
var _box_label: Label3D
var _count_label: Label
var _select_rect: ColorRect
var _floor_coins: Array[Node3D] = []
var _selected_coins: Array[Node3D] = []
var _market: Node3D
var _player_coins: Node3D
var _coin_tex: Texture2D


func _ready() -> void:
	_rng.randomize()
	_coin_tex = Assets.tex(Assets.COIN)
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
		if _over_box(pos):
			_deposit()
		else:
			_drop_at_mouse(pos)
		return
	if _over_lever(pos):
		_run_invest()
	elif _over_sticker(pos):
		_round.toggle_sticker()
		_refresh_diegetic()


func _box_select(rect: Rect2) -> void:
	if rect.size.x < 2.0 and rect.size.y < 2.0:
		return
	var picked: Array[Node3D] = []
	for coin in _floor_coins:
		var sp: Vector2 = _camera.unproject_position(coin.global_position)
		if rect.has_point(sp):
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
		var ring := _ring(i, _selected_coins.size(), 0.12)
		coin.position = origin + ring
		_floor_coins.append(coin)
	_selected_coins.clear()


func _deposit() -> void:
	var n: int = _round.deposit_selected()
	if n <= 0:
		return
	var slot: Vector3 = _box.global_position + Vector3(0, 0.42, 0)
	var moving: Array[Node3D] = _selected_coins.duplicate()
	_selected_coins.clear()
	_busy = true
	for coin in moving:
		await _tween_to(coin, slot, 0.22)
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
	await _pull_lever_anim()
	_drop_market_coins(stake)
	var result: Dictionary = _round.pull_lever(_rng.randf())
	_refresh_diegetic()
	if bool(result["success"]) and int(result["returned"]) > 0:
		await _eject_coins(int(result["returned"]))
	else:
		await get_tree().create_timer(0.7).timeout
	await get_tree().create_timer(0.85).timeout
	var nxt: Dictionary = _round.start_next_round(_rng)
	if bool(nxt["rescue_coin"]):
		await _eject_coins(1)
	_refresh_diegetic()
	_busy = false


func _follow_selected(delta: float) -> void:
	if _selected_coins.is_empty():
		return
	var origin := _floor_point(get_viewport().get_mouse_position())
	var k := 1.0 - exp(-14.0 * delta)
	for i in _selected_coins.size():
		var coin: Node3D = _selected_coins[i]
		var target := origin + _ring(i, _selected_coins.size(), 0.09)
		coin.global_position = coin.global_position.lerp(target, k)


func _update_box_hover() -> void:
	var hot: bool = (not _busy) and _round.phase == Round.Phase.PLAYING \
			and _selected_coins.size() > 0 and _over_box(get_viewport().get_mouse_position())
	_box.scale = Vector3(1.12, 1.12, 1.12) if hot else Vector3.ONE
	_box_outline.visible = hot


func _update_count_label() -> void:
	var show_count: bool = _round.show_selected_count() and not _selected_coins.is_empty()
	_count_label.visible = show_count
	if show_count:
		_count_label.text = str(_round.selected_count)
		_count_label.position = get_viewport().get_mouse_position() + Vector2(14, -28)


func _update_select_rect(pos: Vector2) -> void:
	var r := Rect2(_drag_start, pos - _drag_start).abs()
	_select_rect.position = r.position
	_select_rect.size = r.size


func _refresh_diegetic() -> void:
	_box_label.text = _round.box_label()
	if _round.phase == Round.Phase.PLAYING:
		_board_label.text = "回报倍率 %.1f×\n成功概率 %d%%" % [_round.b, int(round(_round.p * 100.0))]
	elif _round.last_success:
		_board_label.text = "投资成功"
	else:
		_board_label.text = "投资失败"
	_formula_label.text = "Kelly  f* = p − q/b\np=%.2f  b=%.1f" % [_round.p, _round.b]
	_kelly_label.text = str(_round.recommended_stake())
	_kelly_label.visible = _round.sticker_revealed
	_sticker.visible = not _round.sticker_revealed


func _spawn_player_coins(n: int) -> void:
	for coin in _floor_coins:
		coin.queue_free()
	_floor_coins.clear()
	for coin in _selected_coins:
		coin.queue_free()
	_selected_coins.clear()
	for i in n:
		var coin := _make_coin(true)
		coin.position = Vector3(
				-0.55 + fmod(float(i) * 0.37, 1.4),
				FLOOR_Y,
				0.15 + float(i % 4) * 0.18)
		_player_coins.add_child(coin)
		_floor_coins.append(coin)


func _make_coin(player: bool) -> Node3D:
	var coin: Node3D = CoinActor.new()
	coin.configure(player, _coin_tex if player else null)
	return coin


func _eject_coins(n: int) -> void:
	_set_outlet_open(true)
	for i in n:
		var coin := _make_coin(true)
		coin.position = Vector3(-0.25 + (float(i % 5) - 2.0) * 0.07, 0.18, -1.22)
		_player_coins.add_child(coin)
		_floor_coins.append(coin)
		var dest := Vector3(
				-0.4 + randf() * 1.0,
				FLOOR_Y,
				-0.15 + randf() * 0.7)
		_tween_to(coin, dest, 0.35 + randf() * 0.15)
		await get_tree().create_timer(0.05).timeout
	await get_tree().create_timer(0.4).timeout
	_set_outlet_open(false)


func _set_outlet_open(open: bool) -> void:
	_valve.rotation_degrees.x = -62.0 if open else 0.0
	var open_tex := Assets.tex(Assets.OUTLET_OPEN)
	var closed_tex := Assets.tex(Assets.OUTLET_CLOSED)
	if _outlet_root != null and _outlet_root is Sprite3D:
		var sprite := _outlet_root as Sprite3D
		if open and open_tex != null:
			sprite.texture = open_tex
		elif closed_tex != null:
			sprite.texture = closed_tex


func _drop_market_coins(n: int) -> void:
	for i in n:
		var coin := _make_coin(false)
		coin.position = Vector3(-0.9 + randf() * 1.6, 2.15, -1.85 - randf() * 0.5)
		_market.add_child(coin)
		var dest := Vector3(coin.position.x, 0.35 + randf() * 0.9, coin.position.z)
		_tween_to(coin, dest, 0.45 + randf() * 0.2)


func _pull_lever_anim() -> void:
	var down := Assets.tex(Assets.LEVER_DOWN)
	var up := Assets.tex(Assets.LEVER)
	if _lever_sprite != null and down != null:
		_lever_sprite.texture = down
		await get_tree().create_timer(0.28).timeout
		if up != null:
			_lever_sprite.texture = up
		return
	var tw := create_tween()
	tw.tween_property(_lever_arm, "rotation_degrees:x", 70.0, 0.22)
	tw.tween_property(_lever_arm, "rotation_degrees:x", 0.0, 0.18).set_delay(0.12)
	await tw.finished


func _tween_to(node: Node3D, dest: Vector3, dur: float) -> void:
	var tw := create_tween()
	tw.tween_property(node, "global_position", dest, dur)
	await tw.finished


func _ring(i: int, n: int, radius: float) -> Vector3:
	if n <= 1:
		return Vector3.ZERO
	var a := TAU * float(i) / float(n)
	return Vector3(cos(a) * radius, 0.0, sin(a) * radius)


func _floor_point(screen: Vector2) -> Vector3:
	var origin := _camera.project_ray_origin(screen)
	var dir := _camera.project_ray_normal(screen)
	if absf(dir.y) < 0.0001:
		return Vector3(0, FLOOR_Y, 0.4)
	var t := (FLOOR_Y - origin.y) / dir.y
	var p := origin + dir * t
	p.y = FLOOR_Y
	p.x = clampf(p.x, -1.5, 1.15)
	p.z = clampf(p.z, -0.85, 1.35)
	return p


func _over_box(pos: Vector2) -> bool:
	return _in_screen_box(_box.global_position + Vector3(0, 0.22, 0), pos, Vector2(70, 80))


func _over_lever(pos: Vector2) -> bool:
	return _in_screen_box(_lever_arm.global_position + Vector3(0, 0.25, 0), pos, Vector2(48, 70))


func _over_sticker(pos: Vector2) -> bool:
	return _in_screen_box(_sticker.global_position, pos, Vector2(46, 36))


func _in_screen_box(world: Vector3, pos: Vector2, pad: Vector2) -> bool:
	var sp: Vector2 = _camera.unproject_position(world)
	return Rect2(sp - pad, pad * 2.0).has_point(pos)


func _build_hud() -> void:
	var layer := CanvasLayer.new()
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
	_count_label.add_theme_font_size_override("font_size", 28)
	_count_label.add_theme_color_override("font_color", Color8(28, 22, 26))
	_count_label.add_theme_color_override("font_outline_color", Color8(232, 214, 176))
	_count_label.add_theme_constant_override("outline_size", 4)
	_count_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(_count_label)


func _build_world() -> void:
	_make_env()
	_make_room()
	_camera = Camera3D.new()
	_camera.position = Vector3(0.12, 1.38, 2.55)
	_camera.current = true
	_camera.fov = 52.0
	add_child(_camera)
	_camera.look_at(Vector3(-0.05, 0.82, -1.1))
	_market = Node3D.new()
	_market.name = "Market"
	add_child(_market)
	_player_coins = Node3D.new()
	_player_coins.name = "PlayerCoins"
	add_child(_player_coins)
	_fill_market()
	_make_glass()
	_make_outlet()
	_make_box()
	_make_lever()
	_make_board()
	_make_formula()


func _make_env() -> void:
	var world := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = NIGHT
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color8(74, 72, 78)
	env.ambient_light_energy = 0.4
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	world.environment = env
	add_child(world)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-42, 35, 0)
	sun.light_color = Color8(168, 158, 148)
	sun.light_energy = 0.35
	sun.shadow_enabled = true
	add_child(sun)
	var lamp := OmniLight3D.new()
	lamp.position = Vector3(-1.85, 1.55, 0.55)
	lamp.light_color = Color8(255, 186, 72)
	lamp.light_energy = 2.4
	lamp.omni_range = 6.0
	lamp.shadow_enabled = true
	add_child(lamp)
	var lamp_mesh := _box_mesh(Vector3(0.08, 0.18, 0.08), Color8(220, 96, 28), lamp.position)
	add_child(lamp_mesh)


func _make_room() -> void:
	add_child(_box_mesh(Vector3(5.2, 0.12, 5.4), WOOD_D, Vector3(0, -0.06, 0.1)))
	add_child(_box_mesh(Vector3(5.2, 2.6, 0.16), WOOD_M, Vector3(0, 1.3, -2.95)))
	add_child(_box_mesh(Vector3(0.16, 2.6, 5.4), WOOD_M, Vector3(-2.5, 1.3, 0.1)))
	add_child(_box_mesh(Vector3(0.16, 2.6, 5.4), WOOD_M, Vector3(2.15, 1.3, 0.1)))
	add_child(_box_mesh(Vector3(5.2, 0.12, 5.4), WOOD_D, Vector3(0, 2.55, 0.1)))
	add_child(_box_mesh(Vector3(0.18, 0.18, 5.4), WOOD_L, Vector3(-1.2, 2.35, 0.1)))
	add_child(_box_mesh(Vector3(0.18, 0.18, 5.4), WOOD_L, Vector3(0.9, 2.35, 0.1)))


func _make_glass() -> void:
	var frame := _box_mesh(Vector3(3.15, 2.15, 0.08), WOOD_D, Vector3(-0.28, 1.08, -1.42))
	add_child(frame)
	var pane := MeshInstance3D.new()
	var quad := BoxMesh.new()
	quad.size = Vector3(2.95, 1.95, 0.03)
	pane.mesh = quad
	var mat := StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = GLASS
	mat.roughness = 0.06
	mat.metallic = 0.15
	pane.material_override = mat
	pane.position = Vector3(-0.28, 1.1, -1.38)
	add_child(pane)


func _fill_market() -> void:
	for i in 90:
		var coin := _make_coin(false)
		var col := i % 10
		var row := (i / 10) % 3
		var layer := i / 30
		coin.position = Vector3(
				-1.35 + float(col) * 0.22 + randf() * 0.04,
				0.08 + float(layer) * 0.22 + float(row) * 0.05,
				-1.7 - float(row) * 0.28 - randf() * 0.08)
		_market.add_child(coin)


func _make_outlet() -> void:
	var housing := _box_mesh(Vector3(1.15, 0.22, 0.28), METAL_D, Vector3(-0.25, 0.16, -1.22))
	add_child(housing)
	_valve = _box_mesh(Vector3(1.05, 0.04, 0.22), METAL_M, Vector3(0, 0.08, 0.02))
	housing.add_child(_valve)
	var outlet_tex := Assets.tex(Assets.OUTLET_CLOSED)
	if outlet_tex != null:
		housing.visible = false
		_valve.visible = false
		_outlet_root = _billboard(outlet_tex, Vector3(-0.25, 0.16, -1.22), 0.012)
		add_child(_outlet_root)


func _make_box() -> void:
	_box = Node3D.new()
	_box.position = Vector3(1.42, 0.0, 0.22)
	add_child(_box)
	var body := _box_mesh(Vector3(0.48, 0.52, 0.42), WOOD_M, Vector3(0, 0.26, 0))
	_box.add_child(body)
	var slot := _box_mesh(Vector3(0.28, 0.04, 0.06), METAL_D, Vector3(0, 0.54, 0.02))
	_box.add_child(slot)
	_box_outline = _box_mesh(Vector3(0.54, 0.58, 0.48), OUTLINE, Vector3(0, 0.26, 0))
	_box_outline.visible = false
	_box.add_child(_box_outline)
	var box_tex := Assets.tex(Assets.COIN_BOX)
	if box_tex != null:
		body.visible = false
		_box.add_child(_billboard(box_tex, Vector3(0, 0.28, 0), 0.012))
	_box_label = _marker_label(Vector3(0, 0.28, 0.22), 48)
	_box.add_child(_box_label)


func _make_lever() -> void:
	var base := _box_mesh(Vector3(0.18, 0.12, 0.18), METAL_D, Vector3(1.82, 0.06, 0.22))
	add_child(base)
	_lever_arm = Node3D.new()
	_lever_arm.position = Vector3(1.82, 0.12, 0.22)
	add_child(_lever_arm)
	var shaft := _box_mesh(Vector3(0.05, 0.42, 0.05), METAL_M, Vector3(0, 0.22, 0))
	_lever_arm.add_child(shaft)
	var knob := MeshInstance3D.new()
	var sphere := SphereMesh.new()
	sphere.radius = 0.07
	sphere.height = 0.14
	knob.mesh = sphere
	var kmat := StandardMaterial3D.new()
	kmat.albedo_color = METAL_L
	kmat.metallic = 0.8
	knob.material_override = kmat
	knob.position = Vector3(0, 0.44, 0)
	_lever_arm.add_child(knob)
	var lever_tex := Assets.tex(Assets.LEVER)
	if lever_tex != null:
		shaft.visible = false
		knob.visible = false
		_lever_sprite = _billboard(lever_tex, Vector3(0, 0.28, 0), 0.014)
		_lever_arm.add_child(_lever_sprite)


func _make_board() -> void:
	var board := _box_mesh(Vector3(0.72, 0.38, 0.03), Color8(245, 244, 236), Vector3(-0.2, 1.92, -1.34))
	add_child(board)
	var board_tex := Assets.tex(Assets.WHITEBOARD)
	if board_tex != null:
		board.visible = false
		add_child(_billboard(board_tex, Vector3(-0.2, 1.92, -1.33), 0.012))
	_board_label = _marker_label(Vector3(-0.2, 1.92, -1.31), 42)
	add_child(_board_label)


func _make_formula() -> void:
	_formula_label = _marker_label(Vector3(-1.35, 1.45, -1.33), 28)
	_formula_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	add_child(_formula_label)
	_kelly_label = _marker_label(Vector3(-1.18, 1.18, -1.33), 52)
	add_child(_kelly_label)
	_sticker = _box_mesh(Vector3(0.28, 0.16, 0.02), Color8(232, 214, 176), Vector3(-1.18, 1.18, -1.32))
	add_child(_sticker)
	var sticker_tex := Assets.tex(Assets.STICKER)
	if sticker_tex != null:
		_sticker.visible = false
		var sprite := _billboard(sticker_tex, Vector3(-1.18, 1.18, -1.32), 0.01)
		sprite.name = "StickerSprite"
		add_child(sprite)
		_sticker = sprite


func _marker_label(pos: Vector3, size: int) -> Label3D:
	var lab := Label3D.new()
	lab.position = pos
	lab.font_size = size
	lab.modulate = OUTLINE
	lab.outline_modulate = Color8(232, 214, 176)
	lab.outline_size = 6
	lab.pixel_size = 0.0022
	lab.shaded = false
	lab.no_depth_test = false
	lab.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	return lab


func _billboard(tex: Texture2D, pos: Vector3, pixel_size: float) -> Sprite3D:
	var s := Sprite3D.new()
	s.texture = tex
	s.position = pos
	s.pixel_size = pixel_size
	s.shaded = true
	s.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	s.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	s.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	return s


func _box_mesh(size: Vector3, color: Color, pos: Vector3) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mi.mesh = box
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.7
	mi.material_override = mat
	mi.position = pos
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	return mi
