class_name Note
extends Node2D

const HoldPoint = preload("res://hold_point.gd")
const NoteField = preload("res://note_field.gd")

enum State {
	LIVE,
	SCORED,
	MISSED,
}

var time := 0.0
var placement := 0.0
var is_tap := false
var is_placement_complete := false
var is_tap_complete := false
var state := State.LIVE

@onready var hold_points: Node2D = %HoldPoints
@onready var hold_body: Line2D = %HoldBody


func _ready() -> void:
	hold_body.clear_points()


func add_hold_point(relative_time: float, relative_placement: float, note_field: NoteField) -> void:
	var hold_point := preload("res://hold_point.tscn").instantiate()
	hold_point.time = relative_time
	hold_point.placement = relative_placement
	hold_point.position.x = relative_time * note_field.scroll_speed
	hold_point.position.y = relative_placement * note_field.field_rect.size.y
	hold_points.add_child(hold_point)
	
	hold_body.clear_points()
	hold_body.add_point(Vector2(0, 0))
	for point: Node2D in hold_points.get_children():
		hold_body.add_point(point.position)


func score() -> void:
	state = State.SCORED
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED


func miss() -> void:
	state = State.MISSED
	modulate.a = 0.5
	process_mode = Node.PROCESS_MODE_DISABLED
