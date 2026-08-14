extends SceneTree
## Acceptance check for the Kelly room: renders at the baseline framing and reports
## every fit-list item as PASS / FAIL with measured numbers.
##
##   godot --headless --path . --script res://art_style_demo/07_kelly_room/tools/acceptance.gd
##
## Headless has no renderer, so run it on a display (or Xvfb) when a screenshot and
## the contrast gates are wanted; positions are checked either way.
## Env: SHOT_OUT overrides the screenshot path, WARMUP_FRAMES the settle time.

const Fit := preload("res://art_style_demo/07_kelly_room/kelly_fit.gd")
const SCENE := "res://art_style_demo/07_kelly_room/kelly_room.tscn"
const BASELINE := Vector2i(1152, 648)

var _frames := 0
var _scene: Node = null
var _fit: Fit = null
var _warmup := 40


func _initialize() -> void:
	_warmup = maxi(int(OS.get_environment("WARMUP_FRAMES")), 40)
	root.size = BASELINE
	DisplayServer.window_set_size(BASELINE)
	_fit = Fit.new()
	if not _fit.ok():
		for e in _fit.errors:
			printerr("fit list: %s" % e)
		quit(2)
		return
	_scene = load(SCENE).instantiate()
	root.add_child(_scene)


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames < _warmup:
		return false
	var failures := _report()
	quit(1 if failures > 0 else 0)
	return true


func _report() -> int:
	var viewport := Vector2(root.size)
	var img: Image = root.get_texture().get_image()
	var shot: String = OS.get_environment("SHOT_OUT")
	if shot.is_empty():
		shot = "user://kelly_acceptance.png"
	if img != null:
		img.save_png(shot)
	print("Kelly room acceptance — viewport %dx%d" % [root.size.x, root.size.y])
	print("screenshot: %s" % shot)
	print("")
	print("%-14s %-17s %-17s %-15s %-15s %s" % [
			"item", "centre want", "centre got", "size want", "size got", "verdict"])
	var failures := 0
	for id in _fit.items:
		var item: Dictionary = _fit.items[id]
		var node: Node3D = _scene.call("fit_node", id)
		if node == null:
			print("%-14s %-17s %-17s %-15s %-15s FAIL  no node" % [
					id, _v(item["centre"]), "-", _v(item["size"]), "-"])
			failures += 1
			continue
		var rect: Rect2 = _scene.call("screen_rect", node)
		if rect.size == Vector2.ZERO:
			print("%-14s %-17s %-17s %-15s %-15s FAIL  nothing visible" % [
					id, _v(item["centre"]), "-", _v(item["size"]), "-"])
			failures += 1
			continue
		var got_centre: Vector2 = (rect.position + rect.size * 0.5) / viewport
		var got_size: Vector2 = rect.size / viewport
		var notes: PackedStringArray = []
		var want_centre: Vector2 = item["centre"]
		if want_centre.x >= 0.0 and not _near(got_centre, want_centre):
			notes.append("centre off by %.3f" % (got_centre - want_centre).length())
		var want_size: Vector2 = item["size"]
		if want_size.x >= 0.0 and not _near(got_size, want_size):
			notes.append("size off by (%+.3f, %+.3f)" % [
					got_size.x - want_size.x, got_size.y - want_size.y])
		if bool(item["whole"]) and not Rect2(Vector2.ZERO, viewport).encloses(rect):
			notes.append("cropped by the frame")
		if notes.is_empty():
			print("%-14s %-17s %-17s %-15s %-15s PASS" % [
					id, _v(want_centre), _v(got_centre), _v(want_size), _v(got_size)])
		else:
			failures += 1
			print("%-14s %-17s %-17s %-15s %-15s FAIL  %s" % [
					id, _v(want_centre), _v(got_centre), _v(want_size), _v(got_size),
					", ".join(notes)])
	failures += _report_light(img)
	print("")
	print("%d item(s) failed, tolerance ±%.3f" % [failures, _fit.tolerance])
	return failures


func _report_light(img: Image) -> int:
	if img == null:
		print("\nlight: no frame captured, gates skipped")
		return 1
	var w := img.get_width()
	var h := img.get_height()
	var ew := maxi(int(float(w) * 0.1), 1)
	var eh := maxi(int(float(h) * 0.1), 1)
	var all: PackedFloat32Array = []
	var edge_sum := 0.0
	var edge_n := 0
	var total := 0.0
	for y in h:
		for x in w:
			var l: float = img.get_pixel(x, y).get_luminance() * 255.0
			all.append(l)
			total += l
			if x < ew or x >= w - ew or y < eh or y >= h - eh:
				edge_sum += l
				edge_n += 1
	all.sort()
	var mean: float = total / float(w * h)
	var edge: float = edge_sum / float(maxi(edge_n, 1))
	var p90: float = all[mini(int(float(all.size()) * 0.9), all.size() - 1)]
	var ratio: float = edge / maxf(p90, 1.0)
	var mean_ok: bool = mean >= _fit.luma_mean_min and mean <= _fit.luma_mean_max
	var ratio_ok: bool = ratio <= _fit.edge_p90_max
	print("")
	print("light  frame mean %.1f (want %.0f-%.0f) %s" % [
			mean, _fit.luma_mean_min, _fit.luma_mean_max, "PASS" if mean_ok else "FAIL"])
	print("light  edge %.1f / P90 %.1f = %.2f (want <= %.2f) %s" % [
			edge, p90, ratio, _fit.edge_p90_max, "PASS" if ratio_ok else "FAIL"])
	return (0 if mean_ok else 1) + (0 if ratio_ok else 1)


func _near(got: Vector2, want: Vector2) -> bool:
	return absf(got.x - want.x) <= _fit.tolerance and absf(got.y - want.y) <= _fit.tolerance


func _v(v: Vector2) -> String:
	if v.x < 0.0:
		return "-"
	return "%.3f, %.3f" % [v.x, v.y]
