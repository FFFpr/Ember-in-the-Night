class_name IsoDraw
extends RefCounted
## Diamond-grid helpers for isometric look-dev placeholders.

const TILE_W := 72.0
const TILE_H := 36.0


static func grid_to_screen(gx: float, gy: float) -> Vector2:
	return Vector2((gx - gy) * TILE_W * 0.5, (gx + gy) * TILE_H * 0.5)


static func diamond_points(half_w: float = TILE_W * 0.5, half_h: float = TILE_H * 0.5) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(0.0, -half_h),
		Vector2(half_w, 0.0),
		Vector2(0.0, half_h),
		Vector2(-half_w, 0.0),
	])


static func make_diamond(
	parent: Node,
	pos: Vector2,
	color: Color,
	z_index: int = 0,
	half_w: float = TILE_W * 0.5,
	half_h: float = TILE_H * 0.5,
) -> Polygon2D:
	var poly := Polygon2D.new()
	poly.polygon = diamond_points(half_w, half_h)
	poly.color = color
	poly.position = pos
	poly.z_index = z_index
	parent.add_child(poly)
	return poly


static func make_box(
	parent: Node,
	grid: Vector2,
	height_px: float,
	top_color: Color,
	side_color: Color,
	z_base: int = 0,
	half_w: float = TILE_W * 0.42,
	half_h: float = TILE_H * 0.42,
) -> Node2D:
	var root := Node2D.new()
	root.position = grid_to_screen(grid.x, grid.y)
	root.z_index = z_base + int(grid.x + grid.y)
	parent.add_child(root)

	var left := Polygon2D.new()
	left.polygon = PackedVector2Array([
		Vector2(-half_w, 0.0),
		Vector2(0.0, half_h),
		Vector2(0.0, half_h - height_px),
		Vector2(-half_w, -height_px),
	])
	left.color = side_color.darkened(0.12)
	root.add_child(left)

	var right := Polygon2D.new()
	right.polygon = PackedVector2Array([
		Vector2(half_w, 0.0),
		Vector2(0.0, half_h),
		Vector2(0.0, half_h - height_px),
		Vector2(half_w, -height_px),
	])
	right.color = side_color
	root.add_child(right)

	var top := Polygon2D.new()
	top.polygon = diamond_points(half_w, half_h)
	top.position = Vector2(0.0, -height_px)
	top.color = top_color
	root.add_child(top)
	return root


static func make_label(parent: Node, text: String, pos: Vector2, z_index: int = 40) -> Label:
	var label := Label.new()
	label.text = text
	label.position = pos + Vector2(-28.0, -12.0)
	label.z_index = z_index
	label.add_theme_font_size_override("font_size", 11)
	label.add_theme_color_override("font_color", Color(0.92, 0.88, 0.78, 0.85))
	label.add_theme_color_override("font_outline_color", Color(0.05, 0.06, 0.08, 0.9))
	label.add_theme_constant_override("outline_size", 3)
	parent.add_child(label)
	return label
