class_name DemoLights
extends RefCounted
## Builds PointLight2D textures and spark particles for approach 02.


static func radial_light_texture(size: int = 256) -> GradientTexture2D:
	var grad := Gradient.new()
	grad.offsets = PackedFloat32Array([0.0, 0.45, 1.0])
	grad.colors = PackedColorArray([
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0.45),
		Color(1, 1, 1, 0),
	])
	var tex := GradientTexture2D.new()
	tex.gradient = grad
	tex.width = size
	tex.height = size
	tex.fill = GradientTexture2D.FILL_RADIAL
	tex.fill_from = Vector2(0.5, 0.5)
	tex.fill_to = Vector2(0.5, 0.0)
	return tex


static func make_point_light(name: String, pos: Vector2, color: Color, energy: float, texture_scale: float) -> PointLight2D:
	var light := PointLight2D.new()
	light.name = name
	light.position = pos
	light.color = color
	light.energy = energy
	light.texture = radial_light_texture()
	light.texture_scale = texture_scale
	light.range_item_cull_mask = 1
	return light


static func make_sparks(name: String, pos: Vector2) -> GPUParticles2D:
	var particles := GPUParticles2D.new()
	particles.name = name
	particles.position = pos
	particles.amount = 28
	particles.lifetime = 0.9
	particles.preprocess = 0.4
	particles.explosiveness = 0.05
	particles.randomness = 0.6
	particles.visibility_rect = Rect2(-80, -120, 160, 160)

	var mat := ParticleProcessMaterial.new()
	mat.direction = Vector3(0, -1, 0)
	mat.spread = 35.0
	mat.initial_velocity_min = 40.0
	mat.initial_velocity_max = 110.0
	mat.gravity = Vector3(0, 80, 0)
	mat.scale_min = 1.5
	mat.scale_max = 3.0
	mat.color = ArtPalette.WARM_EMBER_CORE
	particles.process_material = mat
	return particles


static func make_smoke(name: String, pos: Vector2) -> GPUParticles2D:
	var particles := GPUParticles2D.new()
	particles.name = name
	particles.position = pos
	particles.amount = 12
	particles.lifetime = 2.2
	particles.preprocess = 1.0
	particles.visibility_rect = Rect2(-100, -180, 200, 220)

	var mat := ParticleProcessMaterial.new()
	mat.direction = Vector3(0.15, -1, 0)
	mat.spread = 18.0
	mat.initial_velocity_min = 12.0
	mat.initial_velocity_max = 28.0
	mat.gravity = Vector3(0, -8, 0)
	mat.scale_min = 4.0
	mat.scale_max = 10.0
	mat.color = Color(0.25, 0.25, 0.28, 0.35)
	particles.process_material = mat
	return particles
