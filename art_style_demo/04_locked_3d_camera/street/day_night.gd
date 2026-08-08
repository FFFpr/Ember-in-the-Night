extends Node3D
## Street day→night cycle for approach 04. Day 0–10 s, night 10–20 s, loop.

const CYCLE := 20.0
const DAY_LEN := 10.0
const FADE := 0.45

@onready var _sun: DirectionalLight3D = $Sun
@onready var _forge_spill: OmniLight3D = $ForgeSpill
@onready var _lantern: OmniLight3D = $Lantern
@onready var _window_glow: OmniLight3D = $WindowGlow
@onready var _world_env: WorldEnvironment = $WorldEnvironment

var _t := 0.0
var _ember_mats: Array[StandardMaterial3D] = []
var _window_mats: Array[StandardMaterial3D] = []


func _ready() -> void:
	# Locked shop-front framing (same transform day and night).
	var cam: Camera3D = $Camera3D
	cam.position = Vector3(4.2, 1.85, 6.8)
	cam.look_at(Vector3(-1.0, 1.5, -1.2), Vector3.UP)
	_build_street()
	_apply_look(0.0)


func _process(delta: float) -> void:
	_t = fmod(_t + delta, CYCLE)
	_apply_look(_night_amount(_t))


func _night_amount(t: float) -> float:
	# 0 = full day, 1 = full night; ≤0.5 s fades at dusk and dawn.
	if t < DAY_LEN - FADE * 0.5:
		return 0.0
	if t < DAY_LEN + FADE * 0.5:
		return clampf((t - (DAY_LEN - FADE * 0.5)) / FADE, 0.0, 1.0)
	if t < CYCLE - FADE * 0.5:
		return 1.0
	return 1.0 - clampf((t - (CYCLE - FADE * 0.5)) / FADE, 0.0, 1.0)


func _apply_look(night: float) -> void:
	_sun.light_energy = lerpf(0.95, 0.02, night)
	_sun.light_color = Color(0.75, 0.78, 0.85).lerp(Color(0.25, 0.3, 0.45), night)
	_forge_spill.light_energy = lerpf(0.7, 4.6, night)
	_lantern.light_energy = lerpf(0.0, 2.6, night)
	_window_glow.light_energy = lerpf(0.2, 2.0, night)

	var env := _world_env.environment
	env.background_color = Color(0.48, 0.55, 0.65).lerp(ArtDemoPalette.NIGHT_SKY, night)
	env.ambient_light_color = Color(0.55, 0.58, 0.64).lerp(Color(0.16, 0.22, 0.36), night)
	env.ambient_light_energy = lerpf(0.42, 0.1, night)
	env.fog_light_color = Color(0.55, 0.6, 0.68).lerp(Color(0.08, 0.1, 0.16), night)
	env.fog_density = lerpf(0.002, 0.012, night)

	for m in _ember_mats:
		m.emission_energy_multiplier = lerpf(0.9, 2.8, night)
	for m in _window_mats:
		m.emission_energy_multiplier = lerpf(0.05, 1.6, night)
		m.albedo_color = Color(0.55, 0.5, 0.4).lerp(ArtDemoPalette.EMBERS_CORE, night * 0.7)


