extends Node3D
## Street day→night — pack meshes only (tiny emissive glow helpers allowed).

const CYCLE := 20.0
const DAY_LEN := 10.0
const FADE := 0.45

const KENNEY := "res://art_style_demo/shared/imported/kenney_fantasy_town_kit/Models/GLB format/"
const BLACKSMITH := "res://art_style_demo/shared/imported/oga_sandsound_blacksmith/"
const QUAT := "res://art_style_demo/shared/imported/quaternius_medieval_village/glTF/"
const RTS := "res://art_style_demo/shared/imported/quaternius_ultimate_fantasy_rts/FBX/"

@onready var _sun: DirectionalLight3D = $Sun
@onready var _forge_spill: OmniLight3D = $ForgeSpill
@onready var _lantern: OmniLight3D = $Lantern
@onready var _window_glow: OmniLight3D = $WindowGlow
@onready var _world_env: WorldEnvironment = $WorldEnvironment

var _t := 0.0
var _ember_mats: Array[StandardMaterial3D] = []


func _ready() -> void:
	var cam: Camera3D = $Camera3D
	cam.position = Vector3(5.0, 2.0, 8.0)
	cam.look_at(Vector3(-0.5, 1.4, -1.2), Vector3.UP)
	_build_street()
	_apply_look(0.0)


func _process(delta: float) -> void:
	_t = fmod(_t + delta, CYCLE)
	_apply_look(_night_amount(_t))


func _night_amount(t: float) -> float:
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
	_forge_spill.light_energy = lerpf(0.9, 5.0, night)
	_lantern.light_energy = lerpf(0.0, 2.8, night)
	_window_glow.light_energy = lerpf(0.25, 2.1, night)

	var env := _world_env.environment
	env.background_color = Color(0.48, 0.55, 0.65).lerp(ArtDemoPalette.NIGHT_SKY, night)
	env.ambient_light_color = Color(0.55, 0.58, 0.64).lerp(Color(0.16, 0.22, 0.36), night)
	env.ambient_light_energy = lerpf(0.42, 0.1, night)
	env.fog_light_color = Color(0.55, 0.6, 0.68).lerp(Color(0.08, 0.1, 0.16), night)
	env.fog_density = lerpf(0.002, 0.012, night)

	for m in _ember_mats:
		m.emission_energy_multiplier = lerpf(1.0, 3.0, night)


func _tile(parent: Node3D, name_: String, path: String, pos: Vector3, rot_y: float = 0.0, scl: Vector3 = Vector3.ONE) -> void:
	ArtDemoPackLoader.add_asset(parent, name_, path, pos, rot_y, scl)


