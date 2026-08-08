extends Node2D

## 02 street: same plates as 01; day/night driven by light rig (+ supporting glows).

@onready var camera: Camera2D = $Camera2D
@onready var ambient: CanvasModulate = $CanvasModulate
@onready var sun: DirectionalLight2D = $Lights/Sun
@onready var forge_light: PointLight2D = $Lights/ForgeLight
@onready var door_light: PointLight2D = $Lights/DoorLight
@onready var window_light: PointLight2D = $Lights/WindowLight
@onready var lantern_light: PointLight2D = $Lights/LanternLight
@onready var sparks: GPUParticles2D = $Lights/Sparks

var _plates: Dictionary = {}
var _elapsed := 0.0
const CYCLE := 20.0
const DAY_END := 10.0
const FADE := 0.45


func _ready() -> void:
	_plates = ArtDemoPlates.build_street(self)
	camera.position = ArtDemoPalette.VIEW * 0.5
	camera.make_current()
	_configure_sparks()
	_apply_blend(0.0)


func _process(delta: float) -> void:
	_elapsed = fmod(_elapsed + delta, CYCLE)
	_apply_blend(_night_blend())
	forge_light.energy = lerp(0.55, 1.4, _night_blend()) + sin(_elapsed * 11.0) * 0.1


func _night_blend() -> float:
	if _elapsed < DAY_END:
		return 0.0
	var into_night := _elapsed - DAY_END
	if into_night < FADE:
		return into_night / FADE
	if _elapsed > CYCLE - FADE:
		return (CYCLE - _elapsed) / FADE
	return 1.0


func _apply_blend(night: float) -> void:
	var sky: Polygon2D = _plates.sky
	sky.color = ArtDemoPalette.SKY_DAY.lerp(ArtDemoPalette.SKY_NIGHT, night)

	ambient.color = Color(0.92, 0.94, 0.98).lerp(Color(0.28, 0.34, 0.48), night)
	sun.energy = lerp(0.85, 0.05, night)
	sun.enabled = sun.energy > 0.08

	forge_light.enabled = true
	door_light.enabled = night > 0.05
	window_light.enabled = night > 0.05
	lantern_light.enabled = night > 0.05

	door_light.energy = 1.1 * night
	window_light.energy = 0.9 * night
	lantern_light.energy = 1.0 * night

	var door_glow: Polygon2D = _plates.door_glow
	var window_glow: Polygon2D = _plates.window_glow
	var lantern_glow: Polygon2D = _plates.lantern_glow
	door_glow.visible = night > 0.05
	window_glow.visible = night > 0.05
	lantern_glow.visible = night > 0.05
	door_glow.color = Color(ArtDemoPalette.WINDOW_GLOW, ArtDemoPalette.WINDOW_GLOW.a * night * 0.5)
	window_glow.color = Color(ArtDemoPalette.WINDOW_GLOW, ArtDemoPalette.WINDOW_GLOW.a * night * 0.5)
	lantern_glow.color = Color(ArtDemoPalette.GLOW_WARM, ArtDemoPalette.GLOW_WARM.a * night * 0.4)

	var spill: Polygon2D = _plates.forge_spill
	spill.color = Color(ArtDemoPalette.FORGE_GLOW, lerp(0.25, 0.7, night))

	sparks.emitting = true


func _configure_sparks() -> void:
	var mat := ParticleProcessMaterial.new()
	mat.direction = Vector3(0, -1, 0)
	mat.spread = 28.0
	mat.initial_velocity_min = 30.0
	mat.initial_velocity_max = 90.0
	mat.gravity = Vector3(0, 35, 0)
	mat.scale_min = 1.2
	mat.scale_max = 2.8
	mat.color = ArtDemoPalette.EMBER_CORE
	sparks.process_material = mat
	sparks.amount = 18
	sparks.lifetime = 0.8
	sparks.position = Vector2(710, 420)
	sparks.visibility_rect = Rect2(-60, -100, 120, 140)
