extends Node2D

## 01 street: fixed shop-front framing; day 0–10s, night 10–20s via modulate + glow sprites.

@onready var camera: Camera2D = $Camera2D

var _plates: Dictionary = {}
var _elapsed := 0.0
const CYCLE := 20.0
const DAY_END := 10.0
const FADE := 0.45


func _ready() -> void:
	_plates = ArtDemoPlates.build_street(self)
	camera.position = ArtDemoPalette.VIEW * 0.5
	camera.make_current()
	_apply_blend(0.0)


func _process(delta: float) -> void:
	_elapsed = fmod(_elapsed + delta, CYCLE)
	_apply_blend(_night_blend())


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
	# Cool the whole plate set at night; warm reads come from glow sprites.
	modulate = Color.WHITE.lerp(Color(0.42, 0.48, 0.62), night)

	var door_glow: Polygon2D = _plates.door_glow
	var window_glow: Polygon2D = _plates.window_glow
	var lantern_glow: Polygon2D = _plates.lantern_glow
	var forge_spill: Polygon2D = _plates.forge_spill
	var fire: Polygon2D = _plates.street_fire

	door_glow.visible = night > 0.05
	window_glow.visible = night > 0.05
	lantern_glow.visible = night > 0.05

	door_glow.color = Color(ArtDemoPalette.WINDOW_GLOW, ArtDemoPalette.WINDOW_GLOW.a * night)
	window_glow.color = Color(ArtDemoPalette.WINDOW_GLOW, ArtDemoPalette.WINDOW_GLOW.a * night)
	lantern_glow.color = Color(ArtDemoPalette.GLOW_WARM, ArtDemoPalette.GLOW_WARM.a * night)
	forge_spill.color = Color(ArtDemoPalette.FORGE_GLOW, lerp(0.3, ArtDemoPalette.FORGE_GLOW.a, night))
	fire.color = ArtDemoPalette.EMBER.lerp(ArtDemoPalette.EMBER_SOFT, night * 0.45)
