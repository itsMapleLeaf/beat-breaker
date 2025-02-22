class_name Receptor
extends Node2D

@onready var mesh: MeshInstance2D = %Mesh

var left_bound: float:
	get:
		return mesh.global_position.x - mesh.global_scale.x / 2

var right_bound: float:
	get:
		var rect := mesh.get_viewport_rect()
		return mesh.global_position.x + mesh.global_scale.x / 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	mesh.modulate.a = maxf(mesh.modulate.a - delta / 0.25, 0.25)

func flash() -> void:
	mesh.modulate.a = 1
