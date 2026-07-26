# res://entities/hammer_part.gd
class_name HammerPart
extends Node2D          # 注意：不是 RigidBody2D，只是数据+形状的子节点

@export var entity_material: BaseMaterial
@export var mass_contribution: float = 1.0
