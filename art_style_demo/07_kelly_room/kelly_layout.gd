extends RefCounted
## Turns fit-list screen anchors into world transforms for the locked camera.
##
## The room is a fixed-camera diorama, so the fit list is the authoring space:
## every element states where it must appear on screen, and this resolves that to
## a world position at a chosen depth. Nothing is placed by eye.

const Fit := preload("res://art_style_demo/07_kelly_room/kelly_fit.gd")

const FOV := 50.0
## Interior half width; the side walls stay just inside the frame edges so the
## lantern and the side window have wall to sit on.
const ROOM_HALF_W := 2.1
const WALL_Z := -3.2
const CEIL_Y := 2.55
const FLOOR_Y := 0.0
## Where the far wall meets the floor. Read off the approved sample; it is what
## fixes eye height once the glass size is fixed.
const FLOOR_LINE_V := 0.795

var fit: Fit
var viewport: Vector2
var camera: Camera3D
var _k: float  ## metres per pixel, per metre of depth


func _init(fit_data: Fit, viewport_size: Vector2) -> void:
	fit = fit_data
	viewport = viewport_size
	_k = 2.0 * tan(deg_to_rad(FOV) * 0.5) / viewport.y


## Metres per screen pixel at `depth` metres in front of the camera.
func mpp(depth: float) -> float:
	return _k * depth


func wall_depth() -> float:
	return -WALL_Z


func build_camera(host: Node3D) -> Camera3D:
	var glass: Dictionary = fit.items["glass"]
	var centre: Vector2 = glass["centre"]
	var depth := wall_depth()
	# Level gaze down -Z: every wall-parallel plane stays parallel to the image
	# plane, so screen anchors resolve exactly instead of being keystoned.
	var cam_x: float = -(centre.x - 0.5) * viewport.x * mpp(depth)
	var cam_y: float = (FLOOR_LINE_V - 0.5) * viewport.y * mpp(depth)
	camera = Camera3D.new()
	camera.name = "Camera"
	camera.fov = FOV
	camera.position = Vector3(cam_x, cam_y, 0.0)
	camera.current = true
	host.add_child(camera)
	return camera


## World point that projects to `uv` at `depth` metres in front of the camera.
func world_at(uv: Vector2, depth: float) -> Vector3:
	var m := mpp(depth)
	return Vector3(
			camera.position.x + (uv.x - 0.5) * viewport.x * m,
			camera.position.y - (uv.y - 0.5) * viewport.y * m,
			camera.position.z - depth)


## World width and height that cover `size` of the frame at `depth`.
func size_at(size: Vector2, depth: float) -> Vector2:
	var m := mpp(depth)
	return Vector2(size.x * viewport.x * m, size.y * viewport.y * m)


## Depth at which an item of the fit list's screen size stands on the floor.
func depth_on_floor(id: String) -> float:
	var item: Dictionary = fit.items[id]
	var centre: Vector2 = item["centre"]
	var size: Vector2 = item["size"]
	var per_metre: float = _k * viewport.y * ((centre.y - 0.5) + 0.5 * size.y)
	if per_metre <= 0.0:
		return wall_depth()
	return (camera.position.y - FLOOR_Y) / per_metre


## Depth at which a side wall at `wall_x` shows up at horizontal anchor `u`.
func depth_on_side_wall(u: float, wall_x: float) -> float:
	var per_metre: float = (u - 0.5) * viewport.x * _k
	if is_zero_approx(per_metre):
		return wall_depth()
	return (wall_x - camera.position.x) / per_metre


## Centre and world size of a fit item placed at `depth`.
func place(id: String, depth: float) -> Dictionary:
	var item: Dictionary = fit.items[id]
	return {
		"origin": world_at(item["centre"], depth),
		"size": size_at(item["size"], depth),
		"depth": depth,
	}


## Same, but resting on the floor: depth is solved so the bottom edge is y = 0.
func place_on_floor(id: String) -> Dictionary:
	return place(id, depth_on_floor(id))


## Stretch a Sprite3D so its world AABB matches `world_size`.
## Fit-list screen size is the arbiter; canvas aspect is not.
func fit_sprite_to(sprite: Sprite3D, world_size: Vector2) -> void:
	var tex: Texture2D = sprite.texture
	if tex == null or tex.get_height() <= 0:
		return
	sprite.pixel_size = world_size.y / float(tex.get_height())
	var natural_w: float = float(tex.get_width()) * sprite.pixel_size
	if natural_w > 0.0:
		sprite.scale = Vector3(world_size.x / natural_w, 1.0, 1.0)


## World height of `v` frame heights at `depth`.
func height_at(v: float, depth: float) -> float:
	return v * viewport.y * mpp(depth)


## Screen-space bounding rect of every visible VisualInstance3D under `node`.
## Shared by the mouse hit tests and the acceptance check so both see one shape.
func screen_rect(node: Node3D) -> Rect2:
	var lo := Vector2(INF, INF)
	var hi := Vector2(-INF, -INF)
	for vi in visuals(node):
		if not vi.is_visible_in_tree():
			continue
		var aabb: AABB = (vi as VisualInstance3D).get_aabb()
		if aabb.size == Vector3.ZERO:
			continue
		for i in 8:
			var corner: Vector3 = vi.global_transform * aabb.get_endpoint(i)
			if camera.is_position_behind(corner):
				continue
			var sp: Vector2 = camera.unproject_position(corner)
			lo = Vector2(minf(lo.x, sp.x), minf(lo.y, sp.y))
			hi = Vector2(maxf(hi.x, sp.x), maxf(hi.y, sp.y))
	if lo.x > hi.x:
		return Rect2()
	return Rect2(lo, hi - lo)


## Only drawn geometry counts. Light3D is a VisualInstance3D too and its AABB is
## the light radius, which would swamp the silhouette of anything it is parented to.
static func visuals(node: Node) -> Array[GeometryInstance3D]:
	var out: Array[GeometryInstance3D] = []
	if node is GeometryInstance3D:
		out.append(node)
	for child in node.get_children():
		out.append_array(visuals(child))
	return out
