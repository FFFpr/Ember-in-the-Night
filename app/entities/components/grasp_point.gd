# res://app/entities/components/grasp_point.gd
class_name GraspPoint
extends Node2D

var _target_body: RigidBody2D
var _hand_anchor: StaticBody2D
var _pin_joint: PinJoint2D
var _is_grasped: bool = false

func _ready() -> void:
	_target_body = _find_nearest_rigidbody(self)
	if _target_body == null:
		push_warning("GraspPoint (%s) 找不到父级 RigidBody2D" % name)

func _find_nearest_rigidbody(node: Node) -> RigidBody2D:
	var current := node.get_parent()
	while current != null:
		if current is RigidBody2D:
			return current
		current = current.get_parent()
	return null

func _physics_process(_delta: float) -> void:
	var pressed := Input.is_action_pressed("grab")  # 需要在 Project Settings → Input Map 里定义这个动作，绑定鼠标左键

	if pressed and not _is_grasped:
		_start_grasp()
	elif not pressed and _is_grasped:
		_end_grasp()

	if _is_grasped:
		# 手部锚点跟随光标——它只是一个"位置标记"，本身不参与物理运算
		_hand_anchor.global_position = get_global_mouse_position()

func _start_grasp() -> void:
	if _target_body == null:
		return
	_is_grasped = true

	_hand_anchor = StaticBody2D.new()
	_hand_anchor.global_position = get_global_mouse_position()
	get_tree().current_scene.add_child(_hand_anchor)

	_pin_joint = PinJoint2D.new()
	_pin_joint.global_position = global_position   # 约束点＝这个 GraspPoint 当前在世界里的位置
	get_tree().current_scene.add_child(_pin_joint)
	_pin_joint.node_a = _hand_anchor.get_path()
	_pin_joint.node_b = _target_body.get_path()

	_target_body.freeze = false   # 确保重力、旋转完全交给物理引擎

func _end_grasp() -> void:
	_is_grasped = false
	if _pin_joint:
		_pin_joint.queue_free()
	if _hand_anchor:
		_hand_anchor.queue_free()
