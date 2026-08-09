class_name PlateUtil
extends RefCounted
## Helpers for look-dev plates (textured polygons + sprites).


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


static func textured_poly(
	parent: Node,
	name: String,
	points: PackedVector2Array,
	texture: Texture2D,
	z: int = 0,
	modulate: Color = Color.WHITE,
	uv_scale: float = 0.004,
) -> Polygon2D:
	var node := Polygon2D.new()
	node.name = name
	node.polygon = points
	node.texture = texture
	node.color = modulate
	node.z_index = z
	var uvs := PackedVector2Array()
	for p in points:
		uvs.append(p * uv_scale)
	node.uv = uvs
	parent.add_child(node)
	return node


static func textured_rect(
	parent: Node,
	name: String,
	pos: Vector2,
	size: Vector2,
	texture: Texture2D,
	z: int = 0,
	modulate: Color = Color.WHITE,
	uv_scale: float = 0.004,
) -> Polygon2D:
	return textured_poly(
		parent,
		name,
		PackedVector2Array([
			pos,
			pos + Vector2(size.x, 0.0),
			pos + size,
			pos + Vector2(0.0, size.y),
		]),
		texture,
		z,
		modulate,
		uv_scale,
	)


static func sprite(
	parent: Node,
	name: String,
	texture: Texture2D,
	pos: Vector2,
	scale: Vector2 = Vector2.ONE,
	z: int = 0,
	modulate: Color = Color.WHITE,
	centered: bool = true,
) -> Sprite2D:
	var node := Sprite2D.new()
	node.name = name
	node.texture = texture
	node.position = pos
	node.scale = scale
	node.z_index = z
	node.modulate = modulate
	node.centered = centered
	parent.add_child(node)
	return node
