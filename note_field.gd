extends Node2D

const Note = preload("res://note.gd")
const Song = preload("res://song.gd")

## The minimum space from the center of notes to the edge of the screen
@export var vertical_gutter := 50

## The distance from the center of the receptor to the left edge of the screen
## (leftmost edge of the playfield)
@export var receptor_offset := 80

## The scroll speed and spacing of notes in pixels per second
@export var scroll_speed := 150

var current_time := 0.0
var receptor_position := 0.5

@onready var notes: Node2D = %Notes
@onready var receptor: Node2D = %Receptor

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
	receptor.position = get_screen_position(0, receptor_position)


func _process(delta: float) -> void:
	notes.position.x = current_time * scroll_speed * -1
