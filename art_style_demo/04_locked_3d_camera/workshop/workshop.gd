extends Node3D
## Locked FP workshop — Compare pass using imported stylized packs.

const KENNEY := "res://art_style_demo/shared/imported/kenney_fantasy_town_kit/Models/GLB format/"
const BLACKSMITH := "res://art_style_demo/shared/imported/oga_sandsound_blacksmith/"
const QUAT := "res://art_style_demo/shared/imported/quaternius_medieval_village/glTF/"

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
	ArtDemoGreybox.box(room, "Floor", Vector3(8.0, 0.12, 7.0), Vector3(0.0, -0.06, -0.5), ArtDemoPalette.mat(ArtDemoPalette.STONE_DARK))
	ArtDemoGreybox.box(room, "Ceiling", Vector3(8.0, 0.12, 7.0), Vector3(0.0, 3.4, -0.5), ArtDemoPalette.mat(ArtDemoPalette.WOOD_DARK))

	# Kenney walls are thin on X; rotate so faces look along ±Z / ±X as needed.
	# Back wall (face camera): rot_y = PI/2
	var face_cam := PI * 0.5
	for x in [-2.0, -1.0, 0.0, 1.0, 2.0]:
		_tile(room, "Back_%s" % x, KENNEY + "wall.glb", Vector3(x, 0.0, -3.3), face_cam)
		_tile(room, "BackUp_%s" % x, KENNEY + "wall.glb", Vector3(x, 1.0, -3.3), face_cam)
	_tile(room, "HearthArch", KENNEY + "wall-arch.glb", Vector3(0.0, 0.0, -3.25), face_cam)
	_tile(room, "HearthArchTop", KENNEY + "wall-arch-top.glb", Vector3(0.0, 1.0, -3.25), face_cam)

	# Left wall (face +X): rot_y = 0; Right wall (face -X): rot_y = PI
	for z in [-2.5, -1.5, -0.5, 0.5]:
		_tile(room, "L_%s" % z, KENNEY + "wall.glb", Vector3(-3.4, 0.0, z), 0.0)
		_tile(room, "LU_%s" % z, KENNEY + "wall.glb", Vector3(-3.4, 1.0, z), 0.0)
		_tile(room, "R_%s" % z, KENNEY + "wall.glb", Vector3(3.4, 0.0, z), PI)
		_tile(room, "RU_%s" % z, KENNEY + "wall.glb", Vector3(3.4, 1.0, z), PI)
	_tile(room, "ColdWindow", KENNEY + "wall-window-glass.glb", Vector3(-3.35, 1.0, -1.5), 0.0)

	# Beams / chimney.
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

	# Furnace raw size ~6m → scale ~0.32; anvil ~2.7m tall → scale ~0.38.
	ArtDemoPackLoader.add_asset(props, "Furnace", BLACKSMITH + "furnace/furnace.obj", Vector3(0.0, 0.0, -2.5), PI, Vector3(0.32, 0.32, 0.32), furnace_tex)
	ArtDemoPackLoader.add_asset(props, "Anvil", BLACKSMITH + "anvil/anvil.obj", Vector3(0.05, 0.0, -0.35), deg_to_rad(-25.0), Vector3(0.38, 0.38, 0.38), anvil_tex)
	ArtDemoPackLoader.add_asset(props, "QuenchTub", BLACKSMITH + "tub/tub.obj", Vector3(-2.0, 0.0, -0.1), deg_to_rad(20.0), Vector3(0.35, 0.35, 0.35), tub_tex)
	ArtDemoPackLoader.add_asset(props, "HammerA", BLACKSMITH + "hammer/hammer.obj", Vector3(-3.05, 1.55, -0.4), deg_to_rad(90.0), Vector3(0.7, 0.7, 0.7), hammer_tex)
	ArtDemoPackLoader.add_asset(props, "HammerB", BLACKSMITH + "hammer/hammer.obj", Vector3(-3.05, 1.75, 0.0), deg_to_rad(95.0), Vector3(0.7, 0.7, 0.7), hammer_tex)
	ArtDemoPackLoader.add_asset(props, "HammerC", BLACKSMITH + "hammer/hammer.obj", Vector3(-3.05, 1.95, 0.35), deg_to_rad(85.0), Vector3(0.7, 0.7, 0.7), hammer_tex)

	_tile(props, "ToolRack", KENNEY + "planks.glb", Vector3(-3.2, 1.5, 0.0), 0.0, Vector3(0.5, 0.5, 0.5))
	_tile(props, "BellowsProxy", KENNEY + "cart.glb", Vector3(2.1, 0.0, -2.15), deg_to_rad(-35.0), Vector3(0.5, 0.5, 0.5))
	_tile(props, "OreCrate", QUAT + "Prop_Crate.gltf", Vector3(1.9, 0.0, -1.25), deg_to_rad(12.0))
	_tile(props, "BladeHang", KENNEY + "blade.glb", Vector3(-3.1, 2.2, -1.35), 0.0, Vector3(0.65, 0.65, 0.65))
	_tile(props, "Bench", KENNEY + "stall-bench.glb", Vector3(0.15, 0.0, 1.65), 0.0, Vector3(1.15, 1.0, 1.0))

	var embers := ArtDemoPalette.mat(ArtDemoPalette.EMBERS, ArtDemoPalette.EMBERS, 1.9)
	var ember_core := ArtDemoPalette.mat(ArtDemoPalette.EMBERS_CORE, ArtDemoPalette.EMBERS_CORE, 2.9)
	ArtDemoGreybox.box(props, "Embers", Vector3(0.5, 0.16, 0.28), Vector3(0.0, 0.55, -2.25), embers)
	_ember_core = ArtDemoGreybox.sphere(props, "EmberCore", 0.13, Vector3(0.0, 0.75, -2.15), ember_core)

	for i in 3:
		var y := 2.15 - float(i) * 0.28
		ArtDemoGreybox.cylinder(props, "Horseshoe_%d" % i, 0.1, 0.03, Vector3(-3.1, y, -1.65), ArtDemoPalette.metal_mat(), PI * 0.5, 0.0)

	var metal := ArtDemoPalette.metal_mat(ArtDemoPalette.METAL_WARM)
	ArtDemoGreybox.box(props, "IngotA", Vector3(0.28, 0.08, 0.12), Vector3(1.5, 0.08, -0.9), metal)
	ArtDemoGreybox.box(props, "IngotB", Vector3(0.28, 0.08, 0.12), Vector3(1.75, 0.08, -0.8), metal)
