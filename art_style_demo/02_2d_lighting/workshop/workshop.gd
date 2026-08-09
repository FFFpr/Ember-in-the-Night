extends Node2D

## 02 workshop: same plates as 01 + CanvasModulate ambient, forge PointLight2D, sparks.

@onready var camera: Camera2D = $Camera2D
@onready var ambient: CanvasModulate = $CanvasModulate
@onready var forge_light: PointLight2D = $Lights/ForgeLight
@onready var sparks: GPUParticles2D = $Lights/Sparks

var _plates: Dictionary = {}
var _sway_t := 0.0
var _flicker_t := 0.0


func _ready() -> void:
	_plates = ArtDemoPlates.build_workshop(self)
	# Soft glow stays subtle under PointLight2D.
	var glow: Polygon2D = _plates.forge_glow
	glow.color = Color(ArtDemoPalette.FORGE_GLOW, 0.12)

	camera.position = ArtDemoPalette.VIEW * 0.5
	camera.make_current()

	ambient.color = Color(0.42, 0.48, 0.58)
	forge_light.position = Vector2(640, 340)
	forge_light.color = ArtDemoPalette.EMBER_SOFT
	forge_light.energy = 1.35
	forge_light.texture_scale = 1.6

	sparks.position = Vector2(640, 320)
	_configure_sparks()


func _process(delta: float) -> void:
	_sway_t += delta
	_flicker_t += delta
	camera.position = ArtDemoPalette.VIEW * 0.5 + Vector2(sin(_sway_t * 0.7) * 3.0, cos(_sway_t * 0.55) * 2.0)
	forge_light.energy = 1.2 + sin(_flicker_t * 9.0) * 0.18 + cos(_flicker_t * 14.0) * 0.08
	var glow: Polygon2D = _plates.forge_glow
	var pulse := 0.1 + 0.1 * (0.5 + 0.5 * sin(_flicker_t * 7.0))
	glow.color = Color(ArtDemoPalette.EMBER_SOFT, pulse)
	if _plates.has("forge") and _plates.forge is Sprite2D:
		(_plates.forge as Sprite2D).modulate = Color(1.0, 0.94 + 0.06 * sin(_flicker_t * 6.0), 0.88)


func _configure_sparks() -> void:
	var mat := ParticleProcessMaterial.new()
	mat.direction = Vector3(0, -1, 0)
	mat.spread = 35.0
	mat.initial_velocity_min = 40.0
	mat.initial_velocity_max = 110.0
	mat.gravity = Vector3(0, 40, 0)
	mat.scale_min = 1.5
	mat.scale_max = 3.5
	mat.color = ArtDemoPalette.EMBER_CORE
	sparks.process_material = mat
	sparks.amount = 28
	sparks.lifetime = 0.9
	sparks.emitting = true
	sparks.visibility_rect = Rect2(-80, -120, 160, 180)
