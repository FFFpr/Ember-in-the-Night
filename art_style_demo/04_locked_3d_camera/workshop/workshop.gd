extends Node3D
## Locked FP workshop greybox — forge / anvil composition for approach 04.

@onready var _camera: Camera3D = $Camera3D
@onready var _forge_light: OmniLight3D = $ForgeLight

var _ember_core: MeshInstance3D
var _base_cam_rotation: Vector3
var _t := 0.0


func _ready() -> void:
	_base_cam_rotation = _camera.rotation
	_build_room()
	_build_props()


func _process(delta: float) -> void:
	_t += delta
	# Tiny idle sway only — camera stays locked (no free look).
	_camera.rotation = _base_cam_rotation + Vector3(
		sin(_t * 0.55) * 0.008,
		sin(_t * 0.37) * 0.012,
		0.0
	)
	if _forge_light:
		_forge_light.light_energy = 3.2 + sin(_t * 3.1) * 0.35 + sin(_t * 7.4) * 0.12
	if _ember_core and _ember_core.material_override is StandardMaterial3D:
		var m := _ember_core.material_override as StandardMaterial3D
		m.emission_energy_multiplier = 2.4 + sin(_t * 4.2) * 0.5


func _build_room() -> void:
	var room := $Room
	var stone := ArtDemoPalette.mat(ArtDemoPalette.STONE)
	var stone_dark := ArtDemoPalette.mat(ArtDemoPalette.STONE_DARK)
	var wood := ArtDemoPalette.mat(ArtDemoPalette.WOOD)
	var wood_dark := ArtDemoPalette.mat(ArtDemoPalette.WOOD_DARK)
	var cool := ArtDemoPalette.mat(ArtDemoPalette.COOL_WALL)
	var night := ArtDemoPalette.mat(ArtDemoPalette.NIGHT_SKY)

	# Floor / walls / ceiling (interior box, open toward +Z for camera).
	ArtDemoGreybox.box(room, "Floor", Vector3(7.0, 0.2, 6.0), Vector3(0.0, -0.1, -0.5), stone_dark)
	ArtDemoGreybox.box(room, "BackWall", Vector3(7.0, 3.4, 0.25), Vector3(0.0, 1.6, -3.35), stone)
	ArtDemoGreybox.box(room, "LeftWall", Vector3(0.25, 3.4, 6.0), Vector3(-3.5, 1.6, -0.5), cool)
	ArtDemoGreybox.box(room, "RightWall", Vector3(0.25, 3.4, 6.0), Vector3(3.5, 1.6, -0.5), stone)
	ArtDemoGreybox.box(room, "Ceiling", Vector3(7.0, 0.2, 6.0), Vector3(0.0, 3.35, -0.5), wood_dark)

	# Hearth surround on back wall.
	ArtDemoGreybox.box(room, "HearthBase", Vector3(2.4, 0.55, 1.1), Vector3(0.0, 0.2, -2.7), stone_dark)
	ArtDemoGreybox.box(room, "HearthLeft", Vector3(0.35, 1.6, 1.0), Vector3(-1.05, 1.1, -2.75), stone)
	ArtDemoGreybox.box(room, "HearthRight", Vector3(0.35, 1.6, 1.0), Vector3(1.05, 1.1, -2.75), stone)
	ArtDemoGreybox.box(room, "HearthLintel", Vector3(2.5, 0.35, 1.05), Vector3(0.0, 1.95, -2.75), stone)
	ArtDemoGreybox.box(room, "Chimney", Vector3(1.2, 1.4, 0.9), Vector3(0.0, 2.7, -2.9), stone_dark)

	# Cold window (left wall) — cool contrast vs forge.
	ArtDemoGreybox.box(room, "WindowFrame", Vector3(0.12, 0.9, 0.7), Vector3(-3.35, 1.85, -1.6), wood)
	ArtDemoGreybox.box(room, "WindowPane", Vector3(0.05, 0.72, 0.55), Vector3(-3.28, 1.85, -1.6), night)

	# Rafters / beams.
	for i in 4:
		var z := -2.6 + float(i) * 1.15
		ArtDemoGreybox.box(room, "Rafter_%d" % i, Vector3(6.6, 0.18, 0.22), Vector3(0.0, 3.05, z), wood_dark)
	ArtDemoGreybox.box(room, "BeamCenter", Vector3(0.22, 0.22, 5.4), Vector3(0.0, 3.05, -0.5), wood)


