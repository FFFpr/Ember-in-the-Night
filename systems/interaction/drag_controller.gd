# res://systems/interaction/drag_controller.gd
class_name DragController
extends Node2D

var _hand_anchor: StaticBody2D
var _pin_joint: PinJoint2D
var _grabbed_body: RigidBody2D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_try_grab()
		else:
			_release()

func _try_grab() -> void:
	var click_pos := get_global_mouse_position()

	var query := PhysicsPointQueryParameters2D.new()
	query.position = click_pos
	query.collide_with_bodies = true
	var space_state := get_world_2d().direct_space_state
	var results := space_state.intersect_point(query)

	if results.is_empty():
		return

	var collider = results[0].collider
	if not (collider is RigidBody2D):
		return

	_grabbed_body = collider

	# 关键：锚点和关节都放在"实际点击的世界坐标"，不是物体中心，也不是预先摆好的节点位置
	_hand_anchor = StaticBody2D.new()
	_hand_anchor.global_position = click_pos
	get_tree().current_scene.add_child(_hand_anchor)

	_pin_joint = PinJoint2D.new()
	_pin_joint.global_position = click_pos
	get_tree().current_scene.add_child(_pin_joint)
	_pin_joint.node_a = _hand_anchor.get_path()
	_pin_joint.node_b = _grabbed_body.get_path()

	_grabbed_body.freeze = false   # 重力、旋转始终交给物理引擎

func _physics_process(_delta: float) -> void:
	if _hand_anchor:
		_hand_anchor.global_position = get_global_mouse_position()

func _release() -> void:
	if _pin_joint:
		_pin_joint.queue_free()
	if _hand_anchor:
		_hand_anchor.queue_free()
	_grabbed_body = null
