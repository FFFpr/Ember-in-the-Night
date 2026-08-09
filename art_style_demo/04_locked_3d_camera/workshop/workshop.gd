extends Node3D
## Locked FP workshop — pack meshes only (tiny emissive glow helpers allowed).

const KENNEY := "res://art_style_demo/shared/imported/kenney_fantasy_town_kit/Models/GLB format/"
const BLACKSMITH := "res://art_style_demo/shared/imported/oga_sandsound_blacksmith/"
const QUAT := "res://art_style_demo/shared/imported/quaternius_medieval_village/glTF/"
const RTS := "res://art_style_demo/shared/imported/quaternius_ultimate_fantasy_rts/FBX/"

@onready var _camera: Camera3D = $Camera3D
@onready var _forge_light: OmniLight3D = $ForgeLight

var _ember_core: MeshInstance3D
var _base_cam_rotation: Vector3
var _t := 0.0


func _ready() -> void:
	_camera.position = Vector3(0.0, 1.6, 2.7)
	_camera.look_at(Vector3(0.0, 0.95, -1.4), Vector3.UP)
	_base_cam_rotation = _camera.rotation
	_build_room()
	_build_props()


func _process(delta: float) -> void:
	_t += delta
	_camera.rotation = _base_cam_rotation + Vector3(
		sin(_t * 0.55) * 0.008,
		sin(_t * 0.37) * 0.012,
		0.0
	)
	if _forge_light:
		_forge_light.light_energy = 3.6 + sin(_t * 3.1) * 0.4 + sin(_t * 7.4) * 0.15
	if _ember_core and _ember_core.material_override is StandardMaterial3D:
		var m := _ember_core.material_override as StandardMaterial3D
		m.emission_energy_multiplier = 2.6 + sin(_t * 4.2) * 0.55


func _tile(parent: Node3D, name_: String, path: String, pos: Vector3, rot_y: float = 0.0, scl: Vector3 = Vector3.ONE) -> void:
	ArtDemoPackLoader.add_asset(parent, name_, path, pos, rot_y, scl)


func _build_room() -> void:
	var room := $Room
	# Floor: Quaternius 2×2 brick tiles.
	for x in [-3.0, -1.0, 1.0, 3.0]:
		for z in [-3.0, -1.0, 1.0]:
			_tile(room, "Floor_%s_%s" % [x, z], QUAT + "Floor_Brick.gltf", Vector3(x, 0.0, z), 0.0)
	# Ceiling: Quaternius wood floor tiles flipped as underside planks.
	for x in [-3.0, -1.0, 1.0, 3.0]:
		for z in [-3.0, -1.0, 1.0]:
			_tile(room, "Ceil_%s_%s" % [x, z], QUAT + "Floor_WoodDark.gltf", Vector3(x, 3.35, z), 0.0)

	# Kenney walls: thin on X → rotate for facing.
	var face_cam := PI * 0.5
	for x in [-2.0, -1.0, 0.0, 1.0, 2.0]:
		_tile(room, "Back_%s" % x, KENNEY + "wall-wood.glb", Vector3(x, 0.0, -3.3), face_cam)
		_tile(room, "BackUp_%s" % x, KENNEY + "wall-wood.glb", Vector3(x, 1.0, -3.3), face_cam)
	_tile(room, "HearthArch", KENNEY + "wall-wood-arch.glb", Vector3(0.0, 0.0, -3.25), face_cam)
	_tile(room, "HearthArchTop", KENNEY + "wall-wood-arch-top.glb", Vector3(0.0, 1.0, -3.25), face_cam)

	for z in [-2.5, -1.5, -0.5, 0.5]:
		_tile(room, "L_%s" % z, KENNEY + "wall-wood.glb", Vector3(-3.4, 0.0, z), 0.0)
		_tile(room, "LU_%s" % z, KENNEY + "wall-wood.glb", Vector3(-3.4, 1.0, z), 0.0)
		_tile(room, "R_%s" % z, KENNEY + "wall-wood.glb", Vector3(3.4, 0.0, z), PI)
		_tile(room, "RU_%s" % z, KENNEY + "wall-wood.glb", Vector3(3.4, 1.0, z), PI)
	_tile(room, "ColdWindow", KENNEY + "wall-window-glass.glb", Vector3(-3.35, 1.0, -1.5), 0.0)

	for i in 4:
		var z := -2.4 + float(i) * 1.1
		_tile(room, "Beam_%d" % i, KENNEY + "planks.glb", Vector3(0.0, 3.15, z), face_cam, Vector3(1.6, 0.7, 0.7))
	_tile(room, "Chimney", KENNEY + "chimney.glb", Vector3(0.0, 2.0, -3.45), face_cam)
	_tile(room, "ChimneyTop", KENNEY + "chimney-top.glb", Vector3(0.0, 3.0, -3.45), face_cam)