func _build_props() -> void:
	var props := $Props
	var wood := ArtDemoPalette.mat(ArtDemoPalette.WOOD)
	var wood_dark := ArtDemoPalette.mat(ArtDemoPalette.WOOD_DARK)
	var metal := ArtDemoPalette.metal_mat()
	var metal_warm := ArtDemoPalette.metal_mat(ArtDemoPalette.METAL_WARM)
	var coal := ArtDemoPalette.mat(ArtDemoPalette.COAL)
	var water := ArtDemoPalette.mat(ArtDemoPalette.WATER)
	var embers := ArtDemoPalette.mat(ArtDemoPalette.EMBERS, ArtDemoPalette.EMBERS, 1.8)
	var ember_core := ArtDemoPalette.mat(ArtDemoPalette.EMBERS_CORE, ArtDemoPalette.EMBERS_CORE, 2.8)

	# Anvil on stump — center midground, in reach.
	ArtDemoGreybox.cylinder(props, "AnvilStump", 0.42, 0.55, Vector3(0.0, 0.28, -0.15), wood_dark)
	ArtDemoGreybox.box(props, "AnvilBody", Vector3(0.85, 0.35, 0.38), Vector3(0.0, 0.72, -0.15), metal_warm)
	ArtDemoGreybox.box(props, "AnvilHorn", Vector3(0.35, 0.16, 0.16), Vector3(0.55, 0.78, -0.15), metal)
	ArtDemoGreybox.box(props, "AnvilHeel", Vector3(0.22, 0.18, 0.28), Vector3(-0.45, 0.78, -0.15), metal)

	# Foreground bench edge (composition anchor under "hands").
	ArtDemoGreybox.box(props, "Bench", Vector3(1.6, 0.12, 0.55), Vector3(0.15, 0.95, 1.55), wood)
	ArtDemoGreybox.box(props, "Tongs", Vector3(0.55, 0.04, 0.06), Vector3(-0.25, 1.04, 1.45), metal)

	# Forge fire volume.
	ArtDemoGreybox.box(props, "CoalBed", Vector3(1.5, 0.2, 0.7), Vector3(0.0, 0.55, -2.65), coal)
	ArtDemoGreybox.box(props, "Embers", Vector3(1.1, 0.25, 0.45), Vector3(0.0, 0.72, -2.6), embers)
	_ember_core = ArtDemoGreybox.sphere(props, "EmberCore", 0.22, Vector3(0.0, 0.95, -2.55), ember_core)

	# Bellows (right of hearth).
	ArtDemoGreybox.box(props, "BellowsBase", Vector3(0.9, 0.35, 0.55), Vector3(1.85, 0.55, -2.35), wood)
	ArtDemoGreybox.box(props, "BellowsBag", Vector3(0.75, 0.45, 0.4), Vector3(1.85, 0.95, -2.35), ArtDemoPalette.mat(Color(0.28, 0.16, 0.1)))
	ArtDemoGreybox.cylinder(props, "BellowsNozzle", 0.07, 0.55, Vector3(1.25, 0.85, -2.55), metal, 0.0, PI * 0.5)

	# Coal / ore crate.
	ArtDemoGreybox.box(props, "OreCrate", Vector3(0.7, 0.45, 0.55), Vector3(1.9, 0.25, -1.55), wood_dark)
	ArtDemoGreybox.box(props, "OrePile", Vector3(0.55, 0.22, 0.4), Vector3(1.9, 0.55, -1.55), coal)
	ArtDemoGreybox.box(props, "IngotA", Vector3(0.28, 0.08, 0.12), Vector3(1.55, 0.12, -1.15), metal_warm)
	ArtDemoGreybox.box(props, "IngotB", Vector3(0.28, 0.08, 0.12), Vector3(1.75, 0.12, -1.05), metal)

	# Quench barrel (left).
	ArtDemoGreybox.cylinder(props, "Barrel", 0.38, 0.85, Vector3(-2.15, 0.45, -0.35), wood)
	ArtDemoGreybox.cylinder(props, "BarrelBand", 0.39, 0.06, Vector3(-2.15, 0.55, -0.35), metal)
	ArtDemoGreybox.cylinder(props, "BarrelWater", 0.32, 0.08, Vector3(-2.15, 0.82, -0.35), water)

	# Tool rack + hammers / tongs on left wall.
	ArtDemoGreybox.box(props, "ToolRack", Vector3(0.08, 1.1, 1.4), Vector3(-3.25, 1.7, -0.2), wood_dark)
	for i in 4:
		var z := -0.7 + float(i) * 0.35
		ArtDemoGreybox.box(props, "HammerHead_%d" % i, Vector3(0.18, 0.12, 0.1), Vector3(-3.05, 2.05, z), metal)
		ArtDemoGreybox.box(props, "HammerHandle_%d" % i, Vector3(0.05, 0.45, 0.05), Vector3(-3.05, 1.75, z), wood)
	ArtDemoGreybox.box(props, "WallTongs", Vector3(0.05, 0.55, 0.05), Vector3(-3.05, 1.35, 0.55), metal)

	# Hanging horseshoes.
	for i in 3:
		var y := 2.15 - float(i) * 0.28
		ArtDemoGreybox.cylinder(props, "Horseshoe_%d" % i, 0.12, 0.04, Vector3(-3.05, y, -1.15), metal, PI * 0.5, 0.0)

	# Pokers leaning by hearth.
	ArtDemoGreybox.box(props, "PokerA", Vector3(0.04, 1.1, 0.04), Vector3(0.75, 0.9, -2.15), metal, 0.25)
	ArtDemoGreybox.box(props, "PokerB", Vector3(0.04, 1.0, 0.04), Vector3(0.9, 0.85, -2.05), metal, 0.35)
