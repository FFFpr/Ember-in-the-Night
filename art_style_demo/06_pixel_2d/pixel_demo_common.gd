extends RefCounted
## Shared helpers for 06_pixel_2d look-dev scenes (nearest + integer scale).

const INTERNAL_SIZE := Vector2i(320, 180)
const PIXEL_SCALE := 4

const PATH_BS_PROPS := "res://art_style_demo/shared/imported/lpc_blacksmith/props/"
const PATH_SLICES := "res://art_style_demo/shared/imported/lpc_base_assets/slices/"


static func apply_pixel_filter(root: CanvasItem) -> void:
	root.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST


static func make_locked_camera(parent: Node) -> Camera2D:
	var cam := Camera2D.new()
	cam.name = "Camera2D"
	cam.position = Vector2(INTERNAL_SIZE) * 0.5
	cam.zoom = Vector2(PIXEL_SCALE, PIXEL_SCALE)
	cam.enabled = true
	cam.position_smoothing_enabled = false
	parent.add_child(cam)
	return cam


static func load_tex(path: String) -> Texture2D:
	var tex := load(path) as Texture2D
	if tex == null:
		push_warning("Missing texture: %s" % path)
	return tex


static func sprite(
	parent: Node,
	path: String,
	pos: Vector2,
	z: int = 0,
	centered: bool = true,
	scale_i: int = 1
) -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = load_tex(path)
	s.position = pos
	s.centered = centered
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	s.z_index = z
	var si := maxi(scale_i, 1)
	s.scale = Vector2(si, si)
	parent.add_child(s)
	return s


static func tiled_rect(
	parent: Node,
	path: String,
	origin: Vector2,
	size: Vector2i,
	z: int = 0,
	modulate: Color = Color.WHITE
) -> void:
	var tex := load_tex(path)
	if tex == null:
		return
	var tw := maxi(tex.get_width(), 1)
	var th := maxi(tex.get_height(), 1)
	var x := 0
	while x < size.x:
		var y := 0
		while y < size.y:
			var s := Sprite2D.new()
			s.texture = tex
			s.centered = false
			s.position = origin + Vector2(x, y)
			s.modulate = modulate
			s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			s.z_index = z
			var remain := Vector2(size.x - x, size.y - y)
			if remain.x < tw or remain.y < th:
				s.region_enabled = true
				s.region_rect = Rect2(0, 0, minf(tw, remain.x), minf(th, remain.y))
			parent.add_child(s)
			y += th
		x += tw


static func solid(parent: Node, rect: Rect2, color: Color, z: int = 0) -> Polygon2D:
	var poly := Polygon2D.new()
	poly.color = color
	poly.z_index = z
	poly.polygon = PackedVector2Array([
		rect.position,
		rect.position + Vector2(rect.size.x, 0),
		rect.position + rect.size,
		rect.position + Vector2(0, rect.size.y),
	])
	parent.add_child(poly)
	return poly
