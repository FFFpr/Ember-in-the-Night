extends SceneTree
## Headless render of the generated Kelly scene to a PNG for sample comparison.
##   godot --path . --script res://art_style_demo/07_kelly_room/gen_scene/render.gd

const SCENE := "res://art_style_demo/07_kelly_room/gen_scene/kelly_scene.tscn"
const SIZE := Vector2i(1152, 648)

var _frames := 0
var _scene: Node = null
var _warmup := 30


func _initialize() -> void:
	root.size = SIZE
	DisplayServer.window_set_size(SIZE)
	_scene = load(SCENE).instantiate()
	root.add_child(_scene)


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames < _warmup:
		return false
	var img: Image = root.get_texture().get_image()
	var out: String = OS.get_environment("SHOT_OUT")
	if out.is_empty():
		out = "user://kelly_gen_scene.png"
	if img != null:
		img.save_png(out)
		print("saved: %s" % out)
	quit(0)
	return true
