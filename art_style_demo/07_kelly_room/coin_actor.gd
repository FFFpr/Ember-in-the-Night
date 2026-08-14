extends Node3D
## One coin the player owns: on the floor, in the cursor's cluster, or in flight.
## Diameter comes from the fit list, so it cannot drift from the sample's scale.

const GOLD_M := Color8(214, 152, 44)
const GOLD_L := Color8(255, 214, 120)
const OUTLINE := Color8(28, 22, 26)

var diameter: float = 0.1


func configure(tex: Texture2D, coin_diameter: float) -> void:
	diameter = coin_diameter
	if tex != null:
		var sprite := Sprite3D.new()
		sprite.name = "CoinSprite"
		sprite.texture = tex
		sprite.pixel_size = diameter / float(tex.get_width())
		sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
		sprite.shaded = true
		sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
		sprite.alpha_scissor_threshold = 0.5
		sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		sprite.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		sprite.centered = true
		sprite.position.y = diameter * 0.5
		add_child(sprite)
	else:
		var mesh := MeshInstance3D.new()
		mesh.name = "CoinGreybox"
		var cyl := CylinderMesh.new()
		cyl.top_radius = diameter * 0.5
		cyl.bottom_radius = cyl.top_radius
		cyl.height = diameter * 0.22
		cyl.radial_segments = 12
		mesh.mesh = cyl
		var mat := StandardMaterial3D.new()
		mat.albedo_color = GOLD_M
		mat.metallic = 0.7
		mat.roughness = 0.32
		mesh.material_override = mat
		mesh.position.y = diameter * 0.11
		mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		add_child(mesh)
	var blob := MeshInstance3D.new()
	blob.name = "CoinShadowBlob"
	var quad := PlaneMesh.new()
	quad.size = Vector2(diameter * 1.15, diameter * 1.15)
	blob.mesh = quad
	var bmat := StandardMaterial3D.new()
	bmat.albedo_color = Color(0, 0, 0, 0.3)
	bmat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	bmat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	blob.material_override = bmat
	blob.position.y = 0.004
	blob.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(blob)
