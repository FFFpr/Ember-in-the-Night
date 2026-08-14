extends RefCounted
## Resolves Aseprite-User export paths for the Kelly room.
##
## A missing export is never silent: every miss is recorded, reported through
## push_error and listed on screen. Greybox still renders so work can continue
## while art tickets are in flight, but nobody can mistake an unpulled Git LFS
## checkout for a scene that is simply drawn badly.

const ISSUE := "res://Aseprite-User/export/Ember-in-the-Night/issue_32/"
const SHARED := "res://Aseprite-User/export/props/kelly_room/"

const COIN_FLAT := SHARED + "coin.png"
const COIN_EDGE := ISSUE + "coin_edge.png"
const COIN_MASS_FILL := ISSUE + "coin_mass_fill.png"
const COIN_MASS_CREST_A := ISSUE + "coin_mass_crest_a.png"
const COIN_MASS_CREST_B := ISSUE + "coin_mass_crest_b.png"
const WOOD_WALL := ISSUE + "wood_plank_wall.png"
const WOOD_FLOOR := ISSUE + "wood_plank_floor.png"
const IRON_APRON := ISSUE + "iron_apron.png"
const BEAM := ISSUE + "beam.png"
const POST := ISSUE + "post.png"
const SIDE_WINDOW := ISSUE + "side_window.png"
const OUTLET_CLOSED := ISSUE + "outlet_closed.png"
const OUTLET_OPEN := ISSUE + "outlet_open.png"
const WHITEBOARD := ISSUE + "whiteboard.png"
const COIN_BOX := ISSUE + "coin_box.png"
const LEVER := ISSUE + "lever.png"
const LEVER_DOWN := ISSUE + "lever_down.png"
const STICKER := ISSUE + "sticker.png"
const WALL_LANTERN := ISSUE + "wall_lantern.png"
const MARKER_DIGITS := ISSUE + "marker_digits.png"

## Everything the finished scene needs. Anything still missing is greybox.
const REQUIRED: PackedStringArray = [
	COIN_FLAT, COIN_EDGE, COIN_MASS_FILL, COIN_MASS_CREST_A, COIN_MASS_CREST_B,
	WOOD_WALL, WOOD_FLOOR, IRON_APRON, BEAM, POST, SIDE_WINDOW,
	OUTLET_CLOSED, OUTLET_OPEN, WHITEBOARD, COIN_BOX, LEVER, LEVER_DOWN,
	STICKER, WALL_LANTERN, MARKER_DIGITS,
]

static var _missing: Dictionary = {}
static var _lfs_pointers: Dictionary = {}


static func tex(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		var loaded := load(path) as Texture2D
		if loaded != null:
			return loaded
	if not FileAccess.file_exists(path):
		_missing[path] = true
		return null
	if _is_lfs_pointer(path):
		_lfs_pointers[path] = true
		return null
	var img := Image.load_from_file(path)
	if img == null or img.is_empty():
		_missing[path] = true
		return null
	return ImageTexture.create_from_image(img)


static func _is_lfs_pointer(path: String) -> bool:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return false
	var head := f.get_buffer(48).get_string_from_utf8()
	return head.begins_with("version https://git-lfs.github.com/spec")


## Checks every required export up front so one report covers the whole scene.
static func audit() -> PackedStringArray:
	_missing.clear()
	_lfs_pointers.clear()
	for path in REQUIRED:
		tex(path)
	var lines: PackedStringArray = []
	if not _lfs_pointers.is_empty():
		lines.append("Aseprite-User exports are unpulled Git LFS pointers — run `git -C Aseprite-User lfs pull`:")
		for path in _lfs_pointers:
			lines.append("  %s" % path)
	if not _missing.is_empty():
		lines.append("Aseprite-User exports missing — open art tickets or update the submodule:")
		for path in _missing:
			lines.append("  %s" % path)
	if not lines.is_empty():
		push_error("Kelly room art pipeline incomplete, falling back to greybox.\n%s"
				% "\n".join(lines))
	return lines
