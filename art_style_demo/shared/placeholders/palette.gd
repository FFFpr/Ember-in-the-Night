class_name ArtDemoPalette
extends RefCounted
## Shared look-dev colors for art_style_demo greybox scenes.

const STONE := Color(0.42, 0.43, 0.46)
const STONE_DARK := Color(0.28, 0.29, 0.32)
const WOOD := Color(0.38, 0.24, 0.14)
const WOOD_DARK := Color(0.22, 0.14, 0.08)
const METAL := Color(0.18, 0.19, 0.22)
const METAL_WARM := Color(0.32, 0.28, 0.26)
const PLASTER := Color(0.72, 0.66, 0.56)
const COOL_WALL := Color(0.34, 0.40, 0.48)
const EMBERS := Color(1.0, 0.42, 0.12)
const EMBERS_CORE := Color(1.0, 0.72, 0.28)
const COAL := Color(0.12, 0.11, 0.12)
const WATER := Color(0.22, 0.32, 0.38)
const ROAD := Color(0.40, 0.39, 0.37)
const ROOF := Color(0.22, 0.28, 0.38)
const NIGHT_SKY := Color(0.05, 0.07, 0.12)
const DAY_SKY := Color(0.55, 0.62, 0.72)


static func mat(color: Color, emission: Color = Color.BLACK, emission_energy: float = 0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = 0.85
	m.metallic = 0.0
	if emission_energy > 0.0:
		m.emission_enabled = true
		m.emission = emission
		m.emission_energy_multiplier = emission_energy
	return m


static func metal_mat(color: Color = METAL) -> StandardMaterial3D:
	var m := mat(color)
	m.metallic = 0.75
	m.roughness = 0.45
	return m
