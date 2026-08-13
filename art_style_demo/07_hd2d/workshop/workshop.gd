extends Node3D
## HD-2D workshop look-dev: 3D room + locked FP camera + nearest Sprite3D props.
## Composition follows Demo A `workshop_fp_ref.png`. Pixel sprites from the
## cluster-first experiment (`sprites/`), not from quantized paintings.

const SPR := "res://art_style_demo/07_hd2d/sprites/"

var _forge_light: OmniLight3D
var _t: float = 0.0


func _ready() -> void:
	_build_environment()
	_build_room()
	_build_sprites()
	_build_camera()


func _process(delta: float) -> void:
	_t += delta
	if _forge_light:
		_forge_light.light_energy = 3.6 + 0.55 * sin(_t * 7.0) + 0.25 * sin(_t * 13.0)


func _mat(albedo: Color, emission: Color = Color.BLACK, emission_energy: float = 0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = albedo
	m.roughness = 0.92
	m.metallic = 0.0
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


func _sprite(n: String, file: String, pos: Vector3, pixel_size: float, y_billboard: bool = false) -> Sprite3D:
	var s := Sprite3D.new()
	s.name = n
	s.texture = load(SPR + file) as Texture2D
	s.position = pos
	s.pixel_size = pixel_size
	s.shaded = true
	s.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	s.alpha_scissor_threshold = 0.5
	s.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	s.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	s.centered = true
	if y_billboard:
		s.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	add_child(s)
	return s


func _build_environment() -> void:
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.035, 0.04, 0.07)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.12, 0.14, 0.22)
	env.ambient_light_energy = 0.35
	env.fog_enabled = true
	env.fog_light_color = Color(0.07, 0.08, 0.12)
	env.fog_density = 0.04
	env.glow_enabled = true
	env.glow_intensity = 0.35
	env.glow_bloom = 0.08
	var we := WorldEnvironment.new()
	we.name = "WorldEnvironment"
	we.environment = env
	add_child(we)

	var moon := DirectionalLight3D.new()
	moon.name = "Moon"
	moon.light_color = Color(0.42, 0.52, 0.72)
	moon.light_energy = 0.22
	moon.shadow_enabled = true
	moon.rotation_degrees = Vector3(-48.0, 38.0, 0.0)
	add_child(moon)

	_forge_light = OmniLight3D.new()
	_forge_light.name = "ForgeLight"
	_forge_light.light_color = Color(1.0, 0.48, 0.16)
	_forge_light.light_energy = 3.8
	_forge_light.omni_range = 6.5
	_forge_light.shadow_enabled = true
	_forge_light.position = Vector3(0.0, 1.15, -2.45)
	add_child(_forge_light)

	var window_light := OmniLight3D.new()
	window_light.name = "WindowLight"
	window_light.light_color = Color(0.32, 0.52, 0.88)
	window_light.light_energy = 0.55
	window_light.omni_range = 3.5
	window_light.position = Vector3(-1.75, 1.45, -1.6)
	add_child(window_light)


func _build_room() -> void:
	var stone := _mat(Color(0.29, 0.28, 0.31))
	var stone_d := _mat(Color(0.16, 0.17, 0.20))
	var wood := _mat(Color(0.24, 0.15, 0.11))
	var wood_l := _mat(Color(0.46, 0.28, 0.16))
	var ember := _mat(Color(0.86, 0.28, 0.08), Color(1.0, 0.45, 0.12), 3.2)

	_box("Floor", Vector3(4.4, 0.12, 4.0), Vector3(0.0, -0.06, -0.6), stone)
	_box("BackWall", Vector3(4.4, 2.5, 0.16), Vector3(0.0, 1.25, -2.72), stone_d)
	_box("LeftWall", Vector3(0.16, 2.5, 4.0), Vector3(-2.2, 1.25, -0.7), stone_d)
	_box("RightWall", Vector3(0.16, 2.5, 4.0), Vector3(2.2, 1.25, -0.7), stone_d)
	_box("Ceiling", Vector3(4.4, 0.12, 4.0), Vector3(0.0, 2.48, -0.6), wood)
	_box("BeamL", Vector3(0.14, 2.2, 0.14), Vector3(-1.1, 1.3, -2.55), wood)
	_box("BeamR", Vector3(0.14, 2.2, 0.14), Vector3(1.1, 1.3, -2.55), wood)
	_box("Bench", Vector3(4.2, 0.18, 0.7), Vector3(0.0, 0.72, 1.35), wood_l)

	_box("ForgeBody", Vector3(1.6, 1.35, 0.7), Vector3(0.0, 0.72, -2.42), stone)
	_box("ForgeMouth", Vector3(0.7, 0.55, 0.2), Vector3(0.0, 0.85, -2.08), ember)

	var window := _box("Window", Vector3(0.02, 0.55, 0.45), Vector3(-2.11, 1.45, -1.55), _mat(Color(0.18, 0.31, 0.46), Color(0.25, 0.45, 0.8), 0.8))
	window.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _build_sprites() -> void:
	_sprite("Anvil", "anvil.png", Vector3(0.02, 0.62, -0.85), 0.018)
	_sprite("ForgeSprite", "forge.png", Vector3(0.0, 1.05, -2.18), 0.016)
	_sprite("Hammer", "hammer.png", Vector3(0.42, 0.88, 1.05), 0.014)
	# Barrel / bellows as extra depth cues (same sprites, different scale).
	_sprite("Barrel", "anvil.png", Vector3(-1.35, 0.42, -1.15), 0.012)
	_sprite("Bellows", "forge.png", Vector3(1.35, 0.7, -1.55), 0.011)


func _build_camera() -> void:
	var cam := Camera3D.new()
	cam.name = "Camera3D"
	cam.position = Vector3(0.0, 1.28, 1.62)
	cam.current = true
	cam.fov = 52.0
	var attr := CameraAttributesPractical.new()
	attr.dof_blur_far_enabled = true
	attr.dof_blur_far_distance = 5.5
	attr.dof_blur_far_transition = 3.5
	attr.dof_blur_amount = 0.07
	cam.attributes = attr
	add_child(cam)
	cam.look_at(Vector3(0.0, 0.9, -2.2))