func _build_props() -> void:
	var props := $Props
	var anvil_tex: Texture2D = load(BLACKSMITH + "anvil/anvil_skin.png")
	var furnace_tex: Texture2D = load(BLACKSMITH + "furnace/furnace_skin.png")
	var tub_tex: Texture2D = load(BLACKSMITH + "tub/tub_skin.png")
	var hammer_tex: Texture2D = load(BLACKSMITH + "hammer/hammer_skin.png")

	ArtDemoPackLoader.add_asset(props, "Furnace", BLACKSMITH + "furnace/furnace.obj", Vector3(0.0, 0.0, -2.5), PI, Vector3(0.32, 0.32, 0.32), furnace_tex)
	ArtDemoPackLoader.add_asset(props, "Anvil", BLACKSMITH + "anvil/anvil.obj", Vector3(0.05, 0.0, -0.35), deg_to_rad(-25.0), Vector3(0.38, 0.38, 0.38), anvil_tex)
	ArtDemoPackLoader.add_asset(props, "QuenchTub", BLACKSMITH + "tub/tub.obj", Vector3(-2.0, 0.0, -0.1), deg_to_rad(20.0), Vector3(0.35, 0.35, 0.35), tub_tex)
	ArtDemoPackLoader.add_asset(props, "HammerA", BLACKSMITH + "hammer/hammer.obj", Vector3(-3.05, 1.55, -0.4), deg_to_rad(90.0), Vector3(0.7, 0.7, 0.7), hammer_tex)
	ArtDemoPackLoader.add_asset(props, "HammerB", BLACKSMITH + "hammer/hammer.obj", Vector3(-3.05, 1.75, 0.0), deg_to_rad(95.0), Vector3(0.7, 0.7, 0.7), hammer_tex)
	ArtDemoPackLoader.add_asset(props, "HammerC", BLACKSMITH + "hammer/hammer.obj", Vector3(-3.05, 1.95, 0.35), deg_to_rad(85.0), Vector3(0.7, 0.7, 0.7), hammer_tex)

	_tile(props, "ToolRack", KENNEY + "planks.glb", Vector3(-3.2, 1.5, 0.0), 0.0, Vector3(0.5, 0.5, 0.5))
	_tile(props, "BellowsProxy", KENNEY + "cart.glb", Vector3(2.1, 0.0, -2.15), deg_to_rad(-35.0), Vector3(0.5, 0.5, 0.5))
	_tile(props, "OreCrate", RTS + "Crate.fbx", Vector3(1.9, 0.0, -1.25), deg_to_rad(12.0), Vector3(1.0, 1.0, 1.0))
	_tile(props, "OrePile", KENNEY + "rock-small.glb", Vector3(1.9, 0.55, -1.25), deg_to_rad(40.0), Vector3(0.35, 0.25, 0.35))
	_tile(props, "Logs", RTS + "Logs.fbx", Vector3(2.35, 0.0, -1.55), deg_to_rad(-25.0), Vector3(0.7, 0.7, 0.7))
	_tile(props, "IngotA", KENNEY + "blade.glb", Vector3(1.45, 0.05, -0.85), deg_to_rad(90.0), Vector3(0.35, 0.12, 0.35))
	_tile(props, "IngotB", KENNEY + "blade.glb", Vector3(1.7, 0.05, -0.7), deg_to_rad(85.0), Vector3(0.35, 0.12, 0.35))
	_tile(props, "HangBladeA", KENNEY + "blade.glb", Vector3(-3.1, 2.05, -1.55), 0.0, Vector3(0.35, 0.35, 0.35))
	_tile(props, "HangBladeB", KENNEY + "blade.glb", Vector3(-3.1, 2.25, -1.25), 0.0, Vector3(0.35, 0.35, 0.35))
	_tile(props, "HangBladeC", KENNEY + "blade.glb", Vector3(-3.1, 2.45, -0.95), 0.0, Vector3(0.35, 0.35, 0.35))
	_tile(props, "Bench", KENNEY + "stall-bench.glb", Vector3(0.15, 0.0, 1.65), 0.0, Vector3(1.15, 1.0, 1.0))
	_tile(props, "TongsProxy", KENNEY + "poles.glb", Vector3(-0.2, 0.95, 1.55), deg_to_rad(90.0), Vector3(0.35, 0.35, 0.55))
	_tile(props, "Barrel", RTS + "Barrel.fbx", Vector3(-2.55, 0.0, 0.55), deg_to_rad(10.0), Vector3(0.85, 0.85, 0.85))

	# Allowed: tiny emissive glow helpers only.
	var ember_core := ArtDemoPalette.mat(ArtDemoPalette.EMBERS_CORE, ArtDemoPalette.EMBERS_CORE, 2.9)
	_ember_core = ArtDemoGreybox.sphere(props, "EmberCore", 0.12, Vector3(0.0, 0.72, -2.15), ember_core)
