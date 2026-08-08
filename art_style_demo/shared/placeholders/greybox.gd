class_name ArtDemoGreybox
extends RefCounted
## Helpers for building MeshInstance3D greybox props.


static func box(
	parent: Node3D,
	box_name: String,
	size: Vector3,
	pos: Vector3,
	material: Material,
	rot_y: float = 0.0
) -> MeshInstance3D:
	var mesh := BoxMesh.new()
	mesh.size = size
	return _add_mesh(parent, box_name, mesh, pos, material, rot_y)


static func cylinder(
	parent: Node3D,
	cyl_name: String,
	radius: float,
	height: float,
	pos: Vector3,
	material: Material,
	rot_x: float = 0.0,
	rot_y: float = 0.0
) -> MeshInstance3D:
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = 12
	var mi := _add_mesh(parent, cyl_name, mesh, pos, material, rot_y)
	if rot_x != 0.0:
		mi.rotation.x = rot_x
	return mi


static func sphere(
	parent: Node3D,
	sphere_name: String,
	radius: float,
	pos: Vector3,
	material: Material
) -> MeshInstance3D:
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh.radial_segments = 12
	mesh.rings = 8
	return _add_mesh(parent, sphere_name, mesh, pos, material)


static func _add_mesh(
	parent: Node3D,
	node_name: String,
	mesh: Mesh,
	pos: Vector3,
	material: Material,
	rot_y: float = 0.0
) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.name = node_name
	mi.mesh = mesh
	mi.position = pos
	mi.rotation.y = rot_y
	mi.material_override = material
	parent.add_child(mi)
	return mi
