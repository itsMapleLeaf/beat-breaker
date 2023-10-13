extends Node2D
class_name Player

@export var rotation_stiffness := 15.0
@export var rotation_drag := 15.0
@export var rotation_limit := 2.0

@onready var sprite: Sprite2D = %Sprite

var _target_rotation := 0.0

func set_target_rotation(new_target_rotation: float) -> void:
	_target_rotation = clampf(new_target_rotation, -rotation_limit, rotation_limit)

func _process(delta: float) -> void:
	sprite.rotation = lerpf(sprite.rotation, _target_rotation, delta * rotation_stiffness)
	_target_rotation = lerpf(_target_rotation, 0, delta * rotation_drag)
