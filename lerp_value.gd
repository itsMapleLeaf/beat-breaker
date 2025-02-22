class_name LerpValue
extends Node

@export var current: float = 0
@export var target: float = 0
@export_range(1, 100) var stiffness: float = 1

func _init(
	current: float = self.current,
	target: float = self.target,
	stiffness: float = self.stiffness,
) -> void:
	self.current = current
	self.target = target
	self.stiffness = stiffness
	
func _process(delta: float) -> void:
	current = lerpf(current, target, delta * stiffness)
