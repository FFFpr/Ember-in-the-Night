extends RefCounted
## Reads the approved fit list and the picture-layer gates from the docs, so the
## scene and its acceptance check share one source of truth with the criterion.

const FIT_LIST := "res://art_style_demo/references/kelly_room/fit_list.md"
const ART_STYLE := "res://docs/tech/art-style.md"

## Fit-list row label -> id used by the scene and the acceptance check.
const LABELS := {
	"玻璃开口": "glass",
	"白板": "whiteboard",
	"金币海": "coin_mass",
	"公式第一行": "formula_l1",
	"公式第二行": "formula_l2",
	"等号": "equals",
	"贴纸": "sticker",
	"出币口": "outlet",
	"投币箱": "coin_box",
	"箱面读数": "box_marker",
	"摇杆": "lever",
	"壁灯": "lantern",
	"右墙小窗": "side_window",
}

var items: Dictionary = {}
var tolerance: float = 0.03
var luma_mean_min: float = 30.0
var luma_mean_max: float = 50.0
var edge_p90_max: float = 0.40
var errors: PackedStringArray = []


func _init() -> void:
	_parse_fit_list()
	_parse_gates()


func ok() -> bool:
	return errors.is_empty()


func _read(path: String) -> String:
	if not FileAccess.file_exists(path):
		errors.append("missing doc: %s" % path)
		return ""
	return FileAccess.get_file_as_string(path)


func _parse_fit_list() -> void:
	var text := _read(FIT_LIST)
	if text.is_empty():
		return
	var tol := RegEx.create_from_string("容差为\\s*±\\s*([0-9.]+)")
	var tol_m := tol.search(text)
	if tol_m != null:
		tolerance = float(tol_m.get_string(1))
	for raw in text.split("\n"):
		var line := raw.strip_edges()
		if not line.begins_with("|"):
			continue
		var cells: PackedStringArray = []
		for cell in line.split("|"):
			cells.append(cell.strip_edges())
		# Leading and trailing empties come from the outer pipes.
		if cells.size() < 6 or not cells[1].is_valid_int():
			continue
		var id := _label_id(cells[2])
		if id.is_empty():
			errors.append("unmapped fit-list row: %s" % cells[2])
			continue
		items[id] = {
			"label": cells[2],
			"centre": _parse_centre(cells[3]),
			"size": _parse_size(cells[4]),
			"text_height": _parse_text_height(cells[4]),
			"whole": cells[5].contains("是") or cells[5].contains("四边"),
		}
	for id in LABELS.values():
		if not items.has(id):
			errors.append("fit list has no row for %s" % id)


func _label_id(label: String) -> String:
	for key in LABELS:
		if label.begins_with(key):
			return LABELS[key]
	return ""


func _parse_centre(cell: String) -> Vector2:
	var m := RegEx.create_from_string("([0-9.]+)\\s*,\\s*([0-9.]+)").search(cell)
	if m == null:
		return Vector2(-1, -1)
	return Vector2(float(m.get_string(1)), float(m.get_string(2)))


func _parse_size(cell: String) -> Vector2:
	var m := RegEx.create_from_string("([0-9.]+)\\s*×\\s*([0-9.]+)").search(cell)
	if m == null:
		return Vector2(-1, -1)
	return Vector2(float(m.get_string(1)), float(m.get_string(2)))


func _parse_text_height(cell: String) -> float:
	var m := RegEx.create_from_string("字高\\s*([0-9.]+)").search(cell)
	return float(m.get_string(1)) if m != null else -1.0


func _parse_gates() -> void:
	var text := _read(ART_STYLE)
	if text.is_empty():
		return
	var edge := RegEx.create_from_string("P90\\s*×\\s*\\*\\*([0-9.]+)\\*\\*").search(text)
	if edge != null:
		edge_p90_max = float(edge.get_string(1))
	else:
		errors.append("art-style.md: no edge/P90 gate found")
	var mean := RegEx.create_from_string("落在\\s*\\*\\*([0-9]+)[–-]([0-9]+)\\*\\*").search(text)
	if mean != null:
		luma_mean_min = float(mean.get_string(1))
		luma_mean_max = float(mean.get_string(2))
	else:
		errors.append("art-style.md: no frame-mean gate found")


## Centre of an item in viewport pixels.
func centre_px(id: String, viewport: Vector2) -> Vector2:
	return Vector2(items[id]["centre"]) * viewport


## Item size in viewport pixels.
func size_px(id: String, viewport: Vector2) -> Vector2:
	return Vector2(items[id]["size"]) * viewport