func _build_street() -> void:
	var root := $Greybox
	var stone := ArtDemoPalette.mat(ArtDemoPalette.STONE)
	var stone_dark := ArtDemoPalette.mat(ArtDemoPalette.STONE_DARK)
	var wood := ArtDemoPalette.mat(ArtDemoPalette.WOOD)
	var wood_dark := ArtDemoPalette.mat(ArtDemoPalette.WOOD_DARK)
	var plaster := ArtDemoPalette.mat(ArtDemoPalette.PLASTER)
	var road := ArtDemoPalette.mat(ArtDemoPalette.ROAD)
	var roof := ArtDemoPalette.mat(ArtDemoPalette.ROOF)
	var metal := ArtDemoPalette.metal_mat()
	var embers := ArtDemoPalette.mat(ArtDemoPalette.EMBERS, ArtDemoPalette.EMBERS, 1.2)
	var ember_core := ArtDemoPalette.mat(ArtDemoPalette.EMBERS_CORE, ArtDemoPalette.EMBERS_CORE, 2.0)
	var window_mat := ArtDemoPalette.mat(Color(0.55, 0.5, 0.4), ArtDemoPalette.EMBERS_CORE, 0.05)
	_ember_mats = [embers, ember_core]
	_window_mats = [window_mat]

	# Ground / street.
	ArtDemoGreybox.box(root, "Road", Vector3(14.0, 0.15, 10.0), Vector3(1.0, -0.08, 1.5), road)
	ArtDemoGreybox.box(root, "Curb", Vector3(8.0, 0.18, 0.35), Vector3(-1.5, 0.05, -0.6), stone_dark)

	# Smithy facade (left-center) — shop-front composition.
	ArtDemoGreybox.box(root, "SmithyBase", Vector3(5.2, 2.4, 4.0), Vector3(-2.2, 1.15, -2.8), stone)
	ArtDemoGreybox.box(root, "SmithyUpper", Vector3(5.0, 1.8, 3.6), Vector3(-2.2, 3.15, -2.9), plaster)
	ArtDemoGreybox.box(root, "TimberMid", Vector3(5.1, 0.18, 3.7), Vector3(-2.2, 2.35, -2.85), wood_dark)
	ArtDemoGreybox.box(root, "Roof", Vector3(5.8, 0.25, 4.4), Vector3(-2.2, 4.2, -2.9), roof, 0.12)
	ArtDemoGreybox.box(root, "RoofPeak", Vector3(5.6, 0.2, 2.2), Vector3(-2.2, 4.55, -3.4), roof, -0.2)

	# Open forge bay + door (bay faces +Z / street).
	ArtDemoGreybox.box(root, "Door", Vector3(1.0, 2.0, 0.12), Vector3(-3.7, 1.0, -0.75), wood_dark)
	ArtDemoGreybox.box(root, "PorchBeam", Vector3(3.6, 0.2, 0.2), Vector3(-1.2, 2.4, -0.55), wood)
	ArtDemoGreybox.box(root, "PorchPostL", Vector3(0.18, 2.35, 0.18), Vector3(-2.8, 1.12, -0.55), wood_dark)
	ArtDemoGreybox.box(root, "PorchPostR", Vector3(0.18, 2.35, 0.18), Vector3(0.4, 1.12, -0.55), wood_dark)

	ArtDemoGreybox.box(root, "ForgeArchL", Vector3(0.35, 1.8, 1.1), Vector3(-1.7, 0.95, -1.2), stone_dark)
	ArtDemoGreybox.box(root, "ForgeArchR", Vector3(0.35, 1.8, 1.1), Vector3(0.1, 0.95, -1.2), stone_dark)
	ArtDemoGreybox.box(root, "ForgeLintel", Vector3(2.2, 0.28, 1.15), Vector3(-0.8, 1.95, -1.2), stone)
	ArtDemoGreybox.box(root, "CoalBed", Vector3(1.4, 0.25, 0.8), Vector3(-0.8, 0.35, -1.35), ArtDemoPalette.mat(ArtDemoPalette.COAL))
	ArtDemoGreybox.box(root, "Embers", Vector3(1.0, 0.3, 0.5), Vector3(-0.8, 0.58, -1.15), embers)
	ArtDemoGreybox.sphere(root, "EmberCore", 0.2, Vector3(-0.8, 0.82, -1.0), ember_core)

	# Anvil visible in bay / porch.
	ArtDemoGreybox.cylinder(root, "AnvilStump", 0.3, 0.42, Vector3(0.55, 0.22, -0.55), wood_dark)
	ArtDemoGreybox.box(root, "Anvil", Vector3(0.62, 0.24, 0.32), Vector3(0.55, 0.58, -0.55), metal)

	# Hanging sign toward street.
	ArtDemoGreybox.box(root, "SignArm", Vector3(1.3, 0.08, 0.08), Vector3(0.1, 2.85, -0.35), wood)
	ArtDemoGreybox.box(root, "SignBoard", Vector3(0.75, 0.6, 0.08), Vector3(0.75, 2.65, -0.35), wood_dark)
	ArtDemoGreybox.box(root, "SignHammer", Vector3(0.14, 0.32, 0.05), Vector3(0.75, 2.68, -0.28), metal)

	# Night window.
	ArtDemoGreybox.box(root, "WindowFrame", Vector3(0.7, 0.7, 0.1), Vector3(-3.7, 1.65, -0.75), wood)
	ArtDemoGreybox.box(root, "WindowPane", Vector3(0.5, 0.5, 0.05), Vector3(-3.7, 1.65, -0.68), window_mat)

	# Street props.
	ArtDemoGreybox.cylinder(root, "BarrelA", 0.35, 0.75, Vector3(1.6, 0.38, 0.9), wood)
	ArtDemoGreybox.cylinder(root, "BarrelB", 0.3, 0.65, Vector3(2.2, 0.32, 0.55), wood_dark)
	ArtDemoGreybox.box(root, "Crate", Vector3(0.7, 0.5, 0.6), Vector3(-4.3, 0.28, 0.5), wood_dark)
	ArtDemoGreybox.cylinder(root, "WagonWheel", 0.48, 0.08, Vector3(-4.6, 0.48, -0.3), wood, PI * 0.5, 0.3)

	# Neighboring building masses (right / depth).
	ArtDemoGreybox.box(root, "NeighborA", Vector3(3.8, 4.4, 3.8), Vector3(5.2, 2.1, -2.8), plaster)
	ArtDemoGreybox.box(root, "NeighborARoof", Vector3(4.2, 0.25, 4.2), Vector3(5.2, 4.45, -2.8), roof, 0.08)
	ArtDemoGreybox.box(root, "NeighborB", Vector3(4.2, 3.8, 4.2), Vector3(2.8, 1.8, -7.2), stone)
	ArtDemoGreybox.box(root, "NeighborBRoof", Vector3(4.6, 0.25, 4.6), Vector3(2.8, 3.85, -7.2), roof)
	ArtDemoGreybox.box(root, "FarHouse", Vector3(3.4, 3.4, 3.2), Vector3(-5.8, 1.6, -7.5), plaster)
	ArtDemoGreybox.box(root, "FarRoof", Vector3(3.8, 0.25, 3.6), Vector3(-5.8, 3.4, -7.5), roof)

	# Lantern post near porch.
	ArtDemoGreybox.cylinder(root, "LanternPost", 0.06, 2.5, Vector3(0.9, 1.25, 0.15), wood_dark)
	ArtDemoGreybox.box(root, "LanternHousing", Vector3(0.24, 0.3, 0.24), Vector3(0.9, 2.45, 0.15), metal)
