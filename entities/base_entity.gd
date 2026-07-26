# res://entities/object.gd
class_name BaseEntity
extends RigidBody2D

@export var entity_material: BaseMaterial

func _ready() -> void:
	if entity_material:
		var override := PhysicsMaterial.new()
		override.friction = entity_material.friction
		override.bounce = entity_material.bounciness
		physics_material_override = override
