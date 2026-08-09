class_name DemoAssets
extends RefCounted
## Paths to free-store, non-AI, open-licensed packs under shared/imported/.

const PH := "res://art_style_demo/shared/imported/polyhaven_textures/"
const KN_BG := "res://art_style_demo/shared/imported/kenney_background_elements_remastered/PNG/"
const KN_SMOKE := "res://art_style_demo/shared/imported/kenney_smoke_particles/PNG/"

const WOOD := PH + "wood_cabinet_worn_long_diff_1k.jpg"
const WOOD_DARK := PH + "wood_table_001_diff_1k.jpg"
const BRICK := PH + "castle_brick_02_red_diff_1k.jpg"
const COBBLE := PH + "cobblestone_floor_01_diff_1k.jpg"
const PLASTER := PH + "plastered_wall_diff_1k.jpg"
const METAL := PH + "metal_plate_diff_1k.jpg"
const ROOF := PH + "roof_07_diff_1k.jpg"

const HOUSE_1 := KN_BG + "house1.png"
const HOUSE_2 := KN_BG + "house2.png"
const HOUSE_ALT_1 := KN_BG + "houseAlt1.png"
const HOUSE_ALT_2 := KN_BG + "houseAlt2.png"
const HOUSE_SMALL := KN_BG + "houseSmall2.png"
const TOWER := KN_BG + "tower.png"
const TOWER_ALT := KN_BG + "towerAlt.png"
const CASTLE_SMALL := KN_BG + "castleSmall.png"
const CASTLE_WALL := KN_BG + "castleWall.png"
const FENCE := KN_BG + "fence.png"
const MOON := KN_BG + "moonFull.png"
const SUN := KN_BG + "sun.png"
const CLOUD_1 := KN_BG + "cloud1.png"
const CLOUD_3 := KN_BG + "cloud3.png"
const TREE := KN_BG + "tree.png"

const PUFF := KN_SMOKE + "whitePuff10.png"
const FLASH := KN_SMOKE + "flash00.png"


static func tex(path: String) -> Texture2D:
	return load(path) as Texture2D