func _build_street() -> void:
	var root := $World
	var ember_core := ArtDemoPalette.mat(ArtDemoPalette.EMBERS_CORE, ArtDemoPalette.EMBERS_CORE, 2.2)
	_ember_mats = [ember_core]

	var face_street := PI * 0.5

	# Ground entirely from Kenney road tiles (no flat BoxMesh ground).
	for x in range(-6, 7):
		for z in range(-2, 6):
			_tile(root, "Road_%d_%d" % [x, z], KENNEY + "road.glb", Vector3(float(x), 0.0, float(z)), 0.0)
	for x in range(-6, 7):
		_tile(root, "Curb_%d" % x, KENNEY + "road-curb.glb", Vector3(float(x), 0.0, -0.5), 0.0)

	# Smithy facade.
	for x in [-3.0, -2.0, -1.0, 0.0, 1.0]:
		_tile(root, "Base_%s" % x, KENNEY + "wall.glb", Vector3(x, 0.0, -2.2), face_street)
		_tile(root, "Upper_%s" % x, KENNEY + "wall.glb", Vector3(x, 1.0, -2.2), face_street)
		_tile(root, "Roof_%s" % x, KENNEY + "roof.glb", Vector3(x, 2.0, -2.2), face_street)

	_tile(root, "DoorWall", KENNEY + "wall-door.glb", Vector3(-3.0, 0.0, -2.15), face_street)
	_tile(root, "Door", QUAT + "Door_2_Flat.gltf", Vector3(-3.0, 0.0, -1.7), face_street, Vector3(0.8, 0.8, 0.8))
	_tile(root, "ForgeBay", KENNEY + "wall-doorway-square-wide.glb", Vector3(-0.5, 0.0, -2.15), face_street)
	_tile(root, "Window", KENNEY + "wall-window-glass.glb", Vector3(-3.0, 1.0, -2.15), face_street)
	_tile(root, "Chimney", KENNEY + "chimney.glb", Vector3(0.0, 2.0, -2.4), face_street)
	_tile(root, "ChimneyTop", KENNEY + "chimney-top.glb", Vector3(0.0, 3.0, -2.4), face_street)

	_tile(root, "Overhang", KENNEY + "overhang.glb", Vector3(-1.0, 1.0, -1.35), face_street)
	_tile(root, "PostL", KENNEY + "pillar-wood.glb", Vector3(-2.4, 0.0, -1.15), 0.0)
	_tile(root, "PostR", KENNEY + "pillar-wood.glb", Vector3(0.5, 0.0, -1.15), 0.0)

	var furnace_tex: Texture2D = load(BLACKSMITH + "furnace/furnace_skin.png")
	var anvil_tex: Texture2D = load(BLACKSMITH + "anvil/anvil_skin.png")
	ArtDemoPackLoader.add_asset(root, "Furnace", BLACKSMITH + "furnace/furnace.obj", Vector3(-0.5, 0.0, -1.55), PI, Vector3(0.28, 0.28, 0.28), furnace_tex)
	ArtDemoPackLoader.add_asset(root, "Anvil", BLACKSMITH + "anvil/anvil.obj", Vector3(0.55, 0.0, -0.9), deg_to_rad(25.0), Vector3(0.32, 0.32, 0.32), anvil_tex)
	# Allowed tiny emissive helper.
	ArtDemoGreybox.sphere(root, "EmberCore", 0.1, Vector3(-0.5, 0.65, -1.15), ember_core)

	_tile(root, "SignBanner", KENNEY + "banner-red.glb", Vector3(0.95, 1.55, -0.95), deg_to_rad(-15.0), Vector3(0.9, 0.9, 0.9))
	_tile(root, "SignBlade", KENNEY + "blade.glb", Vector3(1.0, 1.9, -0.8), deg_to_rad(90.0), Vector3(0.6, 0.6, 0.6))
	_tile(root, "LanternMesh", KENNEY + "lantern.glb", Vector3(1.05, 1.75, 0.05), 0.0)
	_tile(root, "Crate", RTS + "Crate.fbx", Vector3(-4.1, 0.0, 0.7), deg_to_rad(10.0), Vector3(1.2, 1.2, 1.2))
	_tile(root, "CrateStack", RTS + "Crate_Stack1.fbx", Vector3(-4.6, 0.0, -0.2), deg_to_rad(-8.0), Vector3(1.0, 1.0, 1.0))
	_tile(root, "Wagon", QUAT + "Prop_Wagon.gltf", Vector3(2.8, 0.0, 1.4), deg_to_rad(-30.0), Vector3(0.8, 0.8, 0.8))
	_tile(root, "Cart", KENNEY + "cart.glb", Vector3(-4.4, 0.0, 1.5), deg_to_rad(18.0), Vector3(0.85, 0.85, 0.85))
	_tile(root, "Stall", KENNEY + "stall-red.glb", Vector3(1.9, 0.0, 0.4), deg_to_rad(-12.0), Vector3(0.85, 0.85, 0.85))
	_tile(root, "BarrelA", RTS + "Barrel.fbx", Vector3(2.2, 0.0, 0.9), deg_to_rad(20.0), Vector3(1.1, 1.1, 1.1))
	_tile(root, "BarrelB", RTS + "Barrel.fbx", Vector3(2.55, 0.0, 0.45), deg_to_rad(-15.0), Vector3(0.95, 0.95, 0.95))
	_tile(root, "FenceA", KENNEY + "fence.glb", Vector3(-5.2, 0.0, -0.8), face_street)
	_tile(root, "Stairs", KENNEY + "stairs-wood.glb", Vector3(-3.8, 0.0, -0.9), face_street)
	_tile(root, "Logs", RTS + "Logs.fbx", Vector3(0.9, 0.0, -0.55), deg_to_rad(40.0), Vector3(0.9, 0.9, 0.9))

	# Neighbors — deeper massing with side returns.
	for x in [3.5, 4.5, 5.5]:
		_tile(root, "NBase_%s" % x, KENNEY + "wall.glb", Vector3(x, 0.0, -3.8), face_street)
		_tile(root, "NUpper_%s" % x, KENNEY + "wall.glb", Vector3(x, 1.0, -3.8), face_street)
		_tile(root, "NRoof_%s" % x, KENNEY + "roof-gable.glb", Vector3(x, 2.0, -3.8), face_street)
		_tile(root, "NSide_%s" % x, KENNEY + "wall.glb", Vector3(x + 0.5, 0.0, -4.3), 0.0)
		_tile(root, "NSideUp_%s" % x, KENNEY + "wall.glb", Vector3(x + 0.5, 1.0, -4.3), 0.0)
	for x in [-5.5, -4.5]:
		_tile(root, "FBase_%s" % x, KENNEY + "wall.glb", Vector3(x, 0.0, -5.8), face_street)
		_tile(root, "FUpper_%s" % x, KENNEY + "wall.glb", Vector3(x, 1.0, -5.8), face_street)
		_tile(root, "FRoof_%s" % x, KENNEY + "roof.glb", Vector3(x, 2.0, -5.8), face_street)
