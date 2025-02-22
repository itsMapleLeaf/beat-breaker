class_name Player
extends Node2D

const VERTICAL_SECOND_DISTANCE := 256.0
const TIMING_WINDOW: float = (80 / 1000.0) # easier to think in ms but calc in seconds

@export var playing := false
@export var cursor_position_input := 0.5

@onready var cursor: Polygon2D = %Cursor
@onready var receptor: Receptor = %Receptor
@onready var chart: Node2D = %Chart

@export var time := 0.0:
	set(new_time):
		time = new_time
		chart.position.y = VERTICAL_SECOND_DISTANCE * time


func _process(delta: float) -> void:
	if playing:
		time += delta
		
	_update_cursor(delta)
	
	
func _update_cursor(delta: float) -> void:
	cursor_position_input = clampf(cursor_position_input, 0, 1)
	
	var target := get_visual_horizontal_position(cursor_position_input)
	var rotation_target := target - cursor.global_position.x
	
	cursor.global_position.x = lerpf(
		cursor.global_position.x,
		target,
		clampf(delta / 0.02, 0, 1)
	)
	
	cursor.rotation_degrees = lerpf(
		cursor.rotation_degrees,
		rotation_target,
		clampf(delta / 0.1, 0, 1)
	)
	

func tap_note() -> void:
	receptor.flash()
	
	for note: Node2D in chart.get_children():
		if not note.visible: continue
		
		var note_second := absf(note.position.y / VERTICAL_SECOND_DISTANCE)
		if absf(time - note_second) <= TIMING_WINDOW:
			note.visible = false
			break


func get_visual_horizontal_position(normal: float) -> float:
	return lerpf(receptor.left_bound, receptor.right_bound, cursor_position_input)
