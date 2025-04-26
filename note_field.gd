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
@onready var receptor: Node2D = %Receptor
var receptor_position := 0.5

var current_time := 0.0

## The index of the first note still in play.
## Used as an optimization to prevent searching through notes that are already missed
var first_live_note_index := 0

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


func is_within_timing_window(time: float) -> bool:
	return time > current_time - TIMING_WINDOW and time < current_time + TIMING_WINDOW


func is_past_timing_window(time: float) -> bool:
	return time < current_time - TIMING_WINDOW


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	notes.position.x = current_time * scroll_speed * -1
	receptor.position = get_screen_position(0, receptor_position)
	
	# keep the index of the first live note up to date
	while first_live_note_index < notes.get_child_count():
		var note: Note = notes.get_child(first_live_note_index)
		var end_time := note.time
		var last_hold_point: HoldPoint = note.hold_points.get_children().back()
		
		if last_hold_point != null:
			end_time += last_hold_point.time
		
		if is_past_timing_window(end_time):
			first_live_note_index += 1
		else:
			break
			
	var live_notes := notes.get_children().slice(first_live_note_index)
	
	# snap to an upcoming note position
	if Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down"):
		var movement_positions: Array[float] = []
		
		for note: Note in live_notes:
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
	
	# find and mark notes tapped
	if Input.is_action_just_pressed("tap"):
		for note: Note in live_notes:
			if is_within_timing_window(note.time):
				note.is_tap_complete = true
				break # only once per tap
	
	# find and mark hold points that are held
	if Input.is_action_pressed("tap") or Input.is_action_just_released("tap"):
		for note: Note in live_notes:
			for hold_point: HoldPoint in note.hold_points.get_children():
				if not hold_point.visible: continue
				
				var hold_point_time := note.time + hold_point.time
				
				var held_at_time = (
					Input.is_action_pressed("tap")
					and hold_point_time >= current_time - TIMING_WINDOW
					and hold_point_time <= current_time
				)
				
				var released_within_time = (
					Input.is_action_just_released("tap")
					and hold_point_time >= current_time - TIMING_WINDOW
					and hold_point_time <= current_time + TIMING_WINDOW
				)
				
				if held_at_time or released_within_time:
					hold_point.is_hold_complete = true
				else:
					break
				
	# find and mark placement completion (when the receptor is lined up with a note while in the timing window)
	for note: Note in live_notes:
		var distance := absf(receptor_position - note.placement)
		if distance < POSITION_WINDOW and is_within_timing_window(note.time):
			note.is_placement_complete = true
		
		for hold_point: HoldPoint in note.hold_points.get_children():
			var hold_point_distance := absf(note.placement + hold_point.placement - receptor_position)
			if hold_point_distance < POSITION_WINDOW and is_within_timing_window(note.time + hold_point.time):
				hold_point.is_placement_complete = true
				
	# score notes with satisfied completions
	for note: Note in live_notes:
		if note.is_tap_complete and note.is_placement_complete:
			note.head_sprite.visible = false
			note.modulate = Color("#559eff")
			
			for hold_point: HoldPoint in note.hold_points.get_children():
				if hold_point.is_hold_complete and hold_point.is_placement_complete:
					hold_point.visible = false
				elif hold_point.visible and is_past_timing_window(note.time + hold_point.time):
					note.visible = false
					note.process_mode = Node.PROCESS_MODE_DISABLED
					break
					
			if not note.visible:
				break
