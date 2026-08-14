extends RefCounted
## Resolves Aseprite-User export paths for the Kelly room. Missing files are OK.

const ROOT := "res://Aseprite-User/export/props/kelly_room/"

const COIN := ROOT + "coin.png"
const COIN_BOX := ROOT + "coin_box.png"
const LEVER := ROOT + "lever.png"
const LEVER_DOWN := ROOT + "lever_down.png"
const OUTLET_CLOSED := ROOT + "outlet_closed.png"
const OUTLET_OPEN := ROOT + "outlet_open.png"
const STICKER := ROOT + "sticker.png"
const STICKER_OFF := ROOT + "sticker_off.png"
const WHITEBOARD := ROOT + "whiteboard.png"

const ISSUE_29 := "res://Aseprite-User/export/Ember-in-the-Night/issue_29/"
const WOOD_FLOOR := ISSUE_29 + "wood_plank_floor.png"
const WOOD_WALL := ISSUE_29 + "wood_plank_wall.png"
const MARKER_DIGITS := ISSUE_29 + "marker_digits.png"
const WALL_LANTERN := ISSUE_29 + "wall_lantern.png"

const REQUIRED_PATHS: PackedStringArray = [
	COIN,
	COIN_BOX,
	LEVER,
	LEVER_DOWN,
	OUTLET_CLOSED,
	OUTLET_OPEN,
	STICKER,
	WHITEBOARD,
]


static func tex(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		return load(path) as Texture2D
	if not FileAccess.file_exists(path):
		return null
	var img := Image.load_from_file(path)
	if img == null or img.is_empty():
		return null
	return ImageTexture.create_from_image(img)
