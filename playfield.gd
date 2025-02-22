extends Node2D

const VERTICAL_SECOND_DISTANCE := 256.0
const TIMING_WINDOW: float = (80 / 1000.0) # easier to think in ms but calc in seconds
const CURSOR_INPUT_SENSITIVITY := 2.0

@export var time := 0.0
@export var playing := false
@export var cursor_position_input := 0.5

@onready var cursor: Polygon2D = %Cursor
@onready var receptor: Receptor = %Receptor
@onready var notes: Node2D = %Notes

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cursor_position_input += event.relative.x * (CURSOR_INPUT_SENSITIVITY / 1000.0)
	
	if event is InputEventKey: if event.is_pressed() and not event.echo:
		_tap_note()

func _process(delta: float) -> void:
	time += delta
	_update_cursor(delta)
	_update_notes(delta)
	
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
	
func _update_notes(delta: float) -> void:
	notes.position.y = VERTICAL_SECOND_DISTANCE * time
	
func _tap_note() -> void:
	for note: Node2D in notes.get_children():
		if not note.visible: continue
		
		var note_second := absf(note.position.y / VERTICAL_SECOND_DISTANCE)
		if absf(time - note_second) <= TIMING_WINDOW:
			note.visible = false
			break

func get_visual_horizontal_position(normal: float) -> float:
	return lerpf(receptor.left_bound, receptor.right_bound, cursor_position_input)
