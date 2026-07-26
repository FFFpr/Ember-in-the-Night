# res://entities/hammer/hammer.gd
class_name Hammer
extends BaseEntity

@onready var head: HammerPart = $Head
@onready var head_shape: CollisionShape2D = $HeadShape
@onready var handle: HammerPart = $Handle
@onready var handle_shape: CollisionShape2D = $HandleShape

const HEAD_OFFSET := Vector2(0, -90)       # -45 × 2
const HANDLE_OFFSET := Vector2(0, -40)     # -20 × 2

const HEAD_SIZE := Vector2(60, 36) 
const HANDLE_SIZE := Vector2(14, 80)       # 7×2, 40×2

func _ready() -> void:
	super._ready()

	head.position = HEAD_OFFSET
	head_shape.position = HEAD_OFFSET
	var head_rect := RectangleShape2D.new()
	head_rect.size = HEAD_SIZE
	head_shape.shape = head_rect          # 强制覆盖，不再判断 null

	handle.position = HANDLE_OFFSET
	handle_shape.position = HANDLE_OFFSET
	var handle_rect := RectangleShape2D.new()
	handle_rect.size = HANDLE_SIZE
	handle_shape.shape = handle_rect      # 强制覆盖，不再判断 null

	mass = head.mass_contribution + handle.mass_contribution
	center_of_mass_mode = RigidBody2D.CENTER_OF_MASS_MODE_CUSTOM
	center_of_mass = (
		head.position * head.mass_contribution +
		handle.position * handle.mass_contribution
	) / mass
