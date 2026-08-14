extends Node3D
## Visual stand-in for one coin. Uses Aseprite export when present.

const PLAYER_MAT := Color8(232, 214, 176)
const MARKET_MAT := Color8(176, 118, 62)
const DARK := Color8(92, 90, 102)

var is_player: bool = true
var velocity: Vector3 = Vector3.ZERO
var falling: bool = false


func configure(player: bool, tex: Texture2D) -> void:
	is_player = player
	if tex != null:
		var sprite := Sprite3D.new()
		sprite.texture = tex
		sprite.pixel_size = 0.011 if player else 0.010
		sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
		sprite.shaded = true
		sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
		sprite.alpha_scissor_threshold = 0.5
		sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		sprite.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		sprite.centered = true
		sprite.position.y = 0.09 if player else 0.07
		if not player:
			sprite.modulate = Color(0.95, 0.86, 0.52)
		add_child(sprite)
	else:
		var mesh := MeshInstance3D.new()
		var cyl := CylinderMesh.new()
		cyl.top_radius = 0.055 if player else 0.05
		cyl.bottom_radius = cyl.top_radius
		cyl.height = 0.018
		cyl.radial_segments = 10
		mesh.mesh = cyl
		var mat := StandardMaterial3D.new()
		mat.albedo_color = PLAYER_MAT if player else MARKET_MAT
		mat.metallic = 0.7
		mat.roughness = 0.35
		mesh.material_override = mat
		mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		mesh.rotation_degrees.x = 90.0
		mesh.position.y = 0.01
		add_child(mesh)
	var blob := MeshInstance3D.new()
	var quad := PlaneMesh.new()
	quad.size = Vector2(0.14, 0.14)
	blob.mesh = quad
	var bmat := StandardMaterial3D.new()
	bmat.albedo_color = Color(0, 0, 0, 0.28)
	bmat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	bmat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	blob.material_override = bmat
	blob.position.y = 0.002
	blob.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(blob)
