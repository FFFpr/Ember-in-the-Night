extends Node3D
## HD-2D street look-dev: locked shopfront camera, 0–10s day / 10–20s night.
## Blocking follows Demo A `street_day_ref.png` / `street_night_ref.png`.

const SPR := "res://art_style_demo/07_hd2d/sprites/"
const DAY_LEN := 10.0
const NIGHT_LEN := 10.0
const CYCLE := DAY_LEN + NIGHT_LEN
const FADE := 0.45

var _sun: DirectionalLight3D
var _forge: OmniLight3D
var _lamp: OmniLight3D
var _sky: WorldEnvironment
var _env: Environment
var _time: float = 0.0


func _ready() -> void:
	_build_environment()
	_build_street()
	_build_sprites()
	_build_camera()


func _process(delta: float) -> void:
	_time = fmod(_time + delta, CYCLE)
	var night := 0.0
	if _time >= DAY_LEN:
		var into_night: float = _time - DAY_LEN
		if into_night < FADE:
			night = into_night / FADE
		elif into_night > NIGHT_LEN - FADE:
			night = 1.0 - (into_night - (NIGHT_LEN - FADE)) / FADE
		else:
			night = 1.0
	_apply_night(night)


func _apply_night(night: float) -> void:
	if _sun:
		_sun.light_energy = lerpf(0.85, 0.05, night)
		_sun.light_color = Color(0.95, 0.92, 0.85).lerp(Color(0.35, 0.45, 0.7), night)
	if _forge:
		_forge.light_energy = lerpf(0.6, 3.4, night)
	if _lamp:
		_lamp.light_energy = lerpf(0.0, 1.1, night)
	if _env:
		_env.background_color = Color(0.55, 0.66, 0.78).lerp(Color(0.05, 0.07, 0.12), night)
		_env.ambient_light_energy = lerpf(0.45, 0.18, night)
		_env.fog_light_color = Color(0.62, 0.7, 0.8).lerp(Color(0.06, 0.08, 0.12), night)


func _mat(albedo: Color, emission: Color = Color.BLACK, emission_energy: float = 0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = albedo
	m.roughness = 0.9
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	if emission_energy > 0.0:
		m.emission_enabled = true
		m.emission = emission
		m.emission_energy_multiplier = emission_energy
	return m


func _box(n: String, size: Vector3, pos: Vector3, mat: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.name = n
	var mesh := BoxMesh.new()
	mesh.size = size
	mi.mesh = mesh
	mi.position = pos
	mi.material_override = mat
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	add_child(mi)
	return mi


func _build_environment() -> void:
	_env = Environment.new()
	_env.background_mode = Environment.BG_COLOR
	_env.background_color = Color(0.55, 0.66, 0.78)
	_env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	_env.ambient_light_color = Color(0.55, 0.6, 0.7)
	_env.ambient_light_energy = 0.45
	_env.fog_enabled = true
	_env.fog_density = 0.025
	_env.glow_enabled = true
	_env.glow_intensity = 0.28
	_sky = WorldEnvironment.new()
	_sky.name = "WorldEnvironment"
	_sky.environment = _env
	add_child(_sky)

	_sun = DirectionalLight3D.new()
	_sun.name = "Sun"
	_sun.light_color = Color(0.95, 0.92, 0.85)
	_sun.light_energy = 0.85
	_sun.shadow_enabled = true
	_sun.rotation_degrees = Vector3(-42.0, 50.0, 0.0)
	add_child(_sun)

	_forge = OmniLight3D.new()
	_forge.name = "ForgeSpill"
	_forge.light_color = Color(1.0, 0.5, 0.18)
	_forge.light_energy = 0.6
	_forge.omni_range = 4.5
	_forge.shadow_enabled = true
	_forge.position = Vector3(-0.35, 0.85, -1.35)
	add_child(_forge)

	_lamp = OmniLight3D.new()
	_lamp.name = "DoorLamp"
	_lamp.light_color = Color(1.0, 0.72, 0.35)
	_lamp.light_energy = 0.0
	_lamp.omni_range = 3.5
	_lamp.position = Vector3(-1.15, 1.55, -0.85)
	add_child(_lamp)


func _build_street() -> void:
	var cobble := _mat(Color(0.32, 0.31, 0.30))
	var plaster := _mat(Color(0.62, 0.58, 0.50))
	var timber := _mat(Color(0.22, 0.14, 0.10))
	var stone := _mat(Color(0.38, 0.38, 0.40))
	var slate := _mat(Color(0.28, 0.36, 0.48))
	var ember := _mat(Color(0.9, 0.32, 0.08), Color(1.0, 0.45, 0.12), 2.4)

	_box("Road", Vector3(8.0, 0.08, 5.0), Vector3(0.8, -0.04, 0.4), cobble)
	_box("ShopStone", Vector3(3.4, 1.4, 1.6), Vector3(-0.9, 0.7, -1.7), stone)
	_box("ShopPlaster", Vector3(3.4, 1.3, 1.5), Vector3(-0.9, 2.05, -1.75), plaster)
	_box("TimberV1", Vector3(0.12, 2.6, 0.12), Vector3(-2.4, 1.4, -0.92), timber)
	_box("TimberV2", Vector3(0.12, 2.6, 0.12), Vector3(-0.9, 1.4, -0.92), timber)
	_box("TimberV3", Vector3(0.12, 2.6, 0.12), Vector3(0.6, 1.4, -0.92), timber)
	_box("TimberH", Vector3(3.4, 0.12, 0.12), Vector3(-0.9, 1.4, -0.92), timber)
	_box("Roof", Vector3(3.8, 0.18, 2.0), Vector3(-0.9, 2.78, -1.7), slate)
	_box("Door", Vector3(0.7, 1.15, 0.08), Vector3(-1.55, 0.62, -0.88), timber)
	_box("ForgeNook", Vector3(1.1, 0.9, 0.7), Vector3(-0.15, 0.5, -1.15), stone)
	_box("ForgeGlow", Vector3(0.45, 0.4, 0.12), Vector3(-0.15, 0.55, -0.78), ember)
	_box("Neighbor", Vector3(2.6, 2.8, 1.6), Vector3(2.6, 1.4, -2.4), plaster)
	_box("NeighborRoof", Vector3(2.9, 0.16, 1.9), Vector3(2.6, 2.9, -2.4), slate)


func _build_sprites() -> void:
	var sign := Sprite3D.new()
	sign.name = "HammerSign"
	sign.texture = load(SPR + "hammer.png") as Texture2D
	sign.position = Vector3(-0.55, 1.85, -0.82)
	sign.pixel_size = 0.012
	sign.shaded = true
	sign.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	sign.alpha_scissor_threshold = 0.5
	sign.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	sign.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	add_child(sign)

	var anvil := Sprite3D.new()
	anvil.name = "StreetAnvil"
	anvil.texture = load(SPR + "anvil.png") as Texture2D
	anvil.position = Vector3(0.15, 0.38, -0.55)
	anvil.pixel_size = 0.014
	anvil.shaded = true
	anvil.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	anvil.alpha_scissor_threshold = 0.5
	anvil.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	anvil.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	add_child(anvil)


func _build_camera() -> void:
	var cam := Camera3D.new()
	cam.name = "Camera3D"
	cam.position = Vector3(0.35, 1.35, 2.6)
	cam.current = true
	cam.fov = 50.0
	add_child(cam)
	cam.look_at(Vector3(-0.6, 1.15, -1.4))
