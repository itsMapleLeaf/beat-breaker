extends Node2D
class_name Game

@onready var player := %Player as Player
@onready var debug_text: Label = %DebugText
@onready var chart: Control = %Chart

@export var player_rotation_strength := 10.0
@export_range(0, 50, 1) var edge_distance := 0
@export_range(0, 2, 0.05) var sensitivity := 1.0

var position_input := 0.5
var first_mouse_input_processed := false
var time := -2.0

var viewport_width: float:
	get: return get_viewport_rect().size.x

func _init() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	time += delta
	chart.position.y = time * 100

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# ignore the first mouse input, so the player position jump suddenly
		if not first_mouse_input_processed:
			first_mouse_input_processed = true
			return
		
		var prev_position_input := position_input
		position_input = clampf(position_input + (event.relative.x / viewport_width) * sensitivity, 0, 1)
		
		player.global_position.x = _get_playfield_x_position(position_input)
		player.set_target_rotation((position_input - prev_position_input) * player_rotation_strength)
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _get_playfield_x_position(normal_position: float) -> float:
	return lerpf(edge_distance, viewport_width - edge_distance, position_input)
