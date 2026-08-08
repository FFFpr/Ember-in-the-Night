class_name PlateUtil
extends RefCounted
## Helpers for solid-color look-dev plates (Polygon2D only).


static func poly(parent: Node, name: String, points: PackedVector2Array, color: Color, z: int = 0) -> Polygon2D:
	var node := Polygon2D.new()
	node.name = name
	node.polygon = points
	node.color = color
	node.z_index = z
	parent.add_child(node)
	return node


static func rect(parent: Node, name: String, pos: Vector2, size: Vector2, color: Color, z: int = 0) -> Polygon2D:
	return poly(
		parent,
		name,
		PackedVector2Array([
			pos,
			pos + Vector2(size.x, 0.0),
			pos + size,
			pos + Vector2(0.0, size.y),
		]),
		color,
		z,
	)


static func ellipse(parent: Node, name: String, center: Vector2, radii: Vector2, color: Color, z: int = 0, segments: int = 16) -> Polygon2D:
	var pts := PackedVector2Array()
	for i in segments:
		var t := TAU * float(i) / float(segments)
		pts.append(center + Vector2(cos(t) * radii.x, sin(t) * radii.y))
	return poly(parent, name, pts, color, z)
