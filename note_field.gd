class_name NoteField
extends Node2D

const TIMING_WINDOW = 0.150
const POSITION_WINDOW = 0.05

## The minimum space from the center of notes to the edge of the screen
@export var vertical_gutter := 50

## The distance from the center of the receptor to the left edge of the screen
## (leftmost edge of the playfield)
@export var receptor_offset := 80

## The scroll speed and spacing of notes in pixels per second
@export var scroll_speed := 150

@onready var notes: Node2D = %Notes
var current_note_index := 0

@onready var receptor: Node2D = %Receptor
var receptor_position := 0.5

var current_time := 0.0

var field_rect: Rect2:
	get: return get_viewport_rect().grow_individual(
		- receptor_offset,
		- vertical_gutter,
		0,
		- vertical_gutter)


var field_top: float:
	get: return field_rect.position.y


var field_bottom: float:
	get: return field_rect.position.y + field_rect.size.y


func get_screen_position(time: float, placement: float) -> Vector2:
	var x := field_rect.position.x + time * scroll_speed
	var y := lerpf(field_top, field_bottom, placement)
	return Vector2(x, y)
	
	
func add_note(time: float, placement: float) -> Note:
	var note := preload("res://note.tscn").instantiate()
	note.time = time
	note.placement = placement
	note.position = get_screen_position(time, placement)
	notes.add_child(note)
	return note


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	notes.position.x = current_time * scroll_speed * -1
	receptor.position = get_screen_position(0, receptor_position)
	_handle_current_note()
	
	var movement_positions: Array[float] = []
	
	for index in range(current_note_index, notes.get_child_count()):
		var note: Note = notes.get_child(index)
		movement_positions.append(note.placement)
		
		for hold_point: HoldPoint in note.hold_points.get_children():
			if note.time + hold_point.time > current_time - TIMING_WINDOW:
				movement_positions.append(note.placement + hold_point.placement)
	
	if Input.is_action_just_pressed("move_up"):
		for pos in movement_positions:
			if pos < receptor_position - POSITION_WINDOW:
				receptor_position = pos
				break
			
	if Input.is_action_just_pressed("move_down"):
		for pos in movement_positions:
			if pos > receptor_position + POSITION_WINDOW:
				receptor_position = pos
				break


func _handle_current_note() -> void:
	if current_note_index >= notes.get_child_count(): return
	
	var current_note: Note = notes.get_child(current_note_index)
	var miss_time := current_note.time
	var hold_points := current_note.hold_points.get_children()
	
	var last_hold_point: HoldPoint = hold_points.back()
	if last_hold_point != null:
		miss_time += last_hold_point.time
	
	if miss_time < current_time - TIMING_WINDOW:
		current_note.miss()
		current_note_index += 1
		return
		
	if absf(current_note.placement - receptor_position) < POSITION_WINDOW:
		current_note.is_placement_complete = true
		
	if Input.is_action_just_pressed("tap") \
	and current_note.time <= current_time + TIMING_WINDOW:
		current_note.is_tap_complete = true
		
	for hold_point: HoldPoint in hold_points:
		var absolute_time := current_note.time + hold_point.time
		var absolute_placement := current_note.placement + hold_point.placement
		
		if absf(absolute_placement - receptor_position) < POSITION_WINDOW:
			hold_point.is_placement_complete = true
		
		var is_held_on_time = (
			Input.is_action_pressed("tap")
			and absolute_time >= current_time - TIMING_WINDOW
			and absolute_time < current_time
		)
		
		var was_released_before_time = (
			Input.is_action_just_released("tap")
			and absolute_time <= current_time + TIMING_WINDOW
			and absolute_time >= current_time - TIMING_WINDOW
		)
		
		if is_held_on_time or was_released_before_time:
			hold_point.is_hold_complete = true
			
		if hold_point.is_hold_complete and hold_point.is_placement_complete:
			hold_point.visible = false
			hold_point.process_mode = Node.PROCESS_MODE_DISABLED
		
	if current_note.is_placement_complete \
	and current_note.is_tap_complete \
	and hold_points.all(func (hp: HoldPoint): return hp.is_hold_complete and hp.is_placement_complete):
		current_note.score()
		current_note_index += 1
		
