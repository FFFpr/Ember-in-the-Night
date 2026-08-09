class_name ArtDemoPackLoader
extends RefCounted
## Loads imported look-dev meshes (PackedScene or Mesh) as nodes.


static func add_asset(
	parent: Node3D,
	node_name: String,
	path: String,
	pos: Vector3 = Vector3.ZERO,
	rot_y: float = 0.0,
	scale := Vector3.ONE,
	albedo_tex: Texture2D = null
) -> Node3D:
	var res = load(path)
	if res == null:
		push_error("ArtDemoPackLoader: failed to load %s" % path)
		return null

	if res is PackedScene:
		var inst: Node3D = (res as PackedScene).instantiate() as Node3D
		if inst == null:
			push_error("ArtDemoPackLoader: root is not Node3D for %s" % path)
			return null
		inst.name = node_name
		inst.position = pos
		inst.rotation.y = rot_y
		inst.scale = scale
		parent.add_child(inst)
		return inst

	if res is Mesh:
		var mi := MeshInstance3D.new()
		mi.name = node_name
		mi.mesh = res
		mi.position = pos
		mi.rotation.y = rot_y
		mi.scale = scale
		if albedo_tex != null:
			var mat := StandardMaterial3D.new()
			mat.albedo_texture = albedo_tex
			mat.roughness = 0.75
			mi.material_override = mat
		parent.add_child(mi)
		return mi

	push_error("ArtDemoPackLoader: unsupported resource type for %s" % path)
	return null


# Compatibility aliases.
static func add_scene(
	parent: Node3D,
	node_name: String,
	path: String,
	pos: Vector3 = Vector3.ZERO,
	rot_y: float = 0.0,
	scale := Vector3.ONE
) -> Node3D:
	return add_asset(parent, node_name, path, pos, rot_y, scale)


static func add_mesh(
	parent: Node3D,
	node_name: String,
	path: String,
	pos: Vector3 = Vector3.ZERO,
	rot_y: float = 0.0,
	scale := Vector3.ONE
) -> MeshInstance3D:
	var n := add_asset(parent, node_name, path, pos, rot_y, scale)
	if n is MeshInstance3D:
		return n as MeshInstance3D
	return null
