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


static func tex(path: String) -> Texture2D:
	if not ResourceLoader.exists(path):
		return null
	return load(path) as Texture2D
